import 'dart:developer';

import 'package:fieldmanager_hrms_flutter/screens/Bank/BankStore.dart';
import 'package:fieldmanager_hrms_flutter/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../models/bank_list_model.dart';

class BankScreen extends StatefulWidget {
  const BankScreen({super.key});

  @override
  State<BankScreen> createState() => _BankScreenState();
}

class _BankScreenState extends State<BankScreen> {
  final _store = Bankstore();

  final _accountNumberCont = TextEditingController();

  final _bankIdCont = TextEditingController();
  final _amountSentCont = TextEditingController();
  String? _selectedBankCode;
  Bank? _selectedBank;
  String? _bankCode;

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
          Observer(builder: (_) {
            log(_store.banks.length.toString());
            if (_store.isFetchBankLoading) {
              return const CircularProgressIndicator();
            }
            if (_store.banks.isEmpty) {
              return const Text('No banks available');
            }
            return DropdownButtonFormField<Bank>(
              value: _selectedBank,
              //isDense: true, // Reduces overall size
              //iconSize: 20, // Smaller dropdown icon
              style: const TextStyle(fontSize: 14), // Smaller text
              menuMaxHeight: 200, // Prevent upward expansion
              hint: const Text(
                'Select Bank',
                style: TextStyle(fontSize: 14), // Smaller hint text
              ),
              decoration: InputDecoration(
                // contentPadding:
                //     const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                border: getInputDecoration().border,
                //isDense: true, // Compact form field
              ),
              items: _store.banks.map((Bank bank) {
                return DropdownMenuItem<Bank>(
                  value: bank,
                  child: Text(
                    bank.name,
                    style: const TextStyle(color: black),
                    //style: TextStyle(fontSize: 14), // Consistent item text size
                  ),
                );
              }).toList(),
              onChanged: (Bank? value) {
                setState(() {
                  _bankCode = value!.code;
                  _selectedBank = value;
                });
              },
            );
          }),
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
                _store.createBank(_bankCode ?? '', _accountNumberCont.text);
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
          visible: _store.isCreateBankLoading ||
              (_store.bankId.isNotEmpty && _store.amountSent.isNotEmpty),
          // ignore: prefer_const_constructors
          child: _store.isCreateBankLoading
              ? const CircularProgressIndicator(
                  color: opPrimaryColor,
                )
              : Form(
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
