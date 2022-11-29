import 'package:flutter/material.dart';
import 'package:phone_auth/screen/homescreen.dart';
import 'package:phone_auth/screen/otp_screen.dart';
import 'signup.dart';
import 'package:get/get.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Dash Board"),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: () {
                //AuthenticateUser.instance.logout();
                Get.to(()=> const HomeScreen());
              }, child: const Text("BACK")),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: () {
                //AuthenticateUser.instance.logout();
                Get.to(()=> const OTPScreen());
              }, child: const Text("OTP")),
            ),
          ],
        ),
      ),
    );
  }
}
