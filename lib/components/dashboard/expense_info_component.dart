import 'dart:io';

import 'package:dotted_line/dotted_line.dart';
import 'package:fieldmanager_hrms_flutter/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../main.dart';
import '../../utils/app_widgets.dart';

class ExpenseInfoComponent extends StatelessWidget {
  final num approved, pending, rejected;
  const ExpenseInfoComponent(
      {super.key,
      required this.approved,
      required this.pending,
      required this.rejected});
  // NumberFormat currency(context){
  //   Locale locale = Localizations.localeOf(context);
  //   var format = NumberFormat.simpleCurrency(locale: Platform.localeName,name: getStringAsync(appCurrencyCodePref) );
  //   debugPrint("currency symbol ${format.currencySymbol}");
  //   return format;
  // }
  @override
  Widget build(BuildContext context) {
    // var currencySymbol = currency(context).currencySymbol;
    return Card(
      elevation: 3,
      color: white.withOpacity(0.8),
      shape: buildRoundedCorner(),
      child: SizedBox(
        width: context.width() - 148,
        child: Column(
          children: [
            Text(
              language!.lblExpenseStatus,
              style: boldTextStyle(size: 18, color: appStore.textPrimaryColor),
            ),
            itemRowTWidget(language!.lblApproved,
                // '${currency(context).currencySymbol}$approved', black),
                '${getStringAsync(appCurrencySymbolPref)}$approved', black),
                // '₦$approved', black),
            const DottedLine(
              dashColor: black,
            ).paddingOnly(top: 5, bottom: 5),
            itemRowTWidget(language!.lblPending,
                '${getStringAsync(appCurrencySymbolPref)}$pending', black),
            const DottedLine(
              dashColor: black,
            ).paddingOnly(top: 5, bottom: 5),
            itemRowTWidget(language!.lblRejected,
                '${getStringAsync(appCurrencySymbolPref)}$rejected', black),
            const DottedLine(
              dashColor: black,
            ).paddingOnly(top: 5, bottom: 5),
          ],
        ).paddingAll(8.0),
      ),
    );
  }
}
