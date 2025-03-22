import 'dart:async';
import 'dart:convert';

import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:mobx/mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../Utils/app_constants.dart';
import '../../main.dart';
import '../../models/sos_model.dart';

part 'AttendanceStore.g.dart';

class AttendanceStore = AttendanceStoreBase with _$AttendanceStore;

abstract class AttendanceStoreBase with Store {
  final Location locationService = Location();

  late StreamSubscription<LocationData> locationSubscription;

  List<SosAlertModel> sosAlerts = [];


  List<LatLng> polylineCoordinates = [];
  Future<void> getPolyPoints(sourceLocation, destination) async {
    polylineCoordinates.clear();
    PolylinePoints polylinePoints = PolylinePoints();
    try{
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleApiKey: "AIzaSyB8FqsngMx4_4R7X9uUjECoTKuUXIARiE8",///google map key
         request: PolylineRequest(
           destination:PointLatLng(destination.latitude, destination.longitude),
           origin:  PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
           mode: TravelMode.driving, ),
      );
      debugPrint('poly points ${result.points}');
      if (result.points.isNotEmpty) {
        for (var point in result.points) {
          polylineCoordinates.add(
            LatLng(point.latitude, point.longitude),
          );
        }
      }
    }catch (e){
      debugPrint("error---> $e");
    }

  }



  @observable
  bool isLoading = true;

  Future<List<SosAlertModel>> loadAlerts() async {
    return await apiRepo.getAlerts();
  }

  void getData() async {
    isLoading = true;
    var statusResult = await apiRepo.checkAttendanceStatus();
    if (statusResult != null) {
      appStore.setCurrentStatus(statusResult);
    }
    isLoading = false;
  }

  Future checkInOut(String status) async {
    isLoading = true;
    var location = await locationService.getLocation();
    var battery = Battery();
    var connectivityResult = await (Connectivity().checkConnectivity());
    Map req = {
      "status": status,
      "latitude": location.latitude,
      "longitude": location.longitude,
      "altitude": location.altitude ?? 0,
      "bearing": 0,
      "locationAccuracy": location.accuracy ?? 0,
      "speed": location.speed ?? 0,
      "time": location.time ?? 0,
      "isMock": location.isMock ?? false,
      "batteryPercentage": await battery.batteryLevel,
      "isLocationOn": true,
      "isWifiOn": connectivityResult == ConnectivityResult.wifi,
      "signalStrength": connectivityResult == ConnectivityResult.mobile ? 5 : 0
    };

    var result = await apiRepo.checkInOut(req);
    if (!result.isSuccess) {
      toast(result.message);
      return false;
    }
    var statusResult = await apiRepo.checkAttendanceStatus();
    if (statusResult != null) {
      appStore.setCurrentStatus(statusResult);
    }
    if (status == 'checkin') {
      trackingService.startTrackingService();
    } else {
      trackingService.stopTrackingService();
    }
    toast('Successfully $status');
    isLoading = false;
    return true;
  }

  Future checkInStatus(String status,String move,String feedback) async {
    isLoading = true;
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
    print("oooo--->$req");
    var result = await apiRepo.checkStatus(req);
    print("llll--->${result.message}");
    if(!result.isSuccess){
      toast(result.message);
      return false;
    }
  }
}
