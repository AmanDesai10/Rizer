import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rizer/faculty/add_quiz_category.dart';
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

    return Consumer<LoginProvider>(builder: (context, user, _) {
      return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
                child: Text(user.email.isEmpty
                    ? firebaseUser?.email ?? 'Guest'
                    : user.email)),
            TextButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        String quizInstitute = '';
                        String quizDept = '';
                        String quizSem = '';
                        return StatefulBuilder(builder: (context, setState) {
                          return AlertDialog(
                            content: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const TitleText(text: 'Select College'),
                                const SizedBox(
                                  height: 12.0,
                                ),
                                DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                      value: quizInstitute.isEmpty
                                          ? null
                                          : quizInstitute,
                                      hint: const Text('Select College'),
                                      items: List.generate(
                                          collegeList.length,
                                          (index) => DropdownMenuItem(
                                              value: collegeList[index],
                                              child: Text(collegeList[index]
                                                  .toString()))),
                                      onChanged: (value) {
                                        quizInstitute = value!;
                                        quizDept = '';
                                        setState(() {});
                                      }),
                                ),
                                const TitleText(text: 'Select Department'),
                                const SizedBox(
                                  height: 12.0,
                                ),
                                DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                      value: quizDept.isEmpty ? null : quizDept,
                                      hint: const Text('Select dept'),
                                      items: List.generate(
                                          quizInstitute.isEmpty
                                              ? 0
                                              : deptMap[quizInstitute]!.length,
                                          (index) => DropdownMenuItem(
                                              value: deptMap[quizInstitute]![
                                                  index],
                                              child: Text(
                                                  deptMap[quizInstitute]![index]
                                                      .toString()))),
                                      onChanged: (value) {
                                        quizDept = value!;
                                        setState(() {});
                                      }),
                                ),
                                const TitleText(text: 'Select Sem'),
                                const SizedBox(
                                  height: 12.0,
                                ),
                                DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                      value: quizSem.isEmpty ? null : quizSem,
                                      hint: const Text('Select sem'),
                                      items: List.generate(
                                          semList.length,
                                          (index) => DropdownMenuItem(
                                              value: semList[index],
                                              child: Text(
                                                  semList[index].toString()))),
                                      onChanged: (value) {
                                        quizSem = value!;
                                        setState(() {});
                                      }),
                                ),
                              ],
                            ),
                            actions: [
                              Padding(
                                padding: const EdgeInsets.all(14.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0, vertical: 10.0),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            color: kWhite),
                                        child: Text(
                                          'Cancel',
                                          style: theme.textTheme.headline6!
                                              .copyWith(
                                                  fontSize: 14.0,
                                                  color: kPrimary),
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
                                                builder: (context) =>
                                                    AddQuizNameAndCategory(
                                                        quizInstitute:
                                                            quizInstitute,
                                                        quizDept: quizDept,
                                                        quizSem: quizSem)));
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0, vertical: 10.0),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            color: kPrimary),
                                        child: Text(
                                          'Next',
                                          style: theme.textTheme.headline6!
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
                child: Text('Create Quiz')),
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
                child: Text('Sign Out'))
          ],
        ),
      );
    });
  }
}
