import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rizer/faculty/dashboard.dart';

Future<void> categoryForwarding(BuildContext context) async {
  final User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    String userCategory = userData.data()!['role'];
    switch (userCategory) {
      case 'student':
        log('LOGGED IN AS STUDENT');
        break;
      case 'faculty':
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => DashboardScreen()));
        break;
      default:
    }
  }
}
