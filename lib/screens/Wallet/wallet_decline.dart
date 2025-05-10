import 'package:fieldmanager_hrms_flutter/Utils/app_colors.dart';
import 'package:fieldmanager_hrms_flutter/models/visits_model.dart';
import 'package:fieldmanager_hrms_flutter/screens/Wallet/wallet_componenents.dart';
import 'package:fieldmanager_hrms_flutter/screens/Wallet/wallet_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

class WalletDecline extends StatefulWidget {
  WalletStore store;

  WalletDecline(this.store, {super.key});

  @override
  State<WalletDecline> createState() => _WalletDeclineState();
}

class _WalletDeclineState extends State<WalletDecline> {
  @override
  void initState() {
    super.initState();
    if (widget.store.declinedVisits.isEmpty) {
      widget.store.fetchVisits('rejected');
    }
  }

  @override
  Widget build(BuildContext context) {
   
    return Center(
      child: Column(
        children: [
          getWalletTableHeader('Declined'),
          const SizedBox(height: 10),
          Expanded(child: Observer(builder: (_) {
            return widget.store.isDeclinedVisitsLoading
                ? const Center(
                    child: CircularProgressIndicator(
                    color: opPrimaryColor,
                  ))
                : widget.store.declinedVisits.isEmpty
                    ? const Center(child: Text("No visitors found"))
                    : ListView.builder(
                        itemCount: widget.store.declinedVisits.length,
                        itemBuilder: (context, index) {
                          VisitsModel item = widget.store.declinedVisits[index];
                          return Container(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, top: 5, bottom: 5),
                              margin: const EdgeInsets.only(bottom: 10),
                              decoration: boxDecorationWithRoundedCorners(
                                  backgroundColor: Colors.grey.shade300),
                              child: Column(children: [
                                // first
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        DateFormat("d-MMMM-yyyy").format(
                                            DateTime.parse(
                                                item.alert?.createdAt ?? '-')),
                                        style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700)),
                                    const SizedBox(width: 20),
                                    Flexible(
                                      child: Wrap(
                                        children: [
                                          Text(
                                            "Dispatch to locate ${item.alert?.userName ?? '-'}",
                                            style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text('₦ ${item.approvedAmount ?? 10.00}',
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.red,
                                            fontWeight: FontWeight.w700,
                                            fontFamily: 'Roboto')),
                                    // const SizedBox(width: 20)
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Reason for decline: ',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.red,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Flexible(
                                      child: Wrap(
                                        children: [
                                          Text(
                                            item.remarks ??
                                                'No reason provided',
                                            style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                  ],
                                )
                              ]));
                        });
          }))
        ],
      ),
    );
  }
}
