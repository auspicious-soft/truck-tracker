import 'dart:async';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';

class LocationServices {
  LocationServices._privateConstructor();

  static final LocationServices _instance =
      LocationServices._privateConstructor();

  factory LocationServices() {
    return _instance;
  }
  checkGPSService() async {
    return await Geolocator.isLocationServiceEnabled();
  }
  Future<Position?> getGPSLocation() async {
     final geoLocations = await _determinePosition();
    final latitude = geoLocations.latitude;
    final lngi = geoLocations.longitude;
    if (latitude == 0.0) {
      Fluttertoast.showToast(msg: 'lati is 0.0');
      return null;
    } else {
      return geoLocations;
    }
  }

  Future<Position> _determinePosition() async {
    //  bool serviceEnabled;
    LocationPermission permission;

    ///serviceEnabled = await Geolocator.isLocationServiceEnabled();
    // if (!serviceEnabled) {
    //   Fluttertoast.showToast(msg: 'Please enable location');
    //   Geolocator.openLocationSettings();
    //
    //   return Future.error('Location services are disabled.');
    // }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        Fluttertoast.showToast(msg: 'Location permissions are denied');
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(
          msg:
              'Location permissions are permanently denied, we cannot request permissions.');
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    // showProgress(context);
    return await Geolocator.getCurrentPosition();
  }

  void printException(Object e) {
    print('EXCEPTION:::: $e');
  }
}
