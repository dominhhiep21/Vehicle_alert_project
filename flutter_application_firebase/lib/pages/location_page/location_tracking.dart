import 'dart:async';
import 'package:geolocator/geolocator.dart';

class LocationService {
  StreamSubscription<Position>? _positionStreamSubscription;
  Function(Position)? onLocationChanged;

  // Bắt đầu lắng nghe vị trí
  void startListening({required Function(Position) onLocationChanged}) async {
    this.onLocationChanged = onLocationChanged;

    bool serviceEnabled;
    LocationPermission permission;

    // Kiểm tra và yêu cầu quyền truy cập vị trí nếu cần thiết
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    // Lắng nghe vị trí liên tục và gọi hàm onLocationChanged mỗi khi có cập nhật
    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // Cập nhật khi di chuyển ít nhất 10 mét
      ),
    ).listen((Position position) {
      if (onLocationChanged != null) {
        onLocationChanged(position);
      }
    });
  }

  // Dừng lắng nghe vị trí
  void stopListening() {
    _positionStreamSubscription?.cancel();
  }
}