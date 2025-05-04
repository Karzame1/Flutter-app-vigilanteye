import 'dart:developer';

import 'package:fieldmanager_hrms_flutter/utils/app_colors.dart';
import 'package:flutter/material.dart';

class SubmitRequestDialogue extends StatelessWidget {
  const SubmitRequestDialogue({super.key});

  InputDecoration getInputDecoration() {
    return InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)));
  }

  @override
  Widget build(BuildContext context) {
    int height = MediaQuery.of(context).size.height.toInt();
    int width = MediaQuery.of(context).size.width.toInt();
    return Dialog(
      child: Container(
        width: width*0.5, // Set the width you desire
        height: height*0.375, // Set the height you desire
        padding:
            const EdgeInsets.all(16.0), // Optional padding inside the container
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Row(
                children: [
                  Text('Bank id'),
                ],
              ),
              TextFormField(
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
                  Text('Account Number'),
                ],
              ),
              TextFormField(
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
                onPressed: () {},
                label: const Text('Verify Bank'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
