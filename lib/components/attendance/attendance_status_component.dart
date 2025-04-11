import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../Utils/app_widgets.dart';
import '../../main.dart';
import '../../models/user_profile_model.dart';

class AttendanceStatusComponent extends StatefulWidget{
  static String tag = '/AttendanceScreen';
  const AttendanceStatusComponent({Key? key}) : super(key: key);

  @override
  State<AttendanceStatusComponent> createState() => _AttendanceStatusState();
}

class _AttendanceStatusState extends State<AttendanceStatusComponent> {
  User? _userProfileModel;
  void getUserProfile() async {
    debugPrint("like Bhai===>${sharedHelper.getUserId()}");
    // var result = await apiRepo.getUserProfile(getStringAsync(userIdPref));
    var result = await apiRepo.getUserProfile(sharedHelper.getUserId());
    debugPrint("data in attendance --> ${result!.shift?.title}");
    _userProfileModel = result ;
    setState(() {});
  }
  @override
  void initState() {
    super.initState();
    getUserProfile();
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            color: white.withOpacity(0.8),
            shape: buildRoundedCorner(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Card(
                    color: Colors.cyan.shade800,
                    shape: buildRoundedCorner(),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                           /* language!.lblAboutUs*/_userProfileModel?.shift?.title ?? 'Loading Shift...',
                            style: primaryTextStyle(color: white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  5.height,
                  Observer(
                      builder: (_) => appStore.getCurrentStatus!.status != 'new'
                          ? Column(
                              children: [
                                Text(
                                    '${language!.lblAttendanceInAt} : ${appStore.getCurrentStatus!.checkInAt!.toString()}'),
                                appStore.getCurrentStatus!.checkOutAt != null
                                    ? Text(
                                        '${language!.lblAttendanceOutAt} : ${appStore.getCurrentStatus!.checkOutAt!.toString()}')
                                    : Container()
                              ],
                            )
                          : Text(language!.lblCheckInToBegin)),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
