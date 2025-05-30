import 'dart:async';

import 'package:fieldmanager_hrms_flutter/dialog/sos_alert_dialog.dart';
import 'package:fieldmanager_hrms_flutter/main.dart';
import 'package:fieldmanager_hrms_flutter/screens/Visits/visit_screen.dart';
import 'package:fieldmanager_hrms_flutter/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show PlatformException, rootBundle;
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_darwin/local_auth_darwin.dart';
import 'package:location/location.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:open_settings/open_settings.dart';
import 'package:vibration/vibration.dart';
import 'package:flutter_compass/flutter_compass.dart';

import '../../components/attendance/attendance_status_component.dart';
import '../../utils/app_widgets.dart';
import 'AttendanceStore.dart';

class AttendanceScreen extends StatefulWidget {
  static String tag = '/AttendanceScreen';
  const AttendanceScreen({Key? key, required this.latLong}) : super(key: key);
  final (double,double) latLong;

  @override
  AttendanceScreenState createState() => AttendanceScreenState();
}

class AttendanceScreenState extends State<AttendanceScreen> {
  final AttendanceStore _store = AttendanceStore();
  LatLng _initialCameraPosition = const LatLng(20.5937, 78.9629);
  Timer? timer;

   LocationData? _currentPosition;
  late GoogleMapController _controller;
  List<Marker> markers = [];
  var mMapType = MapType.normal;
  late String _darkMapStyle;
  late String _lightMapStyle;

  //Local Auth
  final LocalAuthentication auth = LocalAuthentication();
  _SupportState _supportState = _SupportState.unknown;
  bool? _canCheckBiometrics;
  List<BiometricType>? _availableBiometrics;
  bool _isAuthenticating = false;
  bool _authorized = false;

  var now = DateTime.now();

  @override
  void initState() {
    super.initState();
    init();
    _loadMapStyles();
    // startAlertsListener();
  }

  void reinitialize() {
    init();
    _loadMapStyles();
  }

  @override
  void dispose() {
    _controller.dispose();
    _store.locationSubscription.cancel();
    if (timer != null) timer!.cancel();
    super.dispose();
  }

  void startAlertsListener() {
    Timer.periodic(const Duration(seconds: 10), (timer) async {
      var result = await _store.loadAlerts();
      if (result.isNotEmpty) {
        timer.cancel();
        if (await Vibration.hasVibrator() ?? false) {
          Vibration.vibrate(duration: 15000, pattern: [500, 1000, 500, 2000]);
        }
        if (!mounted) return;
        await showInDialog(
          context,
          builder: (_) => SosAlertDialog(
            sosAlertModel: result.first,
          ),
          shape: buildRoundedCorner(radius: 16),
        );
        //Start the timer again
        startAlertsListener();
      }
    });
  }
  BitmapDescriptor? carIcon;
  double? _direction;
  void init() async {
    debugPrint('init called');
    await getLocation();
    await BitmapDescriptor.fromAssetImage(
       const  ImageConfiguration(platform: TargetPlatform.android), "images/maps/car.png",mipmaps: false)
        .then((onValue) {
          debugPrint("car_icon  $onValue");
      carIcon = onValue;
      // setState(() {});
    });
   FlutterCompass.events?.listen((CompassEvent event) {
     if(mounted) {
       setState(() {
         _direction = event.heading;
       });
     }
    });
    _store.getData();
    if(mounted) {
      auth.isDeviceSupported().then(
            (bool isSupported) =>
            setState(() =>
            _supportState = isSupported
                ? _SupportState.supported
                : _SupportState.unsupported),
      );
    }
  }

  final LatLng _center = const LatLng(45.521563, -122.677433);

  updateMarkers(Set<Marker> markers) {
    this.markers = markers.toList();
  }

  Future<void> _checkBiometrics() async {
    late bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      canCheckBiometrics = false;
      log(e);
    }
    if (!mounted) {
      return;
    }
    if(mounted) {
      setState(() {
        _canCheckBiometrics = canCheckBiometrics;
      });
    }
  }

  Future<void> _getAvailableBiometrics() async {
    late List<BiometricType> availableBiometrics;
    try {
      availableBiometrics = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      availableBiometrics = <BiometricType>[];
      log(e);
    }
    if (!mounted) {
      return;
    }
    if(mounted) {
      setState(() {
        _availableBiometrics = availableBiometrics;
      });
    }
  }

  Future _authenticate() async {
    bool authenticated = false;
    try {
      if(mounted) {
        setState(() {
          _isAuthenticating = true;
        });
      }

      authenticated = await auth.authenticate(
          localizedReason: language!.lblScanYourFingerprintToCheckIn,
          /*    options: const AuthenticationOptions(
            stickyAuth: true,
            biometricOnly: true,
          ),*/
          authMessages: <AuthMessages>[
            IOSAuthMessages(
              cancelButton: language!.lblCancel,
              goToSettingsButton: language!.lblSettings,
              goToSettingsDescription: language!.lblPleaseSetUpYourTouchId,
              lockOut: language!.lblPleaseReEnableYourTouchId,
            ),
            AndroidAuthMessages(
                signInTitle: language!.lblFingerprintAuthentication,
                //fingerprintRequiredTitle: "Connect to Login",
                cancelButton: language!.lblCancel,
                goToSettingsButton: language!.lblSettings,
                goToSettingsDescription: 'Please setup your fingerprint',
                biometricRequiredTitle:
                    language!.lblAuthenticateWithFingerprintOrPasswordToProceed
                //fingerprintSuccess: "Authentication Successfully authenticated",
                ),
          ]);
      _authorized = authenticated;
      if(mounted) {
        setState(() {
          _isAuthenticating = false;
        });
      }
    } on PlatformException catch (e) {
      log('Auth error$e');
    }

    if (!mounted) return false;
    if(mounted) {
      setState(() {
        _authorized = authenticated;
      });
    }
  }

  Future<void> _authenticateWithBiometrics() async {
    bool authenticated = false;
    try {
      if(mounted) {
        setState(() {
          _isAuthenticating = true;
        });
      }
      authenticated = await auth.authenticate(
        localizedReason:
            'Scan your fingerprint (or face or whatever) to authenticate',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      if(mounted) {
        setState(() {
          _isAuthenticating = false;
        });
      }
    } on PlatformException catch (e) {
      debugPrint(e.toString());
      if(mounted) {
        setState(() {
          _isAuthenticating = false;
        });
      }
      return;
    }

    if (!mounted) {
      return;
    }
    if(mounted) {
      setState(() {
        _authorized = authenticated;
      });
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
    _setMapStyle();
    _store.locationSubscription =
        _store.locationService.onLocationChanged.listen((l) {

          _currentPosition = l;
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(l.latitude!, l.longitude!), zoom: 15),
        ),
      );
    });
  }

  void onMapCreated(GoogleMapController controller) {
    _controller = controller;
  }

  // LatLng destination = const LatLng(38.0000000,-94.0000000);
  LatLng destination = const LatLng(22.731186,75.907835);
  Future <void> getLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    serviceEnabled = await _store.locationService.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _store.locationService.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await _store.locationService.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _store.locationService.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _currentPosition = await _store.locationService.getLocation();

    _store.locationService.onLocationChanged.listen((LocationData locationData) {
      if(_currentPosition != locationData){
        _currentPosition = locationData;
        if(mounted){
        setState(() {});
        }
      }
    });

    _initialCameraPosition = LatLng(_currentPosition!.latitude!, _currentPosition!.longitude!);
   await getPolyLinePoints();
    _store.isLoading = false;

    _controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
            target:
                LatLng(_currentPosition!.latitude!, _currentPosition!.longitude!),
            zoom: 15),
      ),
    );

  }

  Future<void> getPolyLinePoints() async {
    if(widget.latLong.$1 != 0 && widget.latLong.$2 != 0){
      await _store.getPolyPoints(
          _initialCameraPosition, LatLng(widget.latLong.$1, widget.latLong.$2));
    }
  }

  Future _loadMapStyles() async {
    _darkMapStyle = await rootBundle.loadString('assets/map_styles/dark.json');
    _lightMapStyle =
        await rootBundle.loadString('assets/map_styles/light.json');
  }

  Future _setMapStyle() async {
    if (appStore.isDarkModeOn) {
      await _controller.setMapStyle(_darkMapStyle);
    } else {

      await _controller.setMapStyle(_lightMapStyle);
    }
  }

  // List<LatLng> polylineCoordinates = [];
  // void getPolyPoints() async {
  //   PolylinePoints polylinePoints = PolylinePoints();
  //   PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
  //     google_api_key, // Your Google Map Key
  //     PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
  //     PointLatLng(destination.latitude, destination.longitude),
  //   );
  //   if (result.points.isNotEmpty) {
  //     result.points.forEach(
  //           (PointLatLng point) => polylineCoordinates.add(
  //         LatLng(point.latitude, point.longitude),
  //       ),
  //     );
  //     setState(() {});
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    final AlertDialog setPinDialog = AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(16.0),
        ),
      ),
      backgroundColor: appStore.scaffoldBackground,
      title: Text(
        language!.lblNote,
        style: boldTextStyle(color: appStore.textPrimaryColor),
      ),
      content: Text(
        language!.lblFingerprintOrPinVerificationIsRequiredForCheckInAndOut,
        style: secondaryTextStyle(color: appStore.textSecondaryColor),
      ),
      actions: [
        TextButton(
          child: Text(
            language!.lblOpenSecuritySettings,
            style: primaryTextStyle(),
          ),
          onPressed: () {
            OpenSettings.openSecuritySetting();
          },
        ),
        TextButton(
          child: Text(
            language!.lblOk,
            style: primaryTextStyle(color: appColorPrimary),
          ),
          onPressed: () {
            finish(context);
          },
        ),
      ],
    );
    return Scaffold(
        body:
      Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        GoogleMap(
          initialCameraPosition: CameraPosition(target: _initialCameraPosition,zoom: 16),
          mapType: MapType.normal,
          minMaxZoomPreference: const MinMaxZoomPreference(0, 16),
          onMapCreated: _onMapCreated,
          myLocationEnabled: false,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          markers: {
             Marker(
              markerId: const MarkerId("current_location"),
              position: LatLng(_currentPosition?.latitude??22.333535,_currentPosition?.longitude??-96.654598),
               icon:carIcon??BitmapDescriptor.defaultMarker,
               rotation: _direction??0.0 /*_currentPosition?.heading??0.0*/,
               // icon: carIcon!,
               // rotation: _direction!
            ),

            // Marker(
            //   markerId: const MarkerId("source"),
            //   position: _initialCameraPosition,
            //
            // ),
            if(widget.latLong.$1 != 0 && widget.latLong.$2 != 0)
            Marker(
              markerId: const MarkerId("destination"),
              position: LatLng(widget.latLong.$1 , widget.latLong.$2),
            ),
          },
          polylines: {
            if(widget.latLong.$1 != 0 && widget.latLong.$2 != 0)
            Polyline(
                polylineId: const PolylineId("tracking"),
              color: blueViolet,
              points: _store.polylineCoordinates,
              width: 6
            )
          },
        ),
       /*Observer(
          builder: (_) => appStore.getCurrentStatus!.status != 'new' &&
                      appStore.getCurrentStatus!.status == 'checkedin' ||
                  true
              ? Positioned(
                  right: 5,
                  bottom: 170,
                  child: Card(
                    color: white.withOpacity(0.8),
                    elevation: 5,
                    shape: buildRoundedCorner(),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.history,
                            size: 40,
                          ),
                          Text(language!.lblVisitHistory)
                        ],
                      ),
                    ),
                  ).onTap(() {showSosAlert();
                  }),
                )
              : Container(),
        ),*/
        Observer(
          builder: (_) => appStore.getCurrentStatus!.status != 'new' &&
                  appStore.getCurrentStatus!.status == 'checkedin'
              ? Positioned(
                  right: 5,
                  bottom: 150,
                  child: Card(
                    color: white.withOpacity(0.8),
                    elevation: 5,
                    shape: buildRoundedCorner(),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.add_a_photo,
                            size: 40,
                          ),
                          Text(language!.lblMarkVisit)
                        ],
                      ),
                    ),
                  ).onTap(() => const VisitScreen().launch(context)),
                )
              : Container(),
        ),
        Observer(
          builder: (_) => !_store.isLoading
              ? const AttendanceStatusComponent()
              : Card(
                  color: white.withOpacity(0.4),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        loadingWidgetMaker(),
                        Text(
                          'Loading please wait...',
                          style: boldTextStyle(size: 16, color: white),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
        Observer(
          builder: (_) => !_store.isLoading
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Column(
                        children: [
                          appStore.getCurrentStatus!.status == 'checkedout'
                              ? Center(
                                  child: Text(
                                    language!.lblAllDoneForToday,
                                    style: boldTextStyle(),
                                  ),
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    35.height,
                                    Observer(
                                      builder: (_) => Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8.0, right: 8.0, bottom: 28),
                                        child: appStore
                                                    .getCurrentStatus!.status ==
                                                'new'
                                            ? AppButton(
                                                color: opPrimaryColor,
                                                textColor: Colors.white,
                                                width: width - 40,
                                                shapeBorder:
                                                    buildRoundedCorner(),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      language!.lblCheckIn,
                                                      style: primaryTextStyle(
                                                          color: white),
                                                    ),
                                                    5.width,
                                                    const Icon(Icons.login,
                                                        color: white),
                                                  ],
                                                ),
                                                onTap: () async {
                                                  final bool
                                                      canAuthenticateWithBiometrics =
                                                      await auth
                                                          .canCheckBiometrics;
                                                  final bool canAuthenticate =
                                                      canAuthenticateWithBiometrics ||
                                                          await auth
                                                              .isDeviceSupported();
                                                  if (!canAuthenticate) {
                                                    if (!mounted) return;
                                                    showConfirmDialogCustom(
                                                      context,
                                                      title: language!
                                                          .lblAreYouSureYouWantToCheckIn,
                                                      dialogType: DialogType
                                                          .CONFIRMATION,
                                                      positiveText:
                                                          language!.lblYes,
                                                      negativeText:
                                                          language!.lblNo,
                                                      onAccept: (c) async {
                                                        await _store.checkInStatus('On Duty','Moving','Accepted');
                                                        await _store.checkInOut(
                                                            'checkin');
                                                      },
                                                    );
                                                    return;
                                                  }
                                                  if (_supportState ==
                                                      _SupportState.supported) {
                                                    await _authenticate();
                                                    if (_authorized) {
                                                      if (!mounted) return;
                                                      showConfirmDialogCustom(
                                                        context,
                                                        title: language!
                                                            .lblAreYouSureYouWantToCheckIn,
                                                        dialogType: DialogType
                                                            .CONFIRMATION,
                                                        positiveText:
                                                            language!.lblYes,
                                                        negativeText:
                                                            language!.lblNo,
                                                        onAccept: (c) async {
                                                          await _store.checkInStatus('On Duty','Moving','Accepted');
                                                          await _store
                                                              .checkInOut(
                                                                  'checkin');
                                                        },
                                                      );
                                                      return;
                                                    } else {
                                                      if (!mounted) return;
                                                      showConfirmDialogCustom(
                                                        context,
                                                        title: language!
                                                            .lblAreYouSureYouWantToCheckIn,
                                                        dialogType: DialogType
                                                            .CONFIRMATION,
                                                        positiveText:
                                                            language!.lblYes,
                                                        negativeText:
                                                            language!.lblNo,
                                                        onAccept: (c) async {
                                                          await _store.checkInStatus('On Duty','Moving','Accepted');
                                                          await _store
                                                              .checkInOut(
                                                                  'checkin');
                                                        },
                                                      );
                                                    }
                                                  } else {
                                                    if (!mounted) return;
                                                    showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return setPinDialog;
                                                        });
                                                  }
                                                })
                                            : appStore.getCurrentStatus!
                                                        .status ==
                                                    'checkedin'
                                                ? AppButton(
                                                    color: Colors.red.shade600,
                                                    textColor: Colors.white,
                                                    width: width - 40,
                                                    shapeBorder:
                                                        buildButtonCorner(),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          language!.lblCheckOut,
                                                          style:
                                                              primaryTextStyle(
                                                                  color: white),
                                                        ),
                                                        5.width,
                                                        const Icon(Icons.logout,
                                                            color: white),
                                                      ],
                                                    ),
                                                    onTap: () async {
                                                      final bool
                                                          canAuthenticateWithBiometrics =
                                                          await auth
                                                              .canCheckBiometrics;
                                                      final bool
                                                          canAuthenticate =
                                                          canAuthenticateWithBiometrics ||
                                                              await auth
                                                                  .isDeviceSupported();
                                                      if (!canAuthenticate) {
                                                        if (!mounted) return;
                                                        showConfirmDialogCustom(
                                                          context,
                                                          title: language!
                                                              .lblAreYouSureYouWantToCheckOut,
                                                          dialogType: DialogType
                                                              .CONFIRMATION,
                                                          positiveText:
                                                              language!.lblYes,
                                                          negativeText:
                                                              language!.lblNo,
                                                          onAccept: (c) async {
                                                            await _store.checkInStatus('Off Duty','Stationary','Declined');
                                                            await _store
                                                                .checkInOut(
                                                                    'checkout');
                                                          },
                                                        );
                                                        return;
                                                      }
                                                      if (_supportState ==
                                                          _SupportState
                                                              .supported) {
                                                        await _authenticate();
                                                        if (_authorized) {
                                                          if (!mounted) return;
                                                          showConfirmDialogCustom(
                                                            context,
                                                            title: language!
                                                                .lblAreYouSureYouWantToCheckOut,
                                                            dialogType: DialogType
                                                                .CONFIRMATION,
                                                            positiveText:
                                                                language!
                                                                    .lblYes,
                                                            negativeText:
                                                                language!.lblNo,
                                                            onAccept:
                                                                (c) async {
                                                                  await _store.checkInStatus('Off Duty','Stationary','Declined');
                                                              await _store
                                                                  .checkInOut(
                                                                      'checkout');
                                                            },
                                                          );
                                                          return;
                                                        } else {
                                                          if (!mounted) return;
                                                          showConfirmDialogCustom(
                                                            context,
                                                            title: language!
                                                                .lblAreYouSureYouWantToCheckOut,
                                                            dialogType: DialogType
                                                                .CONFIRMATION,
                                                            positiveText:
                                                                language!
                                                                    .lblYes,
                                                            negativeText:
                                                                language!.lblNo,
                                                            onAccept:
                                                                (c) async {
                                                                  await _store.checkInStatus('Off Duty','Stationary','Declined');
                                                              await _store
                                                                  .checkInOut(
                                                                      'checkout');
                                                            },
                                                          );
                                                          return;
                                                        }
                                                      } else {
                                                        if (!mounted) return;
                                                        showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return setPinDialog;
                                                            });
                                                      }
                                                    })
                                                : Container(),
                                      ),
                                    ),
                                  ],
                                ),
                        ],
                      )
                    ],
                  ),
                )
              : Container(),
        )
      ],
    )
    );
  }
}

enum _SupportState {
  unknown,
  supported,
  unsupported,
}