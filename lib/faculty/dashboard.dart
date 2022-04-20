import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rizer/faculty/add_quiz_category.dart';
import 'package:rizer/faculty/all_quiz_list.dart';
import 'package:rizer/login/login_view.dart';
import 'package:rizer/login/provider/login_provider.dart';

import '../constants/colors.dart';
import '../constants/institute_data_list.dart';
import '../widgets/titles.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late User? firebaseUser;
  Map<String, dynamic> userData = {};

  @override
  void initState() {
    if (FirebaseAuth.instance.currentUser != null) {
      firebaseUser = FirebaseAuth.instance.currentUser;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Size size = MediaQuery.of(context).size;
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
                padding: const EdgeInsets.all(8.0),
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
                                showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) {
                                      String quizInstitute = '';
                                      String quizDept = '';
                                      String quizSem = '';
                                      return StatefulBuilder(
                                          builder: (context, setState) {
                                        return AlertDialog(
                                          content: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const TitleText(
                                                  text: 'Select College'),
                                              const SizedBox(
                                                height: 12.0,
                                              ),
                                              DropdownButtonHideUnderline(
                                                child: DropdownButton<String>(
                                                    value: quizInstitute.isEmpty
                                                        ? null
                                                        : quizInstitute,
                                                    hint: const Text(
                                                        'Select College'),
                                                    items: List.generate(
                                                        collegeList.length,
                                                        (index) => DropdownMenuItem(
                                                            value: collegeList[
                                                                index],
                                                            child: Text(
                                                                collegeList[
                                                                        index]
                                                                    .toString()))),
                                                    onChanged: (value) {
                                                      quizInstitute = value!;
                                                      quizDept = '';
                                                      setState(() {});
                                                    }),
                                              ),
                                              const TitleText(
                                                  text: 'Select Department'),
                                              const SizedBox(
                                                height: 12.0,
                                              ),
                                              DropdownButtonHideUnderline(
                                                child: DropdownButton<String>(
                                                    value: quizDept.isEmpty
                                                        ? null
                                                        : quizDept,
                                                    hint: const Text(
                                                        'Select dept'),
                                                    items: List.generate(
                                                        quizInstitute.isEmpty
                                                            ? 0
                                                            : deptMap[
                                                                    quizInstitute]!
                                                                .length,
                                                        (index) => DropdownMenuItem(
                                                            value: deptMap[
                                                                    quizInstitute]![
                                                                index],
                                                            child: Text(deptMap[
                                                                        quizInstitute]![
                                                                    index]
                                                                .toString()))),
                                                    onChanged: (value) {
                                                      quizDept = value!;
                                                      setState(() {});
                                                    }),
                                              ),
                                              const TitleText(
                                                  text: 'Select Sem'),
                                              const SizedBox(
                                                height: 12.0,
                                              ),
                                              DropdownButtonHideUnderline(
                                                child: DropdownButton<String>(
                                                    value: quizSem.isEmpty
                                                        ? null
                                                        : quizSem,
                                                    hint: const Text(
                                                        'Select sem'),
                                                    items: List.generate(
                                                        semList.length,
                                                        (index) => DropdownMenuItem(
                                                            value:
                                                                semList[index],
                                                            child: Text(semList[
                                                                    index]
                                                                .toString()))),
                                                    onChanged: (value) {
                                                      quizSem = value!;
                                                      setState(() {});
                                                    }),
                                              ),
                                            ],
                                          ),
                                          actions: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(14.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Container(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 16.0,
                                                          vertical: 10.0),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                          color: kWhite),
                                                      child: Text(
                                                        'Cancel',
                                                        style: theme.textTheme
                                                            .headline6!
                                                            .copyWith(
                                                                fontSize: 14.0,
                                                                color:
                                                                    kPrimary),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 18.0,
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) => AddQuizNameAndCategory(
                                                                  quizInstitute:
                                                                      quizInstitute,
                                                                  quizDept:
                                                                      quizDept,
                                                                  quizSem:
                                                                      quizSem)));
                                                    },
                                                    child: Container(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 16.0,
                                                          vertical: 10.0),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                          color: kPrimary),
                                                      child: Text(
                                                        'Next',
                                                        style: theme.textTheme
                                                            .headline6!
                                                            .copyWith(
                                                                fontSize: 14.0,
                                                                color: kWhite),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        );
                                      });
                                    });
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Container(
                                  height: 135,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 12.0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
                                      color: kPrimary.withOpacity(0.2)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                          'Create Quiz',
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
                                        builder: (context) =>
                                            FacultyAllQuizList(
                                              userData: userData,
                                            )));
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Container(
                                  height: 135,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 12.0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
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
                                          'View All Quizzes',
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
                    ]),
              );
            }),

        // Column(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     Center(
        //         child: Text(user.email.isEmpty
        //             ? firebaseUser?.email ?? 'Guest'
        //             : user.email)),
        //     TextButton(
        //         onPressed: () {
        //           showDialog(
        //               context: context,
        //               barrierDismissible: false,
        //               builder: (context) {
        //                 String quizInstitute = '';
        //                 String quizDept = '';
        //                 String quizSem = '';
        //                 return StatefulBuilder(builder: (context, setState) {
        //                   return AlertDialog(
        //                     content: Column(
        //                       crossAxisAlignment: CrossAxisAlignment.start,
        //                       mainAxisSize: MainAxisSize.min,
        //                       children: [
        //                         const TitleText(text: 'Select College'),
        //                         const SizedBox(
        //                           height: 12.0,
        //                         ),
        //                         DropdownButtonHideUnderline(
        //                           child: DropdownButton<String>(
        //                               value: quizInstitute.isEmpty
        //                                   ? null
        //                                   : quizInstitute,
        //                               hint: const Text('Select College'),
        //                               items: List.generate(
        //                                   collegeList.length,
        //                                   (index) => DropdownMenuItem(
        //                                       value: collegeList[index],
        //                                       child: Text(collegeList[index]
        //                                           .toString()))),
        //                               onChanged: (value) {
        //                                 quizInstitute = value!;
        //                                 quizDept = '';
        //                                 setState(() {});
        //                               }),
        //                         ),
        //                         const TitleText(text: 'Select Department'),
        //                         const SizedBox(
        //                           height: 12.0,
        //                         ),
        //                         DropdownButtonHideUnderline(
        //                           child: DropdownButton<String>(
        //                               value: quizDept.isEmpty ? null : quizDept,
        //                               hint: const Text('Select dept'),
        //                               items: List.generate(
        //                                   quizInstitute.isEmpty
        //                                       ? 0
        //                                       : deptMap[quizInstitute]!.length,
        //                                   (index) => DropdownMenuItem(
        //                                       value: deptMap[quizInstitute]![
        //                                           index],
        //                                       child: Text(
        //                                           deptMap[quizInstitute]![index]
        //                                               .toString()))),
        //                               onChanged: (value) {
        //                                 quizDept = value!;
        //                                 setState(() {});
        //                               }),
        //                         ),
        //                         const TitleText(text: 'Select Sem'),
        //                         const SizedBox(
        //                           height: 12.0,
        //                         ),
        //                         DropdownButtonHideUnderline(
        //                           child: DropdownButton<String>(
        //                               value: quizSem.isEmpty ? null : quizSem,
        //                               hint: const Text('Select sem'),
        //                               items: List.generate(
        //                                   semList.length,
        //                                   (index) => DropdownMenuItem(
        //                                       value: semList[index],
        //                                       child: Text(
        //                                           semList[index].toString()))),
        //                               onChanged: (value) {
        //                                 quizSem = value!;
        //                                 setState(() {});
        //                               }),
        //                         ),
        //                       ],
        //                     ),
        //                     actions: [
        //                       Padding(
        //                         padding: const EdgeInsets.all(14.0),
        //                         child: Row(
        //                           mainAxisAlignment: MainAxisAlignment.end,
        //                           children: [
        //                             GestureDetector(
        //                               onTap: () {
        //                                 Navigator.pop(context);
        //                               },
        //                               child: Container(
        //                                 padding: const EdgeInsets.symmetric(
        //                                     horizontal: 16.0, vertical: 10.0),
        //                                 decoration: BoxDecoration(
        //                                     borderRadius:
        //                                         BorderRadius.circular(10.0),
        //                                     color: kWhite),
        //                                 child: Text(
        //                                   'Cancel',
        //                                   style: theme.textTheme.headline6!
        //                                       .copyWith(
        //                                           fontSize: 14.0,
        //                                           color: kPrimary),
        //                                 ),
        //                               ),
        //                             ),
        //                             const SizedBox(
        //                               width: 18.0,
        //                             ),
        //                             GestureDetector(
        //                               onTap: () {
        //                                 Navigator.pop(context);
        //                                 Navigator.push(
        //                                     context,
        //                                     MaterialPageRoute(
        //                                         builder: (context) =>
        //                                             AddQuizNameAndCategory(
        //                                                 quizInstitute:
        //                                                     quizInstitute,
        //                                                 quizDept: quizDept,
        //                                                 quizSem: quizSem)));
        //                               },
        //                               child: Container(
        //                                 padding: const EdgeInsets.symmetric(
        //                                     horizontal: 16.0, vertical: 10.0),
        //                                 decoration: BoxDecoration(
        //                                     borderRadius:
        //                                         BorderRadius.circular(10.0),
        //                                     color: kPrimary),
        //                                 child: Text(
        //                                   'Next',
        //                                   style: theme.textTheme.headline6!
        //                                       .copyWith(
        //                                           fontSize: 14.0,
        //                                           color: kWhite),
        //                                 ),
        //                               ),
        //                             ),
        //                           ],
        //                         ),
        //                       )
        //                     ],
        //                   );
        //                 });
        //               });
        //         },
        //         child: Text('Create Quiz')),
        //     TextButton(
        //         onPressed: () {
        //           FirebaseAuth.instance.signOut();
        //           user.signOut();
        //           Navigator.pop(context);
        //           Navigator.push(
        //               context,
        //               MaterialPageRoute(
        //                   builder: (context) => const LoginView()));
        //         },
        //         child: Text('Sign Out'))
        //   ],
        // ),
      );
    });
  }
}
