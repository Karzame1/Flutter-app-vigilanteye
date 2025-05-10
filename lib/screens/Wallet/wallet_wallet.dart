import 'package:fieldmanager_hrms_flutter/Utils/app_colors.dart';
import 'package:fieldmanager_hrms_flutter/screens/Wallet/wallet_componenents.dart';
import 'package:fieldmanager_hrms_flutter/screens/Wallet/wallet_store.dart';
import 'package:fieldmanager_hrms_flutter/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

class WalletWallet extends StatefulWidget {
  final WalletStore store;
  const WalletWallet(this.store, {super.key});

  @override
  State<WalletWallet> createState() => _WalletWalletState();
}

class _WalletWalletState extends State<WalletWallet> {
  @override
  void initState() {
    log("Init state for wallet");
    super.initState();
    if (widget.store.walletBalance == '₦ 0.00') {
      log('Fetching wallet balance');
      widget.store.fetchWalletBalance();
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Container> rows = List.generate(
        5,
        (int index) => Container(
              padding:
                  const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
              margin: const EdgeInsets.only(bottom: 10),
              decoration: boxDecorationWithRoundedCorners(
                  backgroundColor: Colors.grey.shade300),
              child: Row(children: [
                Text(
                  DateFormat("d-MMMM-yyyy").format(DateTime.now()),
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w700),
                ),
                const SizedBox(
                  width: 30,
                ),
                const Flexible(
                  child: Wrap(children: [
                    Text(
                      'Dispatch to locate Karzame',
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                    ),
                  ]),
                ),
                const Text(
                  '₦ 3,000.00',
                  style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 12,
                      color: opPrimaryColor,
                      fontWeight: FontWeight.w700),
                )
              ]),
            ));

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(
            height: 30,
          ),
          Container(
            decoration: boxDecorationWithRoundedCorners(
              borderRadius: BorderRadius.circular(15),
              backgroundColor: Colors.grey.shade200,
            ),
            padding: const EdgeInsets.all(25),
            child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
                width: MediaQuery.of(context).size.width * 0.7,
                child: Column(children: [
                  const Text('Total Balance:'),
                  const SizedBox(height: 10),
                  Observer(
                      builder: (context) => widget.store.isWalletBalanceLoading
                          ? const CircularProgressIndicator(
                              color: opPrimaryColor,
                            )
                          : Text(
                              widget.store.walletBalance,
                              style: const TextStyle(
                                  fontFamily: 'Roboto',
                                  color: opPrimaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25),
                            )),
                ])),
          ),
          const SizedBox(
            height: 30,
          ),
          getWalletTableHeader('Amount'),
          SingleChildScrollView(
            child: Column(
              children: rows,
            ),
          ),
          Row(children: [
            Expanded(
              child: FloatingActionButton.extended(
                  backgroundColor: opPrimaryColor,
                  onPressed: () {},
                  label: const Text('Cashout')),
            ),
          ])
        ],
      ),
    );
  }
}
