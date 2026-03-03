import 'package:flutter/material.dart';

class DestinationDetailsPage extends StatelessWidget {
  const DestinationDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[50],
      appBar: AppBar(
        backgroundColor: Colors.yellow[700],
        title: const Text(
          'Destinations - Sri Lanka 🇱🇰',
          style: TextStyle(
            color: Colors.brown,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.8,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.brown),
        elevation: 6,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _destinationCard(
            context,
            'Ella Rock Trail',
            'Ella, Sri Lanka',
            'Adventure · Hiking',
            'assets/ella.jpg',
            '4.8',
          ),
          _destinationCard(
            context,
            'Temple of the Tooth',
            'Kandy, Sri Lanka',
            'Cultural · Heritage',
            'assets/kandy.jpg',
            '4.9',
          ),
          _destinationCard(
            context,
            'Mirissa Beach',
            'Mirissa, Sri Lanka',
            'Relaxation · Beachfront',
            'assets/mirissa.jpg',
            '4.7',
          ),
        ],
      ),
    );
  }

  Widget _destinationCard(
    BuildContext context,
    String title,
    String location,
    String type,
    String image,
    String rating,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.asset(
              image,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  location,
                  style: const TextStyle(color: Colors.black54, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  type,
                  style: const TextStyle(color: Colors.orange, fontSize: 13),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      rating,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow[700],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'View Details',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
