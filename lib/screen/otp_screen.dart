import 'dart:async';
import 'package:flutter/material.dart';
import 'package:phone_auth/screen/homescreen.dart';
import 'signup.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:otp_timer_button/otp_timer_button.dart';
import 'package:get/get.dart';


class OTPScreen extends StatefulWidget {
  const OTPScreen({Key? key}) : super(key: key);



  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  int start = 30;
  bool wait = false;
  String buttonName = "RESEND";
  void startTimer(){
    const onesec = Duration(seconds: 1);
    Timer timer = Timer.periodic(onesec, (timer) {
      if (start == 0){
        setState((){
          timer.cancel();
        });
      }else {
        setState(() {
          start--;
        });
      }
    });
  }

  OtpTimerButtonController controller = OtpTimerButtonController();

  @override
  Widget build(BuildContext context) {
    final controllers = Get.put(SignupController());
    final _formKey = GlobalKey<FormState>();
    var otpController = Get.put(OtpController());
    var otp;
    startTimer();
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("OTP"),
            const SizedBox(height: 40.0),
            OtpTextField(
              numberOfFields: 6,
              fillColor: Colors.black.withOpacity(0.1),
              filled: true,
              onSubmit: (code){
                otp = code;
                OtpController.instance.verifyOTP(otp);
              },
            ),
            const SizedBox(height: 20.0,),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: () {
                OtpController.instance.verifyOTP(otp);
                Get.to(()=> const HomeScreen());
              }, child: const Text("VERIFY")),
            ),
            const SizedBox(height: 20.0,),
            SizedBox(
              width: double.infinity,
                child: OtpTimerButton(
              controller: controller,
              onPressed: () {
                  //SignupController.instance.registerUser(controller.email.text.trim(), controller.password.text.trim());
                  SignupController.instance.phoneAuthentication(controllers.phoneNo.text.trim());
              },
              text: Text('Resend OTP'),
              duration: 5,
            ),
            ),

          ],
        ),
      ),
    );
  }
}

