import 'package:fieldmanager_hrms_flutter/models/visits_model.dart';
import 'package:fieldmanager_hrms_flutter/screens/Wallet/wallet_componenents.dart';
import 'package:fieldmanager_hrms_flutter/screens/Wallet/wallet_store.dart';
import 'package:fieldmanager_hrms_flutter/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

class WalletPending extends StatefulWidget {
 final WalletStore store;

 const WalletPending(this.store, {super.key});

  @override
  State<WalletPending> createState() => _WalletPendingState();
}

class _WalletPendingState extends State<WalletPending> {
  @override
  void initState() {
    super.initState();
    if (widget.store.pendingVisits.isEmpty) {
      widget.store.fetchVisits('pending');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          getWalletTableHeader('Pending'),
          const SizedBox(height: 10),
          Expanded(
            child: Observer(builder: (_) {
              return widget.store.isPendingVisitsLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                      color: opPrimaryColor,
                    ))
                  : widget.store.pendingVisits.isEmpty
                      ? const Center(child: Text("No visitors found"))
                      : ListView.builder(
                          itemCount: widget.store.pendingVisits.length,
                          itemBuilder: (context, index) {
                            VisitsModel item =
                                widget.store.pendingVisits[index];
                            return Container(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, top: 5, bottom: 5),
                              margin: const EdgeInsets.only(bottom: 10),
                              decoration: boxDecorationWithRoundedCorners(
                                  backgroundColor: Colors.grey.shade300),
                              child: Row(children: [
                                Text(
                                  DateFormat("d-MMMM-yyyy").format(
                                      DateTime.parse(
                                          item.alert?.createdAt ?? '-')),
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(width: 30),
                                Flexible(
                                  child: Wrap(children: [
                                    Text(
                                      "Dispatch to locate ${item.alert?.userName ?? '-'}",
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ]),
                                ),
                                //const Spacer(),
                                Text(
                                  '₦ ${item.approvedAmount ?? 10.00}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: Color.fromARGB(255, 205, 177, 15),
                                    fontFamily: 'Roboto',
                                  ),
                                ),
                                const SizedBox(width: 20),
                              ]),
                            );
                          },
                        );
            }),
          )
        ],
      ),
    );
  }
}
