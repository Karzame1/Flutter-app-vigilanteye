import 'package:cached_network_image/cached_network_image.dart';
import 'package:fieldmanager_hrms_flutter/Utils/app_widgets.dart';
import 'package:fieldmanager_hrms_flutter/Widgets/button_widget.dart';
import 'package:fieldmanager_hrms_flutter/main.dart';
import 'package:fieldmanager_hrms_flutter/models/sos_model.dart';
import 'package:fieldmanager_hrms_flutter/screens/Attendance/AttendanceScreen.dart';
import 'package:flutter/material.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:nb_utils/nb_utils.dart';

import '../screens/navigation_screen.dart';


/*"-Nxm4aTJ0-gxhXu0FDTh": {
          "Date": "May 13, 2024 at 6:13:24 PM",
          "Emergency": "A user needs emergency service",
          "Latitude": 31.5545131,
          "Longitude": 74.3635971,
          "UserName": "M.Hamza",
          "city": "Lahore",
          "isRead": true,
          "state": "Punjab",
          "user_Img": "https://firebasestorage.googleapis.com/v0/b/karzame-f00a9.appspot.com/o/UserPics%2Ffile%3A%2Fstorage%2Femulated%2F0%2FAndroid%2Fdata%2Fcom.karzamesos.app%2Ffiles%2FPictures%2Fe5856340-9b10-4b76-9d76-37c41dcea4aa_1714495511843.jpg?alt=media&token=cda67c9d-0d85-4046-862a-f315ad812c69",
          "user_Name": "M.Hamza",
          "user_Phone": "+923164558585"
        }*/


class SosAlertDialog extends StatefulWidget {
  final SosAlertModel sosAlertModel;
  final Function(double?,double?)? onLocateVictim;
  // final Function(bool) isTaped;
  const SosAlertDialog({super.key, required this.sosAlertModel,  this.onLocateVictim,/* required this.isTaped*/});

  @override
  State<SosAlertDialog> createState() => _SosAlertDialogState();
}

class _SosAlertDialogState extends State<SosAlertDialog> {
  @override
  void initState() {
    super.initState();
  }

  /*{
    "latitude": 31.554492,
    "longitude": 74.3634996,
    "date": "March 28, 2024, 10:24:02 PM",
    "emergency": "A user needs emergency service",
    "user_Img": "https://firebasestorage.googleapis.com/v0/b/karzame-f00a9.appspot.com/o/UserPics%2Ffile%3A%2Fstorage%2Femulated%2F0%2FAndroid%2Fdata%2Fcom.karzamee.app%2Ffiles%2FPictures%2F708036d3-7196-4704-96ca-c0ad244a9602_1691814505538.jpg?alt=media&token=cb4b0ad3-6ab5-48e2-90b8-d1401c501499",
     "user_Name": "karzame",
     "user_Phone": "+18166026983"
}*/
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        10.height,
        CachedNetworkImage(
          imageUrl: widget.sosAlertModel.userImage!,
          placeholder: (context, url) => buildShimmer(context.height()*0.5, 300),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ).cornerRadiusWithClipRRect(10),
        10.height,
        Text(
          widget.sosAlertModel.userName!,
          style: boldTextStyle(size: 18,color:appStore.isDarkModeOn?purple:null ),
        ),
        Text(
          widget.sosAlertModel.userPhone!,
          style: secondaryTextStyle(color:appStore.isDarkModeOn?white:null ),
        ),
        10.height,
        Text(
          widget.sosAlertModel.message!,
          style: secondaryTextStyle(color:appStore.isDarkModeOn?white:null),
        ),
        20.height,
        button(
            'Locate Victim',
            onTap: () {
          apiRepo.setAlertAsRead(widget.sosAlertModel.id!);
          if(widget.onLocateVictim != null){
            widget.onLocateVictim!(
                double.tryParse(widget.sosAlertModel.latitude??'',), double.tryParse(widget.sosAlertModel.longitude??""));
          }
          // MapsLauncher.launchCoordinates(
          //   widget.sosAlertModel.latitude.toDouble(),
          //   widget.sosAlertModel.longitude.toDouble(),
          //   widget.sosAlertModel.userName!,
          // );
              Future.delayed(Duration.zero,(){
               // const NavigationScreen().launch(context, isNewTask: true);
              });
          debugPrint("tapeddd");
           // widget.isTaped(true);
          finish(context);
        }).paddingOnly(bottom: 16),
      ],
    ).paddingAll(16);
  }
}
