import 'package:flutter/material.dart';
import 'package:phone_auth/screen/dashboard.dart';
import 'signup.dart';
import 'package:get/get.dart';
import 'otp_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Home Screen"),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: () {
                Get.to(()=> const SignUp());
              }, child: const Text("SIGN UP")),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: () {
                Get.to(()=> const Dashboard());
              }, child: const Text("Dash")),
            ),
          ],
        ),
      ),
    );
  }
}
