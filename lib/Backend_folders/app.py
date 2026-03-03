from flask import Flask, request, jsonify
import pandas as pd
import joblib
from sklearn.metrics.pairwise import cosine_similarity
import os
import unicodedata
import re

app = Flask(__name__)

# =========================================================
# BASE DIRECTORY
# =========================================================
BASE_DIR = os.path.dirname(os.path.abspath(__file__))

# =========================================================
# LOAD STAYS MODEL FILES
# =========================================================
STAYS_DIR = os.path.join(BASE_DIR, "stays_backend")
stays_vectorizer = joblib.load(os.path.join(STAYS_DIR, "vectorizer.pkl"))
stays_features = joblib.load(os.path.join(STAYS_DIR, "feature_vectors.pkl"))
stays_df = pd.read_pickle(os.path.join(STAYS_DIR, "stays_df.pkl"))

# =========================================================
# LOAD CAFES MODEL FILES
# =========================================================
CAFE_DIR = os.path.join(BASE_DIR, "cafe_backend")
cafe_model = joblib.load(os.path.join(CAFE_DIR, "cafe_model.pkl"))
cafe_preprocessor = joblib.load(os.path.join(CAFE_DIR, "preprocessor.pkl"))
cafes_df = pd.read_csv(os.path.join(CAFE_DIR, "Cafes.csv"))
cafes_df.columns = cafes_df.columns.str.strip()

# =========================================================
# LOAD PLACES MODEL FILES
# =========================================================
PLACES_DIR = os.path.join(BASE_DIR, "places_backend")
places_vectorizer = joblib.load(os.path.join(PLACES_DIR, "vectorizer.pkl"))
places_df = pd.read_pickle(os.path.join(PLACES_DIR, "places_df.pkl"))
places_df.columns = places_df.columns.str.strip()

# =========================================================
# TEXT NORMALIZATION
# =========================================================
def normalize_text(text):
    """Lowercase, remove accents, replace ? with space, strip."""
    if not isinstance(text, str):
        return ""
    text = text.replace("?", " ")
    text = unicodedata.normalize('NFKD', text).encode('ascii', 'ignore').decode('ascii')
    return text.lower().strip()

def extract_url(markdown_text):
    """Extract URL from Markdown [title](url) format."""
    if not isinstance(markdown_text, str):
        return ""
    match = re.search(r'\((https?://[^\)]+)\)', markdown_text)
    if match:
        return match.group(1).strip()
    return markdown_text.strip()

def clean_url(url):
    """Ensure URL has scheme and is trimmed."""
    url = str(url).strip()
    if not url:
        return ""
    if not url.startswith("http://") and not url.startswith("https://"):
        url = "https://" + url
    return url


# =========================================================
# HOME ROUTE
# =========================================================
@app.route("/")
def home():
    return jsonify({"message": "LankaGo Recommendation API Running!"})

# =========================================================
# STAY RECOMMENDATION
# =========================================================
@app.route("/recommend_stay", methods=["POST"])
def recommend_stay():
    try:
        data = request.json
        user_input = (
            data.get("district", "") + " " +
            data.get("accommodation_types", "") + " " +
            data.get("suitable_for", "") + " " +
            data.get("budget_level", "")
        )
        if not user_input.strip():
            return jsonify({"error": "Missing input data"}), 400

        user_vector = stays_vectorizer.transform([user_input])
        similarity = cosine_similarity(user_vector, stays_features)
        top_indices = similarity[0].argsort()[-5:][::-1]

        results = []
        for i in top_indices:
            stay = stays_df.iloc[i]
            results.append({
                "name": stay.get("name", ""),
                "description": str(stay.get("description", "")),
                "contact": extract_url(str(stay.get("url/contact number", "")))
            })

        return jsonify(results)
    except Exception as e:
        return jsonify({"error": str(e)}), 500

# =========================================================
# CAFE RECOMMENDATION
# =========================================================
@app.route("/recommend_cafe", methods=["POST"])
def recommend_cafe():
    try:
        data = request.json
        district_input = normalize_text(data.get("district", ""))
        food_types = [normalize_text(ft) for ft in data.get("foodType", [])]
        suitable_for_list = [normalize_text(sf) for sf in data.get("numberOfPeople", [])]
        budget_level = normalize_text(data.get("budget", ""))

        filtered = cafes_df.copy()

        # District filter
        if district_input and "district" in filtered.columns:
            filtered['district_norm'] = filtered['district'].apply(normalize_text)
            filtered = filtered[filtered['district_norm'] == district_input]

        # Budget filter
        if budget_level and "budget_level" in filtered.columns:
            filtered['budget_norm'] = filtered['budget_level'].apply(normalize_text)
            filtered = filtered[filtered['budget_norm'] == budget_level]

        # Food type filter
        if food_types and "food_type" in filtered.columns:
            filtered['food_type_norm'] = filtered['food_type'].apply(lambda x: [normalize_text(t) for t in str(x).split(",")])
            filtered = filtered[filtered['food_type_norm'].apply(lambda x: any(ft in x for ft in food_types))]

        # Suitable for filter
        if suitable_for_list and "suitable_for" in filtered.columns:
            filtered['suitable_for_norm'] = filtered['suitable_for'].apply(lambda x: [normalize_text(t) for t in str(x).split(",")])
            filtered = filtered[filtered['suitable_for_norm'].apply(lambda x: any(sf in x for sf in suitable_for_list))]

        if filtered.empty:
            return jsonify([])

        # ML scoring
        X = cafe_preprocessor.transform(filtered)
        scores = cafe_model.predict(X)
        filtered["score"] = scores

        top = filtered.sort_values(by="score", ascending=False).head(10)
        top["description"] = top["description"].apply(lambda x: str(x))
        top["url/contact number"] = top["url/contact number"].apply(extract_url).apply(clean_url)

        result = top[["name", "description", "url/contact number"]].fillna("")
        return jsonify(result.to_dict(orient="records"))

    except Exception as e:
        return jsonify({"error": str(e)}), 500

# =========================================================
# PLACES RECOMMENDATION
# =========================================================
@app.route("/recommend_place", methods=["POST"])
def recommend_place():
    try:
        data = request.json
        district_input = normalize_text(data.get("district", ""))
        categories_input = [normalize_text(c) for c in data.get("categories", [])]
        query_desc = data.get("query", "")

        filtered = places_df.copy()
        filtered['district_norm'] = filtered['district'].apply(normalize_text) if "district" in filtered.columns else ""
        filtered['category_norm'] = filtered['category'].apply(normalize_text) if "category" in filtered.columns else ""

        # Filter by district
        if district_input:
            filtered = filtered[filtered['district_norm'] == district_input]

        # Filter by categories (match any)
        if categories_input:
            filtered = filtered[
                filtered['category_norm'].apply(lambda x: x in categories_input)
            ]

        if filtered.empty:
            return jsonify([])

        # Optional similarity scoring
        if query_desc and "description" in filtered.columns:
            desc_vectors = places_vectorizer.transform(filtered["description"])
            query_vector = places_vectorizer.transform([query_desc])
            sims = cosine_similarity(query_vector, desc_vectors)
            filtered = filtered.copy()
            filtered["score"] = sims.flatten()
            filtered = filtered.sort_values("score", ascending=False)

        top = filtered.head(10)
        top["description"] = top["description"].apply(lambda x: str(x))
        top["URL"] = top["URL"].apply(extract_url).apply(clean_url)

        result = top[["name", "description", "URL"]].fillna("")
        return jsonify(result.to_dict(orient="records"))

    except Exception as e:
        return jsonify({"error": str(e)}), 500

# =========================================================
# RUN SERVER
# =========================================================
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
