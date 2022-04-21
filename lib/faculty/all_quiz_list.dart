import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rizer/constants/institute_data_list.dart';
import 'package:rizer/faculty/dept_all_quiz_list.dart';

import '../constants/colors.dart';

class FacultyAllQuizList extends StatefulWidget {
  const FacultyAllQuizList({Key? key, required this.userData})
      : super(key: key);
  final Map<String, dynamic> userData;

  @override
  _FacultyAllQuizListState createState() => _FacultyAllQuizListState();
}

class _FacultyAllQuizListState extends State<FacultyAllQuizList> {
  Future<Map<String, List<Map<String, dynamic>>>> getData() async {
    Map<String, List<Map<String, dynamic>>> userQuizList = {};

    for (int i = 0;
        i <
            (deptMap[widget.userData['college'].toString().toUpperCase()]
                    ?.length ??
                0);
        i++) {
      List<Map<String, dynamic>> temp = [];

      for (int j = 1; j <= 8; j++) {
        await FirebaseFirestore.instance
            .collection('organisation')
            .doc(widget.userData['college'].toString().toLowerCase() +
                '-' +
                (deptMap[widget.userData['college'].toString().toUpperCase()]
                            ?[i]
                        .toLowerCase() ??
                    'it'))
            .collection(j.toString())
            .get()
            .then((value) async {
          await Future.forEach<QueryDocumentSnapshot<Map<String, dynamic>>>(
              value.docs, (element) async {
            log(element.data().toString());
            var a = await FirebaseFirestore.instance
                .collection('organisation')
                .doc(widget.userData['college'].toString().toLowerCase() +
                    '-' +
                    (deptMap[widget.userData['college']
                                .toString()
                                .toUpperCase()]?[i]
                            .toLowerCase() ??
                        'it'))
                .collection(j.toString())
                .doc(element.id)
                .get();
            temp.add(a.data() as Map<String, dynamic>);
          });
        });
      }
      if (temp.isNotEmpty) {
        userQuizList[widget.userData['college'].toString().toLowerCase() +
            '-' +
            (deptMap[widget.userData['college'].toString().toUpperCase()]?[i]
                    .toLowerCase() ??
                'it')] = temp;
      }
    }
    print('stop');
    print(userQuizList);
    return userQuizList;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Size size = MediaQuery.of(context).size;

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
          'All Quiz List',
          style: theme.textTheme.headline6,
        ),
      ),
      body: SafeArea(
        child: FutureBuilder<Map<String, List<Map<String, dynamic>>>>(
            future: getData(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: kPrimary,
                  ),
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
                                                        DepartmentWiseAllQuizList(
                                                          quizList: snapshot
                                                              .data!.values
                                                              .elementAt(index),
                                                          college: snapshot
                                                              .data!.keys
                                                              .elementAt(index),
                                                        )));
                                          },
                                          child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16.0,
                                                      vertical: 12.0),
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16.0,
                                                      vertical: 8.0),
                                              height: 110,
                                              width: size.width - 50,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                  border: Border.all(
                                                      color: kPrimary),
                                                  color: kBackgroundColor
                                                      .withOpacity(0.2)),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    snapshot.data!.keys
                                                        .elementAt(index)
                                                        .toUpperCase(),
                                                    style: theme
                                                        .textTheme.headline6,
                                                  ),
                                                ],
                                              )),
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
