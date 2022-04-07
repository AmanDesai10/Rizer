import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rizer/faculty/dashboard.dart';
import 'package:rizer/login/login_view.dart';
import 'package:rizer/student/student_dashboard.dart';

Future<Widget> categoryForwarding(BuildContext context) async {
  final User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    String userCategory = userData.data()!['role'];
    switch (userCategory) {
      case 'student':
        return const StudentDashboardScreen();
      case 'faculty':
        return const DashboardScreen();
      default:
        return const LoginView();
    }
  }
  return const LoginView();
}
