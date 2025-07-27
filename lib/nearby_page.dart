import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class NearbyPage extends StatefulWidget {
  const NearbyPage({super.key});

  @override
  State<NearbyPage> createState() => _NearbyPageState();
}

class _NearbyPageState extends State<NearbyPage> with TickerProviderStateMixin {
  LatLng? _currentLocation;
  List<Map<String, dynamic>> _nearbyBloodBanks = [];
  bool _isLoading = true;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  static bool _hasAnimatedOnce = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeMap();
  }

  void _initializeAnimations() {
    if (!_hasAnimatedOnce) {
      _fadeController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 800),
      );
      _fadeAnimation = CurvedAnimation(
        parent: _fadeController,
        curve: Curves.easeInOut,
      );
      _fadeController.forward();
      _hasAnimatedOnce = true;
    } else {
      _fadeController = AnimationController(vsync: this, value: 1.0);
      _fadeAnimation = CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut);
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _initializeMap() async {
    try {
      Position position = await _determinePosition();
      if (mounted) {
        setState(() {
          _currentLocation = LatLng(position.latitude, position.longitude);
        });
      }

      final snapshot = await FirebaseFirestore.instance.collection('bloodbanks').get();
      final List<Map<String, dynamic>> banks = snapshot.docs.map((doc) => doc.data()).toList();
      if (mounted) {
        setState(() {
          _nearbyBloodBanks = banks;
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error initializing map: $e");
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return Future.error('Location services are disabled.');

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }
    return await Geolocator.getCurrentPosition();
  }

  void _showBloodBankDetails(Map<String, dynamic> bank) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(bank['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [const Icon(Icons.location_on, color: Colors.red), const SizedBox(width: 5), Expanded(child: Text(bank['address'] ?? ''))]),
            const SizedBox(height: 8),
            Row(children: [const Icon(Icons.bloodtype, color: Colors.deepOrange), const SizedBox(width: 5), Expanded(child: Text((bank['blood_required'] as List<dynamic>?)?.join(", ") ?? "N/A"))]),
            const SizedBox(height: 8),
            Row(children: [const Icon(Icons.phone, color: Colors.green), const SizedBox(width: 5), Text(bank['phone'] ?? '')]),
          ],
        ),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.call, color: Colors.green),
            label: const Text("Call"),
            onPressed: () {
              Navigator.pop(context);
              _launchDialer(bank['phone']);
            },
          ),
          TextButton.icon(
            icon: const Icon(Icons.directions, color: Colors.blue),
            label: const Text("Get Directions"),
            onPressed: () {
              Navigator.pop(context);
              _openGoogleMaps(bank['latitude'], bank['longitude']);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _launchDialer(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Could not launch dialer")));
    }
  }

  Future<void> _openGoogleMaps(double latitude, double longitude) async {
    final Uri googleMapsUrl = Uri.parse('https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');
    if (await canLaunchUrl(googleMapsUrl)) {
      await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
    } else {
      print("Could not launch Google Maps.");
    }
  }

  Widget _buildMapView() {
    return FlutterMap(
      options: MapOptions(
        initialCenter: _currentLocation ?? const LatLng(22.3039, 70.8022), // Rajkot default
        initialZoom: 13,
      ),
      children: [
        TileLayer(
          urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
          subdomains: const ['a', 'b', 'c'],
          userAgentPackageName: 'com.example.blood_camp_finder_project',
        ),
        MarkerLayer(
          rotate: true,
          alignment: Alignment.topCenter,
          markers: _nearbyBloodBanks.map((bank) {
            final lat = bank['latitude'];
            final lng = bank['longitude'];
            if (lat is double && lng is double) {
              return Marker(
                point: LatLng(lat, lng),
                // ❗ FIX: Increased marker size
                width: 60,
                height: 60,
                child: GestureDetector(
                  onTap: () => _showBloodBankDetails(bank),
                  child: Image.asset('assets/icon/blood-bank-marker.png'),
                ),
              );
            }
            return null;
          }).whereType<Marker>().toList(),
        ),
        if (_currentLocation != null)
          MarkerLayer(
            rotate: true,
            markers: [
              Marker(
                point: _currentLocation!,
                // ❗ FIX: Increased marker size
                width: 50,
                height: 50,
                child: const Icon(Icons.my_location, color: Colors.blue, size: 35),
              ),
            ],
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [Color(0xFFFF8A95), Color(0xFFFF6B6B)], begin: Alignment.topLeft, end: Alignment.bottomRight),
          ),
        ),
        title: const Text("Nearby Camp Finder", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
        centerTitle: true,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF6B6B))))
          : FadeTransition(
        opacity: _fadeAnimation,
        child: _buildMapView(),
      ),
    );
  }
}