import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rizer/login/login_view.dart';
import 'package:rizer/login/provider/login_provider.dart';
import 'package:rizer/student/given_quiz_list.dart';
import 'package:rizer/student/quiz_list.dart';
import 'package:rizer/widgets/titles.dart';

import '../constants/colors.dart';

class StudentDashboardScreen extends StatefulWidget {
  const StudentDashboardScreen({Key? key}) : super(key: key);

  @override
  State<StudentDashboardScreen> createState() => _StudentDashboardScreenState();
}

class _StudentDashboardScreenState extends State<StudentDashboardScreen> {
  late User? firebaseUser;

  @override
  void initState() {
    if (FirebaseAuth.instance.currentUser != null) {
      firebaseUser = FirebaseAuth.instance.currentUser;
    }
    super.initState();
  }

  Map<String, dynamic> userData = {};
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    firebaseUser = FirebaseAuth.instance.currentUser;
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return Consumer<LoginProvider>(builder: (context, user, _) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimary,
          title: Text(
            'Rizer',
            style: theme.textTheme.headline6!.copyWith(
                fontWeight: FontWeight.bold, fontSize: 18, color: kWhite),
          ),
          actions: [
            TextButton.icon(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  user.signOut();
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginView()));
                },
                icon: const Icon(
                  Icons.logout_outlined,
                  color: kWhite,
                ),
                label: const Text(
                  'Logout',
                  style: const TextStyle(color: kWhite),
                ))
          ],
        ),
        body: FutureBuilder<DocumentSnapshot>(
            future: users.doc(firebaseUser!.uid).get(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const SizedBox(
                  height: 32.0,
                  width: 32.0,
                  child: CircularProgressIndicator(
                    color: kPrimary,
                  ),
                );
              }
              if (snapshot.hasData) {
                userData = snapshot.data!.data() as Map<String, dynamic>;
              }
              return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hey ${firebaseUser?.displayName},',
                          style: theme.textTheme.headline5!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => QuizList(
                                                userData: userData,
                                              )));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Container(
                                    height: 135,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 12.0),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        color: kPrimary.withOpacity(0.2)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.speaker_notes_outlined,
                                          size: 42.0,
                                        ),
                                        const SizedBox(
                                          height: 24.0,
                                        ),
                                        Center(
                                          child: Text(
                                            'Give Quiz',
                                            style: theme.textTheme.headline6!
                                                .copyWith(fontSize: 16.0),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 22.0,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => givenQuizList(
                                                userData: userData,
                                              )));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Container(
                                    height: 135,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 12.0),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        color: kPrimary.withOpacity(0.2)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.open_in_browser,
                                          size: 42.0,
                                        ),
                                        const SizedBox(
                                          height: 24.0,
                                        ),
                                        Center(
                                          child: Text(
                                            'View Given Quiz List',
                                            style: theme.textTheme.headline6!
                                                .copyWith(fontSize: 16.0),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]));
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                      child: Text(user.email.isEmpty
                          ? firebaseUser?.email ?? 'Guest'
                          : user.email)),
                  TextButton(
                      onPressed: () {
                        print(userData);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => QuizList(
                                      userData: userData,
                                    )));
                      },
                      child: const Text('View quiz list')),
                  TextButton(
                      onPressed: () {
                        print(userData);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => givenQuizList(
                                      userData: userData,
                                    )));
                      },
                      child: const Text('View Given quiz list')),
                  TextButton(
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                        user.signOut();
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginView()));
                      },
                      child: const Text('Sign Out'))
                ],
              );
            }),
      );
    });
  }
}
