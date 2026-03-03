import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';
import 'package:lanka_go/constance/colors.dart';
import 'package:lanka_go/widgets/custom_appbar.dart';

class SriLankaMapPage extends StatefulWidget {
  const SriLankaMapPage({super.key});

  @override
  State<SriLankaMapPage> createState() => _SriLankaMapPageState();
}

class _SriLankaMapPageState extends State<SriLankaMapPage> {
  late GoogleMapController _mapController;
  final TextEditingController _searchController = TextEditingController();
  final Set<Marker> _markers = {};

  static const LatLng _sriLankaCenter = LatLng(7.8731, 80.7718); // center of Sri Lanka
  LatLng _currentCenter = _sriLankaCenter;

  @override
  void initState() {
    super.initState();
    _loadMarkers();
  }

  // Load markers from Firestore
  Future<void> _loadMarkers() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('user_recommendations')
        .get();

    Set<Marker> newMarkers = {};
    for (var doc in snapshot.docs) {
      final data = doc.data();
      final district = data['district'] ?? '';
      try {
        List<Location> locations = await locationFromAddress('$district, Sri Lanka');
        if (locations.isNotEmpty) {
          final loc = locations.first;
          newMarkers.add(Marker(
            markerId: MarkerId(doc.id),
            position: LatLng(loc.latitude, loc.longitude),
            infoWindow: InfoWindow(
              title: data['district'],
              snippet: 'People: ${data['numberOfPeople']}, Budget: ${data['budget']}',
            ),
          ));
        }
      } catch (e) {
        debugPrint('Geocoding failed for $district: $e');
      }
    }

    setState(() => _markers.addAll(newMarkers));
  }

  // Search district
  Future<void> _searchLocation() async {
    String query = _searchController.text.trim();
    if (query.isEmpty) return;

    try {
      List<Location> locations = await locationFromAddress('$query, Sri Lanka');
      if (locations.isNotEmpty) {
        final loc = locations.first;
        _mapController.animateCamera(CameraUpdate.newLatLngZoom(
            LatLng(loc.latitude, loc.longitude), 10));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Location not found: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryYellowLight,
      appBar: CustomAppBar(title: "Sri Lanka Map"),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search district',
                      fillColor: kMainWhite,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _searchLocation,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: kBtnPrimary,
                      foregroundColor: kMainWhite),
                  child: const Text('Search'),
                )
              ],
            ),
          ),
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _currentCenter,
                zoom: 7.5,
              ),
              markers: _markers,
              onMapCreated: (controller) => _mapController = controller,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              zoomControlsEnabled: true,
            ),
          ),
        ],
      ),
    );
  }
}
