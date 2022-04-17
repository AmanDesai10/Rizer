import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rizer/widgets/titles.dart';

import '../constants/colors.dart';

class GiveQuizScreen extends StatefulWidget {
  const GiveQuizScreen({Key? key, required this.quizData}) : super(key: key);
  final Map<String, dynamic> quizData;
  @override
  _GiveQuizScreenState createState() => _GiveQuizScreenState();
}

class _GiveQuizScreenState extends State<GiveQuizScreen> {
  List<String> questions = [];
  List<List<String>> options = [];
  List<int> correctAnswers = [];
  List<String> questionCatgeory = [];
  List<int> userSelectedAnswer = [];
  String quizName = '';
  String subjectName = '';
  bool load = false;
  bool disable = true;
  int score = 0;
  Map<String, int> rizerAnalytics = {};

  void extractData(Map<String, dynamic> data) {
    data.entries.forEach((element) {
      //Extracting questions
      if (element.key == 'question') {
        List<dynamic> a = element.value;
        questions = List<String>.from(a);
      }
      //Extracting quizName
      if (element.key == 'quizName') {
        quizName = element.value;
      }
      if (element.key == 'subjectName') {
        subjectName = element.value;
      }
      //Extracting options
      if (element.key == 'questionOptionMap') {
        var a = Map.from(element.value);
        a.forEach((key, value) {
          var temp = value;
          temp = List<String>.from(temp);
          options.add(temp);
          print(options);
        });
      }
//Extracting correctAnswer
      if (element.key == 'questionAnswerMap') {
        var a = Map.from(element.value);
        a.forEach((key, value) {
          var temp = value;
          correctAnswers.add(temp);
        });
      }
      //Extracting Category
      if (element.key == 'questionCategoryMap') {
        var a = Map.from(element.value);
        a.forEach((key, value) {
          var temp = value;
          questionCatgeory.add(temp);
          rizerAnalytics[temp] = 0;
        });
      }
    });

    //initialte List of userSelected Answer
    questions.forEach((element) {
      userSelectedAnswer.add(-1);
    });
  }

  @override
  void initState() {
    extractData(widget.quizData);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    log(widget.quizData['question'].toString());
    if (userSelectedAnswer.contains(-1)) {
      disable = true;
    } else {
      disable = false;
    }
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
        backgroundColor: kWhite,
        title: Text(
          'Give Quiz',
          style: theme.textTheme.headline6,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(children: [
                  ...List.generate(questions.length, (index) {
                    return StudentQuizQuestionContainer(
                      question: questions[index],
                      options: options[index],
                      ans: userSelectedAnswer[index],
                      onChange: (value) {
                        userSelectedAnswer[index] = value!;
                        setState(() {});
                        log(userSelectedAnswer.toString());
                      },
                    );
                  })
                ]),
              ),
            ),
            const SizedBox(
              height: 16.0,
            ),
            GestureDetector(
              onTap: () async {
                load = true;
                setState(() {});
                score = 0;
                for (int i = 0; i < questions.length; i++) {
                  if (userSelectedAnswer[i] == correctAnswers[i]) {
                    score += 1;
                  } else {
                    rizerAnalytics[questionCatgeory[i]] =
                        rizerAnalytics[questionCatgeory[i]]! + 1;
                  }
                }
                print(score);
                print(rizerAnalytics);
                User? user = FirebaseAuth.instance.currentUser;
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(user!.uid)
                    .collection('givenQuiz')
                    .doc(quizName)
                    .set({
                  'quizName': quizName,
                  'subjectName': subjectName,
                  'questions': questions,
                  'questionOptionsMap':
                      widget.quizData.entries.elementAt(3).value,
                  'answers': correctAnswers,
                  'userAnswers': userSelectedAnswer,
                  'category': questionCatgeory,
                  'analytics': rizerAnalytics
                }).then((value) {
                  load = true;
                  setState(() {});
                  Navigator.pop(context);
                });
              },
              child: Container(
                height: 50,
                // padding: EdgeInsets.symmetric(vertical: 14),
                width: size.width,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    color: disable ? Colors.grey : kPrimary),
                child: load
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                color: kWhite,
                                strokeWidth: 3,
                              )),
                        ],
                      )
                    : Center(
                        child: Text(
                          'Submit',
                          style: theme.textTheme.headline6!.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class StudentQuizQuestionContainer extends StatelessWidget {
  const StudentQuizQuestionContainer({
    Key? key,
    required this.options,
    required this.question,
    required this.ans,
    required this.onChange,
  }) : super(key: key);

  final List<String> options;
  final String question;
  final int ans;
  final void Function(int?)? onChange;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Size size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      margin: const EdgeInsets.only(top: 16.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          color: kBackgroundColor.withOpacity(0.5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleText(
            text: question,
          ),
          const SizedBox(
            height: 12.0,
          ),
          ...List.generate(
              options.length,
              (index) => Row(
                    children: [
                      Radio(
                        value: index,
                        groupValue: ans,
                        onChanged: onChange,
                        activeColor: kPrimary,
                      ),
                      // Radio(value: options[index], groupValue: groupValue, onChanged: onChanged),
                      const SizedBox(
                        width: 12.0,
                      ),
                      Expanded(
                        child: TitleText(
                          text: options[index],
                        ),
                      ),
                    ],
                  )),
        ],
      ),
    );
  }
}
