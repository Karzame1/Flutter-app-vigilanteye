import 'package:fieldmanager_hrms_flutter/Utils/app_colors.dart';
import 'package:fieldmanager_hrms_flutter/screens/Wallet/wallet_componenents.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

class WalletDecline extends StatefulWidget {
  const WalletDecline({super.key});

  @override
  State<WalletDecline> createState() => _WalletDeclineState();
}

class _WalletDeclineState extends State<WalletDecline> {
  @override
  Widget build(BuildContext context) {
    List<Container> rows = List.generate(
        5,
        (int index) => Container(
              padding: const EdgeInsets.only(left: 10, right: 10),
              margin: const EdgeInsets.only(bottom: 5),
              decoration: boxDecorationWithRoundedCorners(
                  backgroundColor: Colors.grey.shade300),
              child: Column(
                children: [
                  // first
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(DateFormat("d-MMMM-yyyy").format(DateTime.now()),
                          style: const TextStyle(
                              fontSize: 10, fontWeight: FontWeight.w700)),
                      const SizedBox(width: 20),
                      const Flexible(
                        child: Wrap(
                          children: [
                            Text(
                              'Dispatch to locate Karzame',
                              style: TextStyle(
                                  fontSize: 11, fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                      // SizedBox(
                      //   width: MediaQuery.of(context).size.width * 0.10,
                      // ),
                      // SizedBox(width: 10),
                      const Text('₦ 3,000.00',
                          style: TextStyle(
                              fontSize: 10,
                              color: Colors.red,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Roboto')),
                      // const SizedBox(width: 20)
                    ],
                  ),
                  const SizedBox(height: 10),

                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Reason for decline: ',
                        style: TextStyle(
                            fontSize: 10,
                            color: Colors.red,
                            fontWeight: FontWeight.w700),
                      ),
                      Flexible(
                        child: Wrap(
                          children: [
                            Text(
                              '"Incomplete: Dispatch report not submitted"',
                              style: TextStyle(
                                  fontSize: 10, fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 20),
                    ],
                  )
                ],
              ),
            ));

    return Center(
      child: Column(
        children: [
          getWalletTableHeader('Declined'),
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
