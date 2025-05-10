import 'package:fieldmanager_hrms_flutter/Utils/app_colors.dart';
import 'package:fieldmanager_hrms_flutter/main.dart';
import 'package:fieldmanager_hrms_flutter/screens/Bank/BankScreen.dart';
import 'package:fieldmanager_hrms_flutter/screens/Bank/BankStore.dart';
import 'package:fieldmanager_hrms_flutter/screens/Wallet/submit_request_dialogue.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class WalletCashout extends StatefulWidget {
  const WalletCashout({super.key});

  @override
  State<WalletCashout> createState() => _WalletCashoutState();
}

class _WalletCashoutState extends State<WalletCashout> {
  InputDecoration getInputDecoration(String label) {
    return InputDecoration(
        label: Text(
          label,
          style: const TextStyle(color: Colors.blueGrey),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Form(
            child: Column(
      children: [
        const SizedBox(height: 20),
        FloatingActionButton.extended(
          backgroundColor: opPrimaryColor,
          label: const Text("Manage Bank"),
          onPressed: () async {
            //await Bankstore().fetchBanks();
            const BankScreen().launch(context);
          },
        ),
        const SizedBox(height: 20),
        TextFormField(decoration: getInputDecoration('Amount')),
        const SizedBox(height: 20),
        DropdownButtonFormField(
            value: null,
            hint: const Text('Select Bank'),
            decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
            items: const [
              DropdownMenuItem(
                  value: 'Access Bank', child: Text('Access Bank')),
              DropdownMenuItem(
                  value: 'United Africa Bank',
                  child: Text('United Africa Bank')),
              DropdownMenuItem(value: 'GTB', child: Text('GTB')),
              DropdownMenuItem(value: 'Opay', child: Text('Opay')),
              DropdownMenuItem(value: 'Zenith', child: Text('Zenith')),
              DropdownMenuItem(value: 'First Bank', child: Text('First Bank'))
            ],
            onChanged: (value) {}),
        const SizedBox(height: 20),
        TextFormField(
          decoration: getInputDecoration('Account Number'),
        ),
        const SizedBox(height: 20),
        TextFormField(
          decoration: getInputDecoration('Account Name'),
        ),
        const SizedBox(height: 30),
        Row(
          children: [
            Expanded(
              child: FloatingActionButton.extended(
                backgroundColor: opPrimaryColor,
                label: const Text("Submit Request"),
                onPressed: () {
                  // showDialog(
                  //     context: context,
                  //     builder: (context) => const SubmitRequestDialogue());
                },
              ),
            ),
          ],
        )
      ],
    )));
  }
}
