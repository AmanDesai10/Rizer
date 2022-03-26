import 'dart:developer';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rizer/constants/colors.dart';
import 'package:rizer/login/provider/login_provider.dart';
import 'package:rizer/widgets/textfields.dart';

import '../widgets/auth_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((firebaseUser) {
      if (firebaseUser == null) {
        log('Logged-out');
        return;
      }
      log('Verified state: ' + firebaseUser.emailVerified.toString());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance;
    final Size size = MediaQuery.of(context).size;
    return Consumer<LoginProvider>(builder: (context, user, _) {
      return Scaffold(
        backgroundColor: kPrimary,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: size.height * 0.6,
                  width: size.width * 0.75,
                  color: Colors.white,
                  child: Column(children: [
                    AuthTextField(
                      onChanged: (email) => user.emailChange(email),
                      hintText: 'Enter Email here',
                    ),
                    AuthTextField(
                      onChanged: (password) => user.passwordChange(password),
                      hintText: 'Enter password here',
                    ),
                    AuthButton(
                      onTap: () {
                        user.firebaseLogin();
                      },
                      text: 'Login',
                    ),
                    AuthButton(
                        onTap: () {
                          if (currentUser.currentUser != null) {
                            log(currentUser.currentUser!.email!);
                          } else {
                            log('User is currently signed out!');
                          }
                        },
                        text: 'Check'),
                    AuthButton(
                        onTap: () {
                          try {
                            currentUser.signOut();
                          } catch (e) {
                            log(e.toString());
                          }
                        },
                        text: 'Sign-Out'),
                    AuthButton(
                        onTap: () {
                          user.firebaseSignup();
                        },
                        text: 'Sign-Up'),
                    AuthButton(
                        onTap: () {
                          currentUser.currentUser!.reload();
                          log(currentUser.currentUser!.emailVerified
                              .toString());
                        },
                        text: 'reload')
                  ]),
                ),
                const SizedBox(
                  height: 40,
                ),
                AuthText(
                  text: user.email,
                ),
                const AuthText(text: 'AMan')
              ],
            ),
          ),
        ),
      );
    });
  }
}

class AuthText extends StatelessWidget {
  const AuthText({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      color: Colors.amber,
      child: Text(
        text,
        style: theme.textTheme.bodyText1,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
