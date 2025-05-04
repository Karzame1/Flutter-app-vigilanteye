import 'package:fieldmanager_hrms_flutter/Utils/app_colors.dart';
import 'package:fieldmanager_hrms_flutter/screens/Wallet/wallet_componenents.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

class WalletApproved extends StatefulWidget {
  const WalletApproved({super.key});

  @override
  State<WalletApproved> createState() => _WalletApprovedState();
}

class _WalletApprovedState extends State<WalletApproved> {
  @override
  Widget build(BuildContext context) {
    List<Container> rows = List.generate(
        5,
        (int index) => Container(
              padding: const EdgeInsets.only(left: 10, right: 10),
              margin: const EdgeInsets.only(bottom: 5),
              decoration: boxDecorationWithRoundedCorners(
                  backgroundColor: Colors.grey.shade300),
              child: Row(children: [
                Text(
                  DateFormat("d-MMMM-yyyy").format(DateTime.now()),
                  style: const TextStyle(
                      fontSize: 10, fontWeight: FontWeight.w700),
                ),
                const SizedBox(width: 30),
                const Flexible(
                  child: Wrap(children: [
                    Text('Dispatch to locate Karzame',
                        style: TextStyle(
                            fontSize: 11, fontWeight: FontWeight.w700)),
                  ]),
                ),
                const Text(
                  '₦ 3,000.00',
                  style: TextStyle(
                      color: Colors.green,
                      fontSize: 10,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w700),
                ),
                const SizedBox(width: 20)
              ]),
            ));

    return Center(
      child: Column(
        children: [
          getWalletTableHeader('Approved'),
          const SizedBox(height: 10),
          SingleChildScrollView(
            child: Column(
              children: rows,
            ),
          )
        ],
      ),
    );
  }
}
