import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  // Create a singleton instance of the service
  ConnectivityService._privateConstructor();
  static final ConnectivityService _instance = ConnectivityService._privateConstructor();
  static ConnectivityService get instance => _instance;

  // Stream controller to broadcast connectivity changes
  final StreamController<ConnectivityResult> _connectivityController =
  StreamController<ConnectivityResult>.broadcast();

  // Stream for widgets to listen to
  Stream<ConnectivityResult> get connectivityStream =>
      _connectivityController.stream;

  // Initialize the service
  void initialize() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      _connectivityController.add(result);
    });
  }

  // Check the current connectivity status
  Future<ConnectivityResult> checkConnectivity() async {
    return await Connectivity().checkConnectivity();
  }

  // Dispose the stream controller when no longer needed
  void dispose() {
    _connectivityController.close();
  }
}
