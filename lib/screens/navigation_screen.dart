import 'dart:async';
import 'package:disable_battery_optimization/disable_battery_optimization.dart';
import 'package:fieldmanager_hrms_flutter/dialog/sos_alert_dialog.dart';
import 'package:fieldmanager_hrms_flutter/main.dart';
import 'package:fieldmanager_hrms_flutter/models/sos_model.dart';
import 'package:fieldmanager_hrms_flutter/models/user_profile_model.dart';
import 'package:fieldmanager_hrms_flutter/screens/Attendance/AttendanceScreen.dart';
import 'package:fieldmanager_hrms_flutter/screens/Banned/banned_screen.dart';
import 'package:fieldmanager_hrms_flutter/screens/Chat/ChattingScreen.dart';
import 'package:fieldmanager_hrms_flutter/screens/Client/client_screen.dart';
import 'package:fieldmanager_hrms_flutter/screens/Expense/ExpenseScreen.dart';
import 'package:fieldmanager_hrms_flutter/screens/Leave/LeaveScreen.dart';
import 'package:fieldmanager_hrms_flutter/screens/Wallet/wallet_screen.dart';
import 'package:fieldmanager_hrms_flutter/utils/app_colors.dart';
import 'package:fieldmanager_hrms_flutter/utils/app_widgets.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_activity_recognition/flutter_activity_recognition.dart';
import 'package:geolocator/geolocator.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:package_info/package_info.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/app_constants.dart';
import '../utils/app_images.dart';
import 'Dashboard/DashboardScreen.dart';
import 'Login/LoginScreen.dart';
import 'Permission/ios_permission_screen.dart';
import 'Permission/permissions_screen.dart';
import 'Settings/settings_screen.dart';

class NavigationScreen extends StatefulWidget {
  static String tag = '/NavigationScreen';
  const NavigationScreen({Key? key}) : super(key: key);

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  final activityRecognition = FlutterActivityRecognition.instance;
  var _currentIndex = 0;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  late Timer timer;

  @override
  void initState() {
    super.initState();
    _currentIndex = 0;
    checkPermissions();
    init();
    setupFirebase();
  }

  StreamSubscription? _sub;
  (double, double) _latlong = (0, 0);
  Future<void> initUniLinks() async {
    // // ... check initialLink
    // try {
    //   final initialLink = await getInitialLink();
    //   // Parse the link and warn the user, if it is not correct,
    //   // but keep in mind it could be `null`.
    // } on PlatformException {
    //   // Handle exception by warning the user their action did not succeed
    //   // return?
    // }

    // Attach a listener to the stream
    _sub = linkStream.listen((String? link) async {
      debugPrint("link $link");
      if (link != null) {
        Uri uri = Uri.parse(link);
        debugPrint("query parameters -> ${uri.queryParameters}");
        if (uri.queryParameters["msg"] != null) {
          debugPrint("query parameters -> ${uri.queryParameters}");
          Future.delayed(Duration.zero, () {
            ChattingScreen(
              alertMsg: uri.queryParameters["msg"],
            ).launch(context, isNewTask: true);
          });
        }
      }
      // Parse the link and warn the user, if it is not correct
    }, onError: (err) {
      // Handle exception by warning the user their action did not succeed
    });

    // NOTE: Don't forget to call _sub.cancel() in dispose()
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void setupFirebase() {
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      log("message received fdgfggf${event.data}");
      log("event hua h ${event.data["alert_id"]}");
      log(event.notification!.body);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              backgroundColor: appStore.isDarkModeOn ? black : white,
              child: SosAlertDialog(
                sosAlertModel: SosAlertModel(
                    id: event.data["alert_id"],
                    userName: event.data["user_Name"],
                    userPhone: event.data["user_Phone"],
                    message: event.data["alert_message"],
                    // message: event.notification!.body,
                    userImage: event.data["user_Img"],
                    type: event.data["alert_type"],
                    latitude: event.data["Latitude"],
                    longitude: event.data["Longitude"]),
                onLocateVictim: (lat, long) async {
                  try {
                    debugPrint("kite-->${event.data}");
                    /*final updated = await apiRepo.updateAlertStatus(event.data["id"]??'');

                        if(!updated){
                          toast("Not updated!, please try again!,");
                          return;
                        }*/
                    setState(() {
                      if (lat != null && long != null) {
                        _latlong = (lat, long);
                        _currentIndex = 0;
                        attendanceScreenKey.currentState?.reinitialize();
                      } else {
                        _latlong = (0, 0);
                      }
                    });
                  } on Exception catch (e) {
                    debugPrint("error $e");
                    toast(e.toString());
                  }
                },
              ),
            );
          });
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage event) {
      debugPrint("notification data aaya  --> ${event.data}");
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              backgroundColor: appStore.isDarkModeOn ? black : white,
              child: SosAlertDialog(
                sosAlertModel: SosAlertModel(
                    id: event.data["alert_id"],
                    userName: event.data["user_Name"],
                    userPhone: event.data["user_Phone"],
                    message: event.data["alert_message"],
                    // message: event.notification!.body,
                    userImage: event.data["user_Img"],
                    type: event.data["alert_type"],
                    latitude: event.data["Latitude"],
                    longitude: event.data["Longitude"]),
                onLocateVictim: (lat, long) async {
                  try {
                    /*final updated = await apiRepo.updateAlertStatus(event.data["id"]??'');
                      if(!updated){
                        toast("Not updated!, please try again!,");
                        return;
                      }*/
                    setState(() {
                      if (lat != null && long != null) {
                        _latlong = (lat, long);
                        _currentIndex = 0;
                        attendanceScreenKey.currentState?.reinitialize();
                      } else {
                        _latlong = (0, 0);
                      }
                    });
                  } on Exception catch (e) {
                    debugPrint("error $e");
                    toast(e.toString());
                  }
                },
              ),
            );
          });
    });
    FirebaseMessaging.instance.getInitialMessage().then((event) {
      if (event != null) {
        debugPrint("notification from background  --> ${event.data}");
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                backgroundColor: appStore.isDarkModeOn ? black : white,
                child: SosAlertDialog(
                  sosAlertModel: SosAlertModel(
                      id: event.data["alert_id"],
                      userName: event.data["user_Name"],
                      userPhone: event.data["user_Phone"],
                      message: event.data["alert_message"],
                      // message: event.notification!.body,
                      userImage: event.data["user_Img"],
                      type: event.data["alert_type"],
                      latitude: event.data["Latitude"],
                      longitude: event.data["Longitude"]),
                  onLocateVictim: (lat, long) async {
                    try {
                      /*final updated = await apiRepo.updateAlertStatus(
                            event.data["id"] ?? '');
                        if (!updated) {
                          toast("Not updated!, please try again!,");
                          return;
                        }*/
                      setState(() {
                        if (lat != null && long != null) {
                          _latlong = (lat, long);
                          _currentIndex = 0;
                          attendanceScreenKey.currentState?.reinitialize();
                        } else {
                          _latlong = (0, 0);
                        }
                      });
                    } on Exception catch (e) {
                      debugPrint("error $e");
                      toast(e.toString());
                    }
                  },
                ),
              );
            });
      }
    });
  }

  User? _userProfileModel;
  void getUserProfile() async {
    debugPrint("like Bhai===>${sharedHelper.getUserId()}");
    // var result = await apiRepo.getUserProfile(getStringAsync(userIdPref));
    var result = await apiRepo.getUserProfile(sharedHelper.getUserId());
    debugPrint("data ayya h --> ${result!.shift?.title}");
    _userProfileModel = result;
    setState(() {});
  }

  void init() async {
    getUserProfile();
    if (isIOS) {
      setDarkStatusBar();
    } else {
      disableBatteryOptimization();
    }
    initUniLinks();
    timer = Timer.periodic(const Duration(minutes: 10), (timer) async {
      if (getBoolAsync(isLoggedInPref)) {
        var result = await apiRepo.checkAttendanceStatus();
        log("attendance status-->$result");
        if (result != null) {
          if (result.userStatus == 'inactive') {
            timer.cancel();
            if (!mounted) return;
            toast(language!.lblYourAccountIsBanned);
            const BannedScreen().launch(context, isNewTask: true);
          }
          appStore.setCurrentStatus(result);
          debugPrint("fine value-->${result.status}");
          if (result.status == "checkedin" && await hasPermission()) {
            trackingService.startTrackingService();
            trackingService.checkInStatus('On Duty','Moving','Accepted');
          } else {
            trackingService.stopTrackingService();
            trackingService.checkInStatus('Off Duty','Stationary','Declined');
          }
        } else {
          trackingService.stopTrackingService();
        }
      }
    });
  }

  Future<void> disableBatteryOptimization() async {
    bool? isAllBatteryOptimizationDisabled =
        await DisableBatteryOptimization.isAllBatteryOptimizationDisabled;
    if (isAllBatteryOptimizationDisabled != null &&
        !isAllBatteryOptimizationDisabled) {
      DisableBatteryOptimization.showDisableAllOptimizationsSettings(
          language!.lblEnableAutoStart,
          language!.lblFollowTheStepsAndEnableTheAutoStartOfThisApp,
          language!.lblYourDeviceHasAdditionalBatteryOptimization,
          language!
              .lblFollowTheStepsAndDisableTheOptimizationsToAllowSmoothFunctioningOfThisApp);
    }
  }
  /*
To enable off Duty and On Duty location.
  To enable rescue operations.
To conduct well-being check requests*/

  Future<bool> hasPermission() async {
    if (isIOS) {
      var loc = await Permission.locationAlways.status;
      var act = await Permission.sensors.status;
      return act == PermissionStatus.granted && loc == PermissionStatus.granted;
    } else {
      var loc = await Geolocator.checkPermission();
      var act = await Permission.activityRecognition.isGranted;
      return act && loc == LocationPermission.always;
    }
  }

  void checkPermissions() async {
    if (!isIOS) {
      var locationPermission = await Geolocator.checkPermission();
      if (!await Permission.activityRecognition.isGranted ||
          locationPermission != LocationPermission.always) {
        if (!mounted) return;
        const PermissionsScreen().launch(context);
      }
    } else {
      var locationPermission = await Permission.locationAlways.status;
      var activityPermission = await Permission.sensors.status;

      if (activityPermission != PermissionStatus.granted ||
          locationPermission != PermissionStatus.granted) {
        if (!mounted) return;
        if (isIOS) {
          const IosPermissionScreen().launch(context);
        } else {
          const PermissionsScreen().launch(context);
        }
      }
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Future<bool> isPermissionGrants() async {
    // Check if the user has granted permission. If not, request permission.
    ActivityPermission reqResult;
    reqResult = await activityRecognition.checkPermission();
    if (reqResult == ActivityPermission.PERMANENTLY_DENIED) {
      log('Permission is permanently denied.');
      return false;
    } else if (reqResult == ActivityPermission.DENIED) {
      reqResult = await activityRecognition.requestPermission();
      if (reqResult != ActivityPermission.GRANTED) {
        log('Permission is denied.');
        return false;
      }
    }
    return true;
  }

  final GlobalKey<AttendanceScreenState> attendanceScreenKey =
      GlobalKey<AttendanceScreenState>();

  @override
  Widget build(BuildContext context) {
    debugPrint("user data $_userProfileModel");
    bool isNotificationEnabled = true;
    // final tab = [
    //    AttendanceScreen(latLong: _latlong,),
    //   const ExpenseScreen(),
    //   const DashboardScreen(),
    //   const LeaveScreen(),
    //   const TeamScreen(),
    // ];

    var title = '';

    if (_currentIndex == 0) {
      title = language!.lblHome;
    } else if (_currentIndex == 1) {
      title = language!.lblExpense;
    } else if (_currentIndex == 2) {
      title = language!.lblDashboard;
    } else if (_currentIndex == 3) {
      title = language!.lblLeave;
    } else if (_currentIndex == 4) {
      title = language!.lblClients;
    }
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Icon(
          Icons.menu,
          color: appStore.iconColor,
        ).onTap(() => scaffoldKey.currentState!.openDrawer()),
        elevation: 0.5,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 3),
              child: Center(
                child: Text(
                  title,
                  maxLines: 2,
                  style:
                      boldTextStyle(size: 18, color: appStore.textPrimaryColor),
                ),
              ),
            ),
            Center(
              child: GestureDetector(
                onTap: () => {const ChattingScreen().launch(context)},
                child: Image.asset(appChatImg,
                    width: 35, height: 35, color: appStore.iconColor),
              ),
            )
          ],
        ),
      ),
      backgroundColor: appStore.backgroundColor,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
              color: shadowColorGlobal,
              offset: Offset.fromDirection(3, 1),
              spreadRadius: 1,
              blurRadius: 5)
        ], color: context.scaffoldBackgroundColor),
        child: BottomNavigationBar(
          enableFeedback: true,
          showSelectedLabels: true,
          showUnselectedLabels: false,
          currentIndex: _currentIndex,
          backgroundColor: context.scaffoldBackgroundColor,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(
                  Iconsax.home_1,
                  color: appStore.iconColor,
                ),
                activeIcon: const Icon(
                  Iconsax.home5,
                  color: appColorPrimary,
                ),
                label: language!.lblHome),
            BottomNavigationBarItem(
                icon: Icon(
                  Iconsax.money,
                  color: appStore.iconColor,
                ),
                activeIcon: const Icon(
                  Iconsax.money5,
                  color: appColorPrimary,
                ),
                label: language!.lblExpense),
            BottomNavigationBarItem(
                icon: Icon(
                  Iconsax.activity,
                  color: appStore.iconColor,
                ),
                activeIcon: const Icon(
                  Iconsax.activity5,
                  color: appColorPrimary,
                ),
                label: language!.lblDashboard),
            BottomNavigationBarItem(
                icon: Icon(
                  Iconsax.calendar,
                  color: appStore.iconColor,
                ),
                activeIcon: const Icon(
                  Iconsax.calendar5,
                  color: appColorPrimary,
                ),
                label: language!.lblLeave),
            BottomNavigationBarItem(
                icon: Icon(
                  Iconsax.people,
                  color: appStore.iconColor,
                ),
                activeIcon: const Icon(
                  Iconsax.people5,
                  color: appColorPrimary,
                ),
                label: language!.lblClients),
          ],
          unselectedIconTheme:
              const IconThemeData(color: textSecondaryColor, size: 24),
          selectedIconTheme:
              const IconThemeData(color: opPrimaryColor, size: 24),
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
        ),
      ),
      // body: tab[_currentIndex],
      body: IndexedStack(
        index: _currentIndex,
        children: [
          Navigator(
            onGenerateRoute: (settings) {
              return MaterialPageRoute(
                builder: (context) => AttendanceScreen(
                  latLong: _latlong,
                  key: attendanceScreenKey,
                ),
                // settings: RouteSettings(
                //   arguments: {
                //     "lat" : _latlong.$1,
                //     "long": _latlong.$2,
                //   }
                // )
              );
            },
          ),
          Navigator(
            onGenerateRoute: (settings) {
              return MaterialPageRoute(
                builder: (context) => const ExpenseScreen(),
              );
            },
          ),
          Navigator(
            onGenerateRoute: (settings) {
              return MaterialPageRoute(
                builder: (context) => const DashboardScreen(),
              );
            },
          ),
          Navigator(
            onGenerateRoute: (settings) {
              return MaterialPageRoute(
                builder: (context) => const LeaveScreen(),
              );
            },
          ),
          Navigator(
            onGenerateRoute: (settings) {
              return MaterialPageRoute(
                builder: (context) => const TeamScreen(),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        /*Asset inspection
Response Alert
Dark Mode
Rate Us
Disable settings*/
        child: Container(
          padding: EdgeInsets.only(bottom: 10),
          color: appStore.appBarColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  /*DrawerHeader(
                    decoration: const BoxDecoration(color: opPrimaryColor),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 8,
                        ),
                        SizedBox(
                          width: 260,
                          child:
                          _userProfileModel == null?
                             const  Center(
                                child: Text("Loading Details...", style: TextStyle(color: Colors.white, fontSize: 16),),
                              ):
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                    flex: 4,
                                    child: Text(
                                      // '${getStringAsync(appCountryPhoneCodePref)} ${getStringAsync(phoneNumberPref)}',
                                      _userProfileModel?.roleType == 0?
                                     _userProfileModel?.team?.name??'Not Found':
                                     _userProfileModel?.coy?.name??'Not Found',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style:
                                          primaryTextStyle(color: white, size: 18,),
                                    ),
                                  ),
                                  if(_userProfileModel?.coy?.imageUrl != null || _userProfileModel?.team?.imageUrl != null)
                                  Flexible(
                                    flex: 1,
                                      child: Image.network(_userProfileModel?.roleType == 0?
                                        _userProfileModel?.team?.imageUrl??'':
                                        _userProfileModel?.coy?.imageUrl??'',),
                                  )
                                ],
                              ),
                              Text(
                               'Division: ${_userProfileModel?.division??'Not Found'}',
                                maxLines: 1,
                                style: primaryTextStyle(color: white, size: 18),
                              ),
                              Text(
                                sharedHelper.getFullName().toUpperCase(),
                                maxLines: 1,
                                style: primaryTextStyle(color: white, size: 16),
                              ),
                              Text(
                                'LGA: ${_userProfileModel?.lga??'Not Found'}',
                                maxLines: 1,
                                style: primaryTextStyle(color: white, size: 15),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),*/

                  DrawerHeader(
                    decoration: const BoxDecoration(color: opPrimaryColor),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 8,
                        ),
                        SizedBox(
                          width: 260,
                          child: _userProfileModel == null
                              ? const Center(
                                  child: Text(
                                    "Loading Details...",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(
                                      bottom:
                                          8.0), // Added padding at the bottom
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Flexible(
                                            flex: 4,
                                            child: Text(
                                              _userProfileModel?.roleType == 0
                                                  ? _userProfileModel
                                                          ?.team?.name ??
                                                      'Not Found'
                                                  : _userProfileModel
                                                          ?.coy?.name ??
                                                      'Not Found',
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: primaryTextStyle(
                                                  color: white, size: 18),
                                            ),
                                          ),
                                          if (_userProfileModel
                                                      ?.coy?.imageUrl !=
                                                  null ||
                                              _userProfileModel
                                                      ?.team?.imageUrl !=
                                                  null)
                                            Flexible(
                                              flex: 1,
                                              child: Image.network(
                                                _userProfileModel?.roleType == 0
                                                    ? _userProfileModel
                                                            ?.team?.imageUrl ??
                                                        ''
                                                    : _userProfileModel
                                                            ?.coy?.imageUrl ??
                                                        '',
                                              ),
                                            )
                                        ],
                                      ),
                                      Text(
                                        'Division: ${_userProfileModel?.division ?? 'Not Found'}',
                                        maxLines: 1,
                                        style: primaryTextStyle(
                                            color: white, size: 18),
                                      ),
                                      Text(
                                        sharedHelper
                                            .getFullName()
                                            .toUpperCase(),
                                        maxLines: 1,
                                        style: primaryTextStyle(
                                            color: white, size: 16),
                                      ),
                                      Text(
                                        'LGA: ${_userProfileModel?.lga ?? 'Not Found'}',
                                        maxLines: 1,
                                        style: primaryTextStyle(
                                            color: white, size: 15),
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),

                  // UserAccountsDrawerHeader(
                  //   decoration: const BoxDecoration(color: opPrimaryColor),
                  //   accountName: Text(
                  //     // '${getStringAsync(appCountryPhoneCodePref)} ${getStringAsync(phoneNumberPref)}',
                  //        "Nigeria Police Force: A Division",
                  //     style: primaryTextStyle(color: white),
                  //   ),
                  //   accountEmail: Text(
                  //     sharedHelper.getFullName(),
                  //     style: primaryTextStyle(color: white),
                  //   ),
                  //   currentAccountPicture:  CircleAvatar(
                  //     backgroundColor: Colors.blue,
                  //     child: Text(
                  //       "${sharedHelper.getFullName().split(" ").first.characters.first}${sharedHelper.getFullName().split(" ").last.characters.first}",
                  //       style: const TextStyle(fontSize: 40.0, color: white),
                  //     ),
                  //   ),
                  // ),
                  SettingItemWidget(
                    title: language!.lblWallet,
                    leading: const Icon(Iconsax.wallet),
                    onTap: () {
                      _currentIndex = 0;
                      setState(() {});
                      scaffoldKey.currentState!.closeDrawer();
                      const WalletScreen().launch(context);
                    },
                  ),
                  // SettingItemWidget(
                  //   title: language!.lblShareApp,
                  //   leading: const Icon(Iconsax.share),
                  //   onTap: () async {},
                  // ),
                  SettingItemWidget(
                      // padding: const EdgeInsets.only(left: 16, right: 16),
                      title: language!.lblNotification,
                      leading: const Icon(Iconsax.notification),
                      trailing: const Text(
                        "0",
                        style:
                            TextStyle(color: colorPrimaryBlack, fontSize: 16),
                      )

                      // Switch(
                      //   value: isNotificationEnabled,
                      //   onChanged: (value) async {
                      //     var instance = FirebaseMessaging.instance;
                      //     if (value) {
                      //       instance.subscribeToTopic('announcement');
                      //     } else {
                      //       instance.unsubscribeFromTopic('announcement');
                      //     }
                      //     setState(() {
                      //       isNotificationEnabled = value;
                      //     });
                      //   },
                      //   activeTrackColor: opPrimaryColor,
                      //   activeColor: white,
                      // ),
                      ),

                  SettingItemWidget(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    title: language!.lblDarkMode,
                    leading: appStore.isDarkModeOn
                        ? const Icon(Iconsax.sun_1)
                        : const Icon(Iconsax.moon),
                    trailing: Switch(
                      value: appStore.isDarkModeOn,
                      onChanged: (s) {
                        appStore.toggleDarkMode(value: s);
                      },
                      activeTrackColor: opPrimaryColor,
                      activeColor: white,
                    ),
                  ),

                  /*SettingItemWidget(
                    title: language!.lblShareApp,
                    leading: const Icon(Iconsax.share),
                    onTap: () async {
                      scaffoldKey.currentState!.closeDrawer();
                      await Future.delayed(const Duration(seconds: 1));
                      PackageInfo.fromPlatform().then((value) async {
                        PackageInfo.fromPlatform().then((value) async {
                          String package = value.packageName;
                          await Share.share(
                              'Download $mainAppName from Play Store\n\n\n$playStoreUrl$package');
                        });
                      });
                    },
                  ),*/

                  SettingItemWidget(
                    title: language!.lblRateUs,
                    leading: const Icon(Iconsax.star),
                    onTap: () async {
                      scaffoldKey.currentState!.closeDrawer();
                      await Future.delayed(const Duration(seconds: 1));
                      PackageInfo.fromPlatform().then((value) async {
                        String package = value.packageName;
                        debugPrint("package info --> $package");
                        launchUrl(Uri.parse('$playStoreUrl$package'),
                            mode: LaunchMode.externalNonBrowserApplication);
                      });
                    },
                  ),
                  SettingItemWidget(
                    title: language!.lblContactUs,
                    leading: const Icon(Iconsax.call),
                    onTap: () async {
                      scaffoldKey.currentState!.closeDrawer();
                      await Future.delayed(const Duration(seconds: 1));
                      PackageInfo.fromPlatform().then((value) async {
                        String package = value.packageName;
                        launchUrl(Uri.parse('$playStoreUrl$package'),
                            mode: LaunchMode.externalNonBrowserApplication);
                      });
                    },
                  ),
                  // SettingItemWidget(
                  //   title: language!.lblChangeLanguage,
                  //   leading: const Icon(Iconsax.language_square),
                  //   onTap: () {
                  //     const LanguageScreen().launch(context);
                  //   },
                  // ),
                  SettingItemWidget(
                      title: language!.lblSettings,
                      leading: const Icon(Iconsax.setting),
                      onTap: () async {
                        const SettingsScreen().launch(context);
                      }),
                ],
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 60, right: 60),
                    child: AppButton(
                        color: opPrimaryColor,
                        textColor: Colors.white,
                        shapeBorder: buildButtonCorner(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              language!.lblLogOut,
                              style: primaryTextStyle(color: Colors.white),
                            ),
                            const Icon(
                              Icons.logout,
                              color: white,
                            ),
                          ],
                        ),
                        onTap: () async {
                          showConfirmDialog(
                            context,
                            language!.lblDoYouWantToLogoutFromTheApp,
                            positiveText: language!.lblYes,
                            negativeText: language!.lblNo,
                            onAccept: () {
                              sharedHelper.logout();
                              const LoginScreen()
                                  .launch(context, isNewTask: true);
                            },
                          );
                        }),
                  ),
                  15.height,
                  Center(
                    child: Text(
                      '$mainAppName V ${getStringAsync(appVersionPref).toString()}',
                      style: secondaryTextStyle(),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
