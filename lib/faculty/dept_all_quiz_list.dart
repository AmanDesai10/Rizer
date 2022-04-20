import 'package:flutter/material.dart';
import 'package:rizer/constants/institute_data_list.dart';
import 'package:rizer/faculty/quiz_details.dart';

import '../constants/colors.dart';

class DepartmentWiseAllQuizList extends StatefulWidget {
  const DepartmentWiseAllQuizList(
      {Key? key, required this.quizList, required this.college})
      : super(key: key);
  final List<Map<String, dynamic>> quizList;
  final String college;

  @override
  _DepartmentWiseAllQuizListState createState() =>
      _DepartmentWiseAllQuizListState();
}

class _DepartmentWiseAllQuizListState extends State<DepartmentWiseAllQuizList> {
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
          widget.college.toUpperCase(),
          style: theme.textTheme.headline6,
        ),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0).copyWith(top: 20.0),
        child: Column(
          children: [
            widget.quizList.isEmpty
                ? Center(
                    child: Text(
                      'You haven\'t made any quiz yet!!',
                      style: theme.textTheme.headline6,
                    ),
                  )
                : Container(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: List.generate(
                            widget.quizList.length,
                            (index) => GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                QuizDetailsScreen(
                                                    quizData: widget
                                                        .quizList[index])));
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 12.0),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 8.0),
                                    height: 110,
                                    width: size.width - 50,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(color: kPrimary),
                                        color:
                                            kBackgroundColor.withOpacity(0.2)),
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
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  widget.quizList[index]
                                                      ['quizName'],
                                                  style:
                                                      theme.textTheme.headline6,
                                                ),
                                                SizedBox(
                                                  height: 16.0,
                                                ),
                                                Text(
                                                  'Subject: ${widget.quizList[index]['subjectName']}',
                                                  style:
                                                      theme.textTheme.subtitle1,
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
      )),
    );
  }
}
