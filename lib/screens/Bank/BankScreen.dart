import 'dart:developer';

import 'package:fieldmanager_hrms_flutter/screens/Bank/BankStore.dart';
import 'package:fieldmanager_hrms_flutter/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../models/bank_list_model.dart';

class BankScreen extends StatefulWidget {
  const BankScreen({super.key});

  @override
  State<BankScreen> createState() => _BankScreenState();
}

class _BankScreenState extends State<BankScreen> {
  final _store = Bankstore();

  final _bankCodeCont = TextEditingController();
  final _accountNumberCont = TextEditingController();

  final _bankIdCont = TextEditingController();
  final _amountSentCont = TextEditingController();
  String? _selectedBankCode;
  Bank? _selectedBank;

  @override
  void initState() {
    super.initState();
    _store.fetchBanks(); // Fetch banks when screen initializes
  }

  InputDecoration getInputDecoration() {
    return InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bank'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              getCreateBankColumn(),
              const SizedBox(height: 25),
              getVerifyBankColumn(),
            ],
          ),
        ),
      ),
    );
  }

  Form getCreateBankColumn() {
    final formKey = GlobalKey<FormState>();

    return Form(
      key: formKey,
      child: Column(
        children: [
          const Text('Create Bank'),
          const SizedBox(height: 20),
          const Row(
            children: [
              Text('Bank Name'),
            ],
          ),
          /*DropdownButtonFormField(
              value: null,
              hint: const Text('Select Bank'),
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5))),
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
              onChanged: (value) {}),*/
          Observer(
            builder: (_) {
              if (_store.isLoading) {
                return const CircularProgressIndicator();
              }
              if (_store.banks.isEmpty) {
                return const Text('No banks available');
              }
              return DropdownButtonFormField<Bank>(
                value: _selectedBank,
                hint: const Text('Select Bank'),
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                ),
                items: _store.banks.map((Bank bank) {
                  return DropdownMenuItem<Bank>(
                    value: bank,
                    child: Text(bank.name),
                  );
                }).toList(),
                onChanged: (Bank? newValue) {
                  setState(() {
                    _selectedBank = newValue;
                    _selectedBankCode = newValue?.code;
                  });
                },
                validator: (value) => value == null ? 'Please select a bank' : null,
              );
            },
          ),
          const SizedBox(
            height: 20,
          ),
          const Row(
            children: [
              Text('Bank code'),
            ],
          ),
          TextFormField(
            controller: _bankCodeCont,
            decoration: getInputDecoration(),
            validator: (value) {
              log("check validation 1 $value");
              return value == null || value.isEmpty
                  ? 'Bank code is required'
                  : null;
            },
          ),

          const SizedBox(height: 8), // Add spacing between fields
          const Row(
            children: [
              Text('Account Number'),
            ],
          ),
          TextFormField(
            controller: _accountNumberCont,
            decoration: getInputDecoration(),
            validator: (value) {
              log("check validation 1 $value");
              return value == null || value.isEmpty
                  ? 'Account Number is required'
                  : null;
            },
          ),
          const SizedBox(height: 16),
          FloatingActionButton.extended(
            backgroundColor: opPrimaryColor,
            onPressed: () {
              if (formKey.currentState!.validate()) {
                _store.createBank(_bankCodeCont.text, _accountNumberCont.text);
              }
            },
            label: const Text('Create Bank'),
          )
        ],
      ),
    );
  }

  Observer getVerifyBankColumn() {
    final formKey = GlobalKey<FormState>();
    return Observer(
      builder: (_) {
        _bankIdCont.text = _store.bankId;
        _amountSentCont.text = _store.amountSent;
        return Visibility(
          visible: _store.bankId.isNotEmpty && _store.amountSent.isNotEmpty,
          child: Form(
            key: formKey,
            child: Column(
              children: [
                const Text('Verify Bank'),
                const Row(
                  children: [
                    Text('Bank ID'),
                  ],
                ),
                TextFormField(
                  controller: _bankIdCont,
                  decoration: getInputDecoration(),
                  validator: (value) {
                    log("check validation 1 $value");
                    return value == null || value.isEmpty
                        ? 'Bank id is required'
                        : null;
                  },
                ),

                const SizedBox(height: 8), // Add spacing between fields
                const Row(
                  children: [
                    Text('Amount Sent'),
                  ],
                ),
                TextFormField(
                  controller: _amountSentCont,
                  decoration: getInputDecoration(),
                  validator: (value) {
                    log("check validation 2 $value");
                    return value == null || value.isEmpty
                        ? 'Account Number is required'
                        : null;
                  },
                ),

                const SizedBox(
                    height: 16), // Add spacing between fields and button
                FloatingActionButton.extended(
                  backgroundColor: opPrimaryColor,
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      _store.verifyBank();
                    }
                  },
                  label: const Text('Verify Bank'),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
