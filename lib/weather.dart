import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lanka_go/constance/colors.dart';
import 'package:lanka_go/widgets/custom_appbar.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final String apiKey = "06a6200eeaa15ea2aa0aca1fd3ddfe8d"; 

  final List<String> districts = [
    "Colombo",
    "Gampaha",
    "Kalutara",
    "Kandy",
    "Matale",
    "Nuwara Eliya",
    "Galle",
    "Matara",
    "Hambantota",
    "Jaffna",
    "Kilinochchi",
    "Mannar",
    "Vavuniya",
    "Mullaitivu",
    "Batticaloa",
    "Ampara",
    "Trincomalee",
    "Kurunegala",
    "Puttalam",
    "Anuradhapura",
    "Polonnaruwa",
    "Badulla",
    "Monaragala",
    "Ratnapura",
    "Kegalle",
  ];

  Map<String, dynamic> weatherData = {};

  @override
  void initState() {
    super.initState();
    fetchAllWeather();
  }

  Future<void> fetchAllWeather() async {
    for (String district in districts) {
      final url =
          "https://api.openweathermap.org/data/2.5/weather?q=$district,LK&appid=$apiKey&units=metric";

      try {
        final response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          final data = json.decode(response.body);

          setState(() {
            weatherData[district] = data;
          });
        }
      } catch (e) {
        debugPrint("Error: $e");
      }
    }
  }

  Widget buildWeatherCard(String district) {
    if (!weatherData.containsKey(district)) {
      return const Card(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Text("Loading..."),
          ),
        ),
      );
    }

    final data = weatherData[district];

    if (data == null || data["main"] == null) {
      return const Card(child: Center(child: Text("Error loading")));
    }

    final double temp = data["main"]["temp"].toDouble();
    final String condition = data["weather"][0]["main"];

    return weatherCard(district: district, temp: temp, condition: condition);
  }

  // BEAUTIFUL WEATHER CARD WIDGET
  Widget weatherCard({
    required String district,
    required double temp,
    required String condition,
  }) {
    Color startColor;
    Color endColor;

    if (temp >= 30) {
      startColor = Colors.orange.shade400;
      endColor = Colors.red.shade400;
    } else if (temp >= 20) {
      startColor = Colors.green.shade300;
      endColor = Colors.teal.shade400;
    } else {
      startColor = Colors.lightBlue.shade300;
      endColor = Colors.blue.shade700;
    }

    if (condition.toLowerCase().contains("cloud")) {
      startColor = Colors.grey.shade400;
      endColor = Colors.blueGrey.shade600;
    }

    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [startColor, endColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            district,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "$temp°C",
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            condition,
            style: const TextStyle(fontSize: 16, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Weather in Sri Lanka"),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              kBtnGray,
              kBrownLight,
              const Color.fromARGB(255, 89, 67, 60),
              const Color.fromARGB(255, 89, 67, 60),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: CustomScrollView(
          slivers: [
            //  IMAGE
            SliverToBoxAdapter(
              child: Image.asset("assets/weather.png", fit: BoxFit.cover),
            ),

            // TEXT
            SliverToBoxAdapter(
              child: const Padding(
                padding: EdgeInsets.all(12),
                child: Center(
                  child: Text(
                    "Live Weather Updates",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: kPrimaryYellowDark,
                    ),
                  ),
                ),
              ),
            ),

            //  GRID
            SliverPadding(
              padding: const EdgeInsets.all(10),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate((context, index) {
                  return buildWeatherCard(districts[index]);
                }, childCount: districts.length),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
