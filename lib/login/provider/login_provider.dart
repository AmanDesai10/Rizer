import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class LoginProvider with ChangeNotifier {
  String email = '';
  String password = '';
  bool isObscure = false;
  bool load = false;
  bool isValidated = false;

  void emailChange(String email) {
    this.email = email;
    notifyListeners();
    validate();
  }

  void validate() {
    isValidated = email != '' && password != '';
    notifyListeners();
  }

  void passwordChange(String password) {
    this.password = password;
    notifyListeners();
    validate();
  }

  void toggleObscure(bool isObscure) {
    this.isObscure = isObscure;
    notifyListeners();
  }

  void loadLogin(bool load) {
    this.load = load;
    notifyListeners();
  }

  void signOut() {
    email = '';
    password = '';
    notifyListeners();
    validate();
  }

  Future<String> firebaseLogin() async {
    String msg = '';
    try {
      log(email);
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      log(userCredential.toString());
      if (userCredential.user != null) {
        final user = userCredential.user;
        msg = 'success';

        if (!user!.emailVerified) {
          await user.sendEmailVerification();
          msg = 'verify email';
        }
      } else {
        msg = 'Error occured';
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        log('No user found for that email.');
        msg = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        log('Wrong password provided for that user.');
        msg = 'Wrong password provided for that user.';
      }
    }
    return msg;
  }

  Future<void> firebaseSignup() async {
    try {
      log(email);
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      log(userCredential.toString());
      userCredential.user!.updateDisplayName('Aman');
      if (userCredential.user != null) {
        final user = userCredential.user;
        if (!user!.emailVerified) {
          user.sendEmailVerification();
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        log('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        log('The account already exists for that email.');
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
