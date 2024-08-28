import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class MyMap extends StatelessWidget {
  const MyMap({
    super.key,
    required MapController mapController,
    required this.point1,
    required this.point2,
    required this.meterDistance,
  }) : _mapController = mapController;

  final MapController _mapController;
  final Position point1;
  final Position point2;
  final double meterDistance;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            minZoom: 5,  // Giới hạn zoom nhỏ nhất
            maxZoom: 18, // Giới hạn zoom lớn nhất
            initialCenter: LatLng(point1.latitude, point1.longitude), // Tọa độ ban đầu // Mức zoom ban đầu
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
              subdomains: const ['a', 'b', 'c'],
            ),
            PolylineLayer(
              polylines: [
                Polyline(
                  points: [LatLng(point1.latitude, point1.longitude), LatLng(point2.latitude, point2.longitude)],
                  strokeWidth: 4.0,
                  color: Colors.blue,
                ),
              ],
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: LatLng(point1.latitude, point1.longitude),
                  width: 80.0,
                  height: 80.0,
                  child: const Icon(
                    Icons.location_pin,
                    color: Colors.red,
                    size: 40,
                  )
                ),
                Marker(
                  point: LatLng(point2.latitude, point2.longitude),
                  width: 80.0,
                  height: 80.0,
                  child: const Icon(
                    Icons.location_pin,
                    color: Colors.red,
                    size: 40,
                  )  
                ),
              ],
            ),
          ],
        ),
        Align(
          alignment: Alignment.center,
          child: Container(
            color: Colors.white.withOpacity(0.7),
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '${(meterDistance).toStringAsFixed(2)} km',
              style: const TextStyle(fontSize: 16.0),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: FloatingActionButton(
              onPressed: () {
                _mapController.move(LatLng(point2.latitude, point2.longitude), 13);
              },
              child: const Icon(Icons.gps_fixed),
            ),
          ),
        ),
      ],
    );
  }
}
