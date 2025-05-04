import 'package:fieldmanager_hrms_flutter/utils/app_colors.dart';
import 'package:flutter/material.dart';

Container getWalletTableHeader(String lastColumnName) {
  TextStyle headerTextStyle = const TextStyle(color: Colors.white);
  return Container(
    padding: EdgeInsets.all(8),
    margin: const EdgeInsets.only(bottom: 10),
    decoration: BoxDecoration(
        color: opPrimaryColor, borderRadius: BorderRadius.circular(10)),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //const SizedBox(width: 10),
        Text('Date', style: headerTextStyle),
        //const SizedBox(width: 50),
        Text(
          'Activity Type',
          style: headerTextStyle,
        ),
        // const SizedBox(width: 50),
        Text(
          lastColumnName,
          style: headerTextStyle,
        )
      ],
    ),
  );
}
