import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rizer/Signup/provider/signup_provider.dart';

import '../constants/colors.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key, required this.email, this.userCategory})
      : super(key: key);
  final String email;
  final Category? userCategory;

  @override
  _VerifyEmailViewState createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  late Timer timer;
  bool isVerified = false;

  @override
  void initState() {
    timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      checkEmailVerification();
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  Future<void> checkEmailVerification() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if (isVerified) {
      timer.cancel();
      // CollectionReference users =
      //     FirebaseFirestore.instance.collection('users');
// //ADD
//       await users
//           .add({
//             'full_name': context.read<SignupProvider>().userName,
//             'role': 'student', // Stokes and Sons
//           })
//           .then((value) => log("User Added"))
//           .catchError((error) => log("Failed to add user: $error"));

      FirebaseAuth.instance.signOut();
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Successfully Signed up')));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isVerified
                  ? 'Email verified'
                  : 'Please Verify your email to proceed.',
              style: theme.textTheme.headline6,
            ),
            const SizedBox(
              height: 32.0,
            ),
            const SizedBox(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(
                  color: kPrimary,
                  strokeWidth: 2.0,
                )),
            const SizedBox(
              height: 32.0,
            ),
            Text(
              isVerified
                  ? 'Just a moment...\n'
                  : 'A verification link has been sent on \n${widget.email}',
              style: theme.textTheme.headline6,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
