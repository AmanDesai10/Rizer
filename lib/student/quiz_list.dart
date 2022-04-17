import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rizer/student/give_quiz.dart';

import '../constants/colors.dart';

class QuizList extends StatefulWidget {
  const QuizList({Key? key, required this.userData}) : super(key: key);
  final Map<String, dynamic> userData;
  @override
  _QuizListState createState() => _QuizListState();
}

class _QuizListState extends State<QuizList> {
  Future<List<Map<String, dynamic>>> getData() async {
    List<Map<String, dynamic>> userQuizList = [];

    QuerySnapshot<Map<String, dynamic>> quizList = await FirebaseFirestore
        .instance
        .collection('organisation')
        .doc(widget.userData['college'] + '-' + widget.userData['dept'])
        .collection(widget.userData['sem'])
        .get();

    await Future.forEach<QueryDocumentSnapshot<Map<String, dynamic>>>(
        quizList.docs, (element) async {
      User? user = FirebaseAuth.instance.currentUser;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection('givenQuiz')
          .doc(element.id)
          .get()
          .then((DocumentSnapshot documentSnapshot) async {
        if (!documentSnapshot.exists) {
          log('ADD');
          var a = await FirebaseFirestore.instance
              .collection('organisation')
              .doc(widget.userData['college'] + '-' + widget.userData['dept'])
              .collection(widget.userData['sem'])
              .doc(element.id)
              .get();
          userQuizList.add(a.data() as Map<String, dynamic>);
          log(a.data().toString());
        }
      }).catchError((e) {
        print(e);
      });
    });
    print(userQuizList);
    return userQuizList;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Size size = MediaQuery.of(context).size;
    print(widget.userData['college']);

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.chevron_left_outlined,
            color: Colors.black,
            size: 28.0,
          ),
        ),
        backgroundColor: kBackgroundColor,
        title: Text(
          'Quiz List',
          style: theme.textTheme.headline6,
        ),
      ),
      body: SafeArea(
        child: FutureBuilder<List<Map<String, dynamic>>>(
            future: getData(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return Padding(
                padding: const EdgeInsets.all(8.0).copyWith(top: 20.0),
                child: Column(
                  children: [
                    snapshot.data!.isEmpty
                        ? Center(
                            child: Text(
                              'No pending quiz!!',
                              style: theme.textTheme.headline6,
                            ),
                          )
                        : Container(
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: List.generate(
                                    snapshot.data!.length,
                                    (index) => GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        GiveQuizScreen(
                                                            quizData: snapshot
                                                                    .data![
                                                                index]))).then(
                                                (value) {
                                              setState(() {});
                                            });
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16.0,
                                                vertical: 12.0),
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 16.0,
                                                vertical: 8.0),
                                            height: 110,
                                            width: size.width - 50,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                border:
                                                    Border.all(color: kPrimary),
                                                color: kBackgroundColor
                                                    .withOpacity(0.2)),
                                            child: Row(
                                              children: [
                                                const CircleAvatar(
                                                  radius: 32.0,
                                                ),
                                                const SizedBox(width: 16.0),
                                                Expanded(
                                                  child: Container(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          snapshot.data![index]
                                                              ['quizName'],
                                                          style: theme.textTheme
                                                              .headline6,
                                                        ),
                                                        SizedBox(
                                                          height: 16.0,
                                                        ),
                                                        Text(
                                                          'Subject: CRNS',
                                                          style: theme.textTheme
                                                              .subtitle1,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        )),
                              ),
                            ),
                          ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
