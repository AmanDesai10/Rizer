import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rizer/Signup/verify_email.dart';
import 'package:rizer/login/login_view.dart';

enum Category { student, faculty }

class SignupProvider with ChangeNotifier {
  String email = '';
  String password = '';
  String confirmPassword = '';
  String userName = '';
  bool isObscure = true;
  bool load = false;
  bool isValidated = false;
  bool isDetailValidated = false;
  Category userCategory = Category.student;
  String sem = '';
  String college = '';
  String dept = '';

  void emailChange(String email) {
    this.email = email;
    notifyListeners();
    validate();
  }

  void categoryChange(Category userCategory) {
    this.userCategory = userCategory;
    notifyListeners();
  }

  void usernameChange(String userName) {
    this.userName = userName;
    notifyListeners();
    validate();
  }

  void passwordChange(String password) {
    this.password = password;
    notifyListeners();
    validate();
  }

  void confirmPasswordChange(String confirmPassword) {
    this.confirmPassword = confirmPassword;
    notifyListeners();
    validate();
  }

  void changeSemester(String sem) {
    this.sem = sem;
    notifyListeners();
    validateDetails();
  }

  void changeCollege(String college) {
    if (this.college == college) return;
    this.college = college;
    dept = '';
    notifyListeners();
    validateDetails();
  }

  void changeDepartment(String dept) {
    this.dept = dept;
    notifyListeners();
    validateDetails();
  }

  void validate() {
    isValidated = email != '' &&
        password != '' &&
        userName != '' &&
        confirmPassword == password;
    notifyListeners();
  }

  void validateDetails() {
    isDetailValidated = userCategory.name == 'student'
        ? sem != '' && college != '' && dept != ''
        : college != '' && dept != '';
    notifyListeners();
  }

  void toggleObscure(bool isObscure) {
    this.isObscure = isObscure;
    notifyListeners();
  }

  void loadSignup(bool load) {
    this.load = load;
    notifyListeners();
  }

  Future<String> firebaseSignup(BuildContext context) async {
    String msg = '';
    try {
      log(email);
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      log(userCredential.toString());
      userCredential.user!.updateDisplayName(userName);
      final CollectionReference users =
          FirebaseFirestore.instance.collection('users');

      await users.doc(userCredential.user!.uid).set({
        'Name': userName,
        'role': userCategory.name,
        'college': college.toLowerCase(),
        'dept': dept.toLowerCase(),
        'sem': sem
      }).then((_) {
        msg = 'Account created succssfully';
        log('User data added');
      }).catchError((error) => log("Failed to add user: $error"));

      if (userCredential.user != null) {
        final user = userCredential.user;
        if (!user!.emailVerified) {
          await user.sendEmailVerification();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => VerifyEmailView(
                        email: email,
                      ))).then((value) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const LoginView()));
          });
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        msg = 'The password provided is too weak.';
        log('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        msg = 'The account already exists for that email.';
        log('The account already exists for that email.');
      }
    } catch (e) {
      msg = e.toString();
      log(e.toString());
    }
    return msg;
  }
}
