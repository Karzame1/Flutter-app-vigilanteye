import 'package:fieldmanager_hrms_flutter/screens/Wallet/wallet_componenents.dart';
import 'package:fieldmanager_hrms_flutter/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

class WalletPending extends StatefulWidget {
  const WalletPending({super.key});

  @override
  State<WalletPending> createState() => _WalletPendingState();
}

class _WalletPendingState extends State<WalletPending> {
  @override
  Widget build(BuildContext context) {
    TextStyle headerTextStyle = const TextStyle(color: Colors.white);
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
                    Text(
                      'Dispatch to locate Karzame',
                      style:
                          TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                    ),
                  ]),
                ),
                const Text(
                  '₦ 3,000.00',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Color.fromARGB(255, 205, 177, 15),
                    fontFamily: 'Roboto',
                  ),
                ),
                const SizedBox(width: 20)
              ]),
            ));

    return Center(
      child: Column(
        children: [
          getWalletTableHeader('Pending'),
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
