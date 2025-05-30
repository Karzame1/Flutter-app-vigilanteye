import 'dart:async';

import 'package:background_location_tracker/background_location_tracker.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_activity_recognition/flutter_activity_recognition.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:location/location.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';
import '../utils/app_constants.dart';

class TrackingService {
  Battery battery = Battery();
  int count = 0;
  final Location locationService = Location();
  updateDeviceStatus(double latitude, double longitude) async {
    debugPrint("tracking service call hua h-->updateDevice");
    debugPrint("updated $latitude $longitude");
    // Instantiate it
    var battery = Battery();
    var connectivityResult = await (Connectivity().checkConnectivity());
    var gpsStatus = await Geolocator.isLocationServiceEnabled();
    Map req = {
      "batteryPercentage": await battery.batteryLevel,
      "isGPSOn": gpsStatus,
      "isWifiOn": connectivityResult == ConnectivityResult.wifi,
      "signalStrength": connectivityResult == ConnectivityResult.mobile ? 5 : 0,
      "latitude": latitude,
      "longitude": longitude
    };
    await apiRepo.updateDeviceStatus(req);
  }

  Future updateAttendanceStatus(
      Activity activity, double latitude, double longitude) async {
    debugPrint("tracking service call hua h-->updateAttendance");
    count++;
    if (appStore.getCurrentStatus != null &&
        appStore.getCurrentStatus!.status == 'checkedin') {}
    int confidence = 0;
    switch (activity.confidence) {
      case ActivityConfidence.HIGH:
        confidence = 100;
        break;
      case ActivityConfidence.MEDIUM:
        confidence = 50;
        break;
      case ActivityConfidence.LOW:
        confidence = 20;
        break;
    }

    var gpsStatus = true;
    Map req = {
      "status": "string",
      "accuracy": confidence,
      "activity": activity.type.toString(),
      "latitude": latitude,
      "longitude": longitude,
      "altitude": 0,
      "bearing": 0,
      "locationAccuracy": 0,
      "speed": 0,
      "time": 0,
      "isMock": false,
      "batteryPercentage": await battery.batteryLevel,
      "isGPSOn": gpsStatus,
      "isWifiOn": false,
      "signalStrength": 4
    };
    log(req);
    await apiRepo.updateAttendanceStatus(req);
  }

  Future checkInStatus(String status,String move,String feedback) async {
    var location = await locationService.getLocation();
    var battery = Battery();

    Map req = {
      "user": {
        "user_id": getStringAsync(userIdPref),
        "username": getStringAsync(firstNamePref),
        "battery_level": await battery.batteryLevel,
        "duty_status": status,
        "movement_status": move,
        "feedback": feedback,
        "latitude": location.latitude ?? 0.0,
        "longitude": location.longitude ?? 0.0,
      }
    };
    var result = await apiRepo.checkStatus(req);
    print("klmn--->${result.message}");
    if(!result.isSuccess){
      // toast(result.message);
      return false;
    }
  }

  Future startTrackingService() async {
    setValue(isTrackingOnPref, true);
    final service = FlutterBackgroundService();
    var isRunning = await service.isRunning();
    if (!isRunning) {
      service.startService();
    }
    if (!await BackgroundLocationTrackerManager.isTracking()) {
      await BackgroundLocationTrackerManager.startTracking();
    }
  }

  Future stopTrackingService() async {
    setValue(isTrackingOnPref, false);
    setValue(latitudePref, 0.0);
    setValue(longitudePref, 0.0);
    setValue(locationCountPref, 0);
    setValue(activityCountPref, 0);
    final service = FlutterBackgroundService();
    var isRunning = await service.isRunning();
    if (isRunning) {
      service.invoke("stopService");
    }

    if (await BackgroundLocationTrackerManager.isTracking()) {
      await BackgroundLocationTrackerManager.stopTracking();
    }
  }
}
