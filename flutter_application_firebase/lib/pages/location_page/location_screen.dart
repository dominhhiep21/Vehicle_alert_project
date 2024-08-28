import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_application_firebase/pages/location_page/my_map.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'location_tracking.dart';

class LocationPage extends StatefulWidget {
  
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  final LocationService _locationService = LocationService();
  final MapController _mapController = MapController();
  Position point1 = Position(longitude: 0, latitude: 0, 
            timestamp: DateTime.now(), accuracy: 0, 
            altitude: 0, altitudeAccuracy: 0, 
            heading: 0, headingAccuracy: 0, 
            speed: 0, speedAccuracy: 0);
  Position point2 = Position(longitude: 0, latitude: 0, 
            timestamp: DateTime.now(), accuracy: 0, 
            altitude: 0, altitudeAccuracy: 0, 
            heading: 0, headingAccuracy: 0, 
            speed: 0, speedAccuracy: 0);
  double meterDistance = 0;
  late WebSocketChannel channel;

  @override
  void initState() {
    super.initState();
    _locationService.startListening(onLocationChanged: _onLocationChanged);

    channel = WebSocketChannel.connect(
      Uri.parse('ws://192.168.4.103:8080'), 
    );

    
    channel.stream.listen((data) {
      try {
        final decodedData = jsonDecode(data);
        if (decodedData.containsKey('latitude') && decodedData.containsKey('longitude')) {
          setState(() {
            LatLng latlngPoint2 = LatLng(decodedData['latitude'], decodedData['longitude']);
            
            point2 = Position(longitude: latlngPoint2.longitude, latitude: latlngPoint2.latitude, 
            timestamp: DateTime.now(), accuracy: 0, 
            altitude: 0, altitudeAccuracy: 0, 
            heading: 0, headingAccuracy: 0, 
            speed: 0, speedAccuracy: 0);

            print('New point2 position: $point2');
            meterDistance = _calculateDistance(point1, point2);
          });
        } else {
          print('Received data does not contain latitude and longitude.');
        }
      } catch (e) {
        print('Error decoding WebSocket message: $e');
      }
    });

  }
  void _onLocationChanged(Position position){
    setState(() {
      point1 = position;
    });
  }

  double _calculateDistance(Position point1, Position point2) {
  return 6378 *
      acos(sin(point1.latitude * pi / 180) * sin(point2.latitude * pi / 180) +
          cos(point1.latitude * pi / 180) *
              cos(point2.latitude * pi / 180) *
              cos((point2.longitude - point1.longitude) * pi / 180));
}

  @override
  void dispose() {
    _locationService.stopListening();
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Tracking Map",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.0), 
          child: Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey, width: 1.0), 
              ),
            ),
          ),
        ),
      ),
      body: Center(
        child: MyMap(
          mapController: _mapController,
          point1: point1,
          point2: point2,
          meterDistance: meterDistance,
        ),
      ),
    );
  }
}
