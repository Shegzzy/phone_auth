import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phone_auth/screen/dashboard.dart';
import 'package:phone_auth/screen/homescreen.dart';
import 'package:phone_auth/screen/phone_screen.dart';
import 'otp_screen.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class AuthenticateUser extends GetxController {
  static AuthenticateUser get instance => Get.find();

  final _auth = FirebaseAuth.instance;
  late final Rx<User?> firebaseUser;
  var verificationId = ''.obs;

  @override
  void onReady() {
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  _setInitialScreen(User? user) {
    user == null ? Get.offAll(() => const HomeScreen()) : Get.offAll(() =>
        const Dashboard());
  }

  Future<void> phoneAuthentication(String phoneNo) async {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNo,
        verificationCompleted: (credential) async{
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (e){
          if(e.code == 'invalid-phone-number'){
            Get.snackbar('Error', 'The phone number provided is invalid');
          } else {
            Get.snackbar('Error', 'Something went wrong');
          }
        },
        codeSent: (verificationId, resendToken){
          this.verificationId.value = verificationId;
        },
        codeAutoRetrievalTimeout: (verificationId){
          this.verificationId.value = verificationId;
        });
  }

  Future<bool> verifyOtp(String otp) async {
    var credentials = await _auth.signInWithCredential(PhoneAuthProvider.credential(verificationId: verificationId.value, smsCode: otp));
    return credentials.user != null? true: false;
  }

  Future<void> createUserWithEmailAndPassword(String email,
      String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      firebaseUser.value != null ? Get.offAll(()=> const PhoneScreen()): Get.snackbar('Error', 'Something went wrong');
    } on FirebaseAuthException catch (e) {
      final ex = SignUpFailure.code(e.code);
      print('FIREBASE AUTH EXCEPTION - ${ex.message}');
      throw ex;
    } catch (_) {
      const ex = SignUpFailure();
      print('EXCEPTION - ${ex.message}');
      throw ex;
    }
  }

  Future<void> loginWithEmailAndPassword(String email,
      String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {} catch (_) {}
  }

  Future<void> logout() async => await _auth.signOut();
}

class SignUpFailure{
  final String message;

  const SignUpFailure([this.message = "Unknown Error Has Occurred"]);

  factory SignUpFailure.code(String code){
    switch (code){
      case 'weak-password':
        return const SignUpFailure('Please enter a strong password');
      case 'invalid-email':
        return const SignUpFailure('Please enter a valid mail');
      case 'email-taken':
        return const SignUpFailure('An account already exist with that email');
      case 'operation-not-allowed':
        return const SignUpFailure('Operation not allow, please contact support');
      case 'user-disabled':
        return const SignUpFailure('This user have been disabled. Please contact support for help');
      default:
        return const SignUpFailure();
    }
  }

}

class SignupController extends GetxController {
  static SignupController get instance => Get.find();

  final email = TextEditingController();
  final fullName = TextEditingController();
  final phoneNo = TextEditingController();
  final password = TextEditingController();

  void registerUser (String email, String password){
    String? error = AuthenticateUser.instance.createUserWithEmailAndPassword(email, password) as String;
    if (error != null) {
      Get.showSnackbar(GetSnackBar(message: error.toString()));
    }
  }

  void phoneAuthentication(String phoneNo) {
    AuthenticateUser.instance.phoneAuthentication(phoneNo);
  }

}

class OtpController extends GetxController {
  static OtpController get instance => Get.find();

  void verifyOTP(String otp) async {
    var isVerified = await AuthenticateUser.instance.verifyOtp(otp);
    isVerified ? Get.offAll(() => const Dashboard()): Get.back();
  }

}



class _SignUpState extends State<SignUp> {
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
                  TextFormField(
                    controller: controller.fullName,
                    decoration: const InputDecoration(
                      label: Text("Full Name"),
                      prefixIcon: Icon(Icons.person_outline_rounded),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20,),
                  TextFormField(
                    controller: controller.email,
                    decoration: const InputDecoration(
                      label: Text("Email"),
                      prefixIcon: Icon(Icons.email_outlined),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20,),
                  TextFormField(
                    controller: controller.phoneNo,
                    decoration: const InputDecoration(
                      label: Text("Phone Number"),
                      prefixIcon: Icon(Icons.phone_android_outlined),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20,),
                  TextFormField(
                    controller: controller.password,
                    decoration: const InputDecoration(
                      label: Text("Password"),
                      prefixIcon: Icon(Icons.password_rounded),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20,),
                  SizedBox
                    (width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if(_formKey.currentState!.validate()){
                          SignupController.instance.registerUser(controller.email.text.trim(), controller.password.text.trim());
                          //SignupController.instance.phoneAuthentication(controller.phoneNo.text.trim());

                          Get.to(() => const OTPScreen());
                        }
                      },
                      child: const Text("SIGNUP")),
                  ),
                  const SizedBox(height: 20,),
                  SizedBox
                    (width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () {
                          if(_formKey.currentState!.validate()){
                            Get.to(() => const HomeScreen());
                          }
                        },
                        child: const Text("BACK")),
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
