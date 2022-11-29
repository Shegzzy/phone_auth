import 'package:flutter/material.dart';
import 'homescreen.dart';
import 'otp_screen.dart';
import 'signup.dart';
import 'package:get/get.dart';

class PhoneScreen extends StatefulWidget {
  const PhoneScreen({Key? key}) : super(key: key);

  @override
  State<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignupController());
    final _formKey = GlobalKey<FormState>();
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              margin: const EdgeInsets.only(top: 25),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: controller.phoneNo,
                      decoration: const InputDecoration(
                        label: Text("Phone Number"),
                        prefixIcon: Icon(Icons.phone_android_outlined),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox
                      (width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () {
                            if(_formKey.currentState!.validate()){
                              //SignupController.instance.registerUser(controller.email.text.trim(), controller.password.text.trim());
                              SignupController.instance.phoneAuthentication(controller.phoneNo.text.trim());
                              Get.to(() => const OTPScreen());
                            }
                          },
                          child: const Text("SIGNUP")),
                    ),
                  ],
                ),

              ),
            )
          ],
        ),
      ),
    );
  }
}
