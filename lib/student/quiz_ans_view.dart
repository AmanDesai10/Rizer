import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rizer/student/analytics.dart';
import 'package:rizer/widgets/titles.dart';

import '../constants/colors.dart';

class StudentQuizAnalytics extends StatefulWidget {
  const StudentQuizAnalytics({Key? key, required this.quizData})
      : super(key: key);
  final Map<String, dynamic> quizData;
  @override
  _StudentQuizAnalyticsState createState() => _StudentQuizAnalyticsState();
}

class _StudentQuizAnalyticsState extends State<StudentQuizAnalytics> {
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
      if (element.key == 'questions') {
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
      if (element.key == 'questionOptionsMap') {
        var a = Map.from(element.value);
        a.forEach((key, value) {
          var temp = value;
          temp = List<String>.from(temp);
          options.add(temp);
          print(options);
        });
      }
//Extracting correctuserAnswer
      if (element.key == 'answers') {
        List<dynamic> a = element.value;
        print(a);
        correctAnswers = List<int>.from(a);
      }
      //Extracting Category
      if (element.key == 'category') {
        List<dynamic> a = element.value;
        print(a);
        questionCatgeory = List<String>.from(a);
      }
      //Extracting Analytics
      if (element.key == 'analytics') {
        var a = Map.from(element.value);
        a.forEach((key, value) {
          rizerAnalytics[key] = value;
        });
        log('Analytics');
        log(rizerAnalytics.toString());
      }
      if (element.key == 'userAnswers') {
        List<dynamic> a = element.value;
        userSelectedAnswer = List<int>.from(a);
      }
    });

    print(questions);
    print(options);
    log(correctAnswers.toString());
    print(questionCatgeory);
    print(userSelectedAnswer);
    print(quizName);
    print(subjectName);
    print(rizerAnalytics);

    for (int i = 0; i < userSelectedAnswer.length; i++) {
      userSelectedAnswer[i] == correctAnswers[i] ? score++ : null;
    }
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
          quizName,
          style: theme.textTheme.headline6,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Align(
                alignment: Alignment.topRight,
                child: TitleText(text: 'Score: $score/${questions.length}')),
            SizedBox(
              height: 8.0,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(children: [
                  ...List.generate(questions.length, (index) {
                    return StudentQuizQuestionContainer(
                      question: questions[index],
                      category: questionCatgeory[index],
                      options: options[index],
                      userAns: userSelectedAnswer[index],
                      correctAnswer: correctAnswers[index],
                      onChange: (value) {},
                    );
                  })
                ]),
              ),
            ),
            const SizedBox(
              height: 16.0,
            ),
            GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => StudentAnalyticsView(
                          rizerAnalytics: rizerAnalytics, quizName: quizName))),
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
                          'View Analytics',
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
    required this.userAns,
    required this.onChange,
    required this.correctAnswer,
    required this.category,
  }) : super(key: key);

  final List<String> options;
  final String question;
  final String category;
  final int userAns;
  final int correctAnswer;
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
          color: userAns == correctAnswer
              ? kBackgroundColor.withOpacity(0.5)
              : Colors.red[100]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleText(
            text: question,
          ),
          const SizedBox(
            height: 12.0,
          ),
          TitleText(
            text: 'Category: ' + category,
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
                        groupValue: userAns,
                        onChanged: onChange,
                        activeColor:
                            userAns == correctAnswer ? kPrimary : Colors.red,
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
                      const SizedBox(
                        width: 12.0,
                      ),
                      Icon(
                        index == correctAnswer
                            ? Icons.check
                            : index == userAns
                                ? Icons.close
                                : null,
                        color: index == correctAnswer
                            ? Colors.green
                            : index == userAns
                                ? Colors.red
                                : null,
                      )
                    ],
                  )),
        ],
      ),
    );
  }
}
