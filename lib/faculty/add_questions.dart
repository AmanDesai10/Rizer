import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../constants/validators.dart';
import '../widgets/questionContainer.dart';
import '../widgets/textfields.dart';
import '../widgets/titles.dart';

class AddQuestions extends StatefulWidget {
  const AddQuestions(
      {Key? key,
      required this.quizName,
      required this.categoryList,
      required this.quizInstitute,
      required this.quizDept,
      required this.quizSem})
      : super(key: key);
  final String quizName;
  final List<String> categoryList;
  final String quizInstitute, quizDept, quizSem;

  @override
  _AddQuestionsState createState() => _AddQuestionsState();
}

class _AddQuestionsState extends State<AddQuestions> {
  List<String> questionList = [];

  Map<String, List<String>> questionsOptionMap = {};
  Map<String, int> questionsAnswerMap = {};
  Map<String, String> questionCategoryMap = {};
  int answer = 0;
  String question = '';
  String newOption = '';

  List<String> options = [];
  bool load = false;
  bool addingOption = false;
  bool addingquestion = false;

  @override
  Widget build(BuildContext context) {
    if (questionsOptionMap.isEmpty) addingquestion = true;

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
          widget.quizName,
          style: theme.textTheme.headline6,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 32.0)
            .copyWith(bottom: 16.0),
        child: Column(
          children: [
            Expanded(
                child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const TitleText(
                            text: 'Questions',
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: GestureDetector(
                              onTap: () {
                                addingquestion = true;
                                setState(() {});
                              },
                              child: const Icon(
                                Icons.add,
                                color: kPrimary,
                                size: 32.0,
                              ),
                            ),
                          )
                        ],
                      ),
                      ...List.generate(questionsOptionMap.length, (index) {
                        return AddOrEditQuestion(
                          question:
                              questionsOptionMap.entries.elementAt(index).key,
                          options:
                              questionsOptionMap.entries.elementAt(index).value,
                          ans:
                              questionsAnswerMap.entries.elementAt(index).value,
                          category: questionCategoryMap.entries
                              .elementAt(index)
                              .value,
                        );
                      }),
                      if (addingquestion)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24.0, vertical: 16.0),
                          margin: const EdgeInsets.only(top: 16.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.0),
                              color: kBackgroundColor.withOpacity(0.5)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: double.maxFinite,
                                child: AuthTextField(
                                  validator: fieldValidator,
                                  hintText: 'Enter question',
                                  onChanged: (value) {
                                    question = value;
                                    setState(() {});
                                  },
                                  hintStyle: theme.textTheme.bodyText2!
                                      .copyWith(fontSize: 16.0, color: kWhite),
                                ),
                              ),
                              const SizedBox(
                                height: 16.0,
                              ),
                              ...List.generate(
                                  options.length,
                                  (index) => Row(
                                        children: [
                                          Radio(
                                              visualDensity:
                                                  const VisualDensity(
                                                      horizontal: 0.1),
                                              activeColor: kPrimary,
                                              value: index,
                                              groupValue: answer,
                                              onChanged: (value) {
                                                answer = index;
                                                setState(() {});
                                              }),
                                          const SizedBox(
                                            width: 12.0,
                                          ),
                                          Expanded(
                                            child: TextFormField(
                                              controller: TextEditingController(
                                                  text: options[index]),
                                              onChanged: (value) {
                                                options[index] = value;
                                              },
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 12.0,
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                                Icons.close_outlined),
                                            onPressed: () {
                                              options.removeAt(index);
                                              setState(() {});
                                            },
                                          )
                                        ],
                                      )),
                              if (options.isEmpty || addingOption)
                                Row(
                                  children: [
                                    Radio(
                                        visualDensity: const VisualDensity(
                                            horizontal: 0.1),
                                        activeColor: kPrimary,
                                        value: 0,
                                        groupValue: 1,
                                        onChanged: (value) {}),
                                    const SizedBox(
                                      width: 12.0,
                                    ),
                                    Expanded(
                                      child: TextFormField(
                                        controller: TextEditingController(
                                            text: newOption),
                                        onChanged: (value) {
                                          newOption = value;
                                          // setState(() {});
                                        },
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 12.0,
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.check),
                                      onPressed: () {
                                        options.add(newOption);
                                        addingOption = false;
                                        newOption = '';
                                        setState(() {});
                                      },
                                    )
                                  ],
                                ),
                              const SizedBox(
                                height: 12.0,
                              ),
                              Align(
                                  alignment: Alignment.topRight,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      ElevatedButton(
                                        onPressed: addingOption
                                            ? null
                                            : () {
                                                addingOption = true;
                                                setState(() {});
                                              },
                                        child: const Text('Add'),
                                        style: ElevatedButton.styleFrom(
                                            primary: kPrimary),
                                      ),
                                      const SizedBox(
                                        width: 12.0,
                                      ),
                                      ElevatedButton(
                                        onPressed: () async {
                                          await showDialog(
                                              barrierDismissible: false,
                                              context: context,
                                              builder: (context) {
                                                String questionCategory = '';

                                                return StatefulBuilder(builder:
                                                    (context, setState) {
                                                  return AlertDialog(
                                                    content: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        const TitleText(
                                                            text:
                                                                'Select Category'),
                                                        const SizedBox(
                                                          height: 12.0,
                                                        ),
                                                        DropdownButtonHideUnderline(
                                                          child: DropdownButton<
                                                                  String>(
                                                              value:
                                                                  questionCategory
                                                                          .isEmpty
                                                                      ? null
                                                                      : questionCategory,
                                                              hint: const Text(
                                                                  'Select Category'),
                                                              items: List.generate(
                                                                  widget
                                                                      .categoryList
                                                                      .length,
                                                                  (index) => DropdownMenuItem(
                                                                      value: widget.categoryList[
                                                                          index],
                                                                      child: Text(widget
                                                                          .categoryList[
                                                                              index]
                                                                          .toString()))),
                                                              onChanged:
                                                                  (value) {
                                                                questionCategory =
                                                                    value!;
                                                                setState(() {});
                                                              }),
                                                        ),
                                                      ],
                                                    ),
                                                    actions: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(14.0),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            GestureDetector(
                                                              onTap: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: Container(
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        16.0,
                                                                    vertical:
                                                                        10.0),
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10.0),
                                                                    color:
                                                                        kWhite),
                                                                child: Text(
                                                                  'Cancel',
                                                                  style: theme
                                                                      .textTheme
                                                                      .headline6!
                                                                      .copyWith(
                                                                          fontSize:
                                                                              14.0,
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
                                                                questionsOptionMap[
                                                                        question] =
                                                                    options;
                                                                questionsAnswerMap[
                                                                        question] =
                                                                    answer;
                                                                questionCategoryMap[
                                                                        question] =
                                                                    questionCategory;
                                                                questionList.add(
                                                                    question);
                                                                //Clear all fields
                                                                question = '';
                                                                options = [];
                                                                addingOption =
                                                                    false;
                                                                addingquestion =
                                                                    false;

                                                                answer = 0;

                                                                setState(() {});
                                                                log(questionsOptionMap
                                                                    .toString());
                                                                log(questionsAnswerMap
                                                                    .toString());
                                                                log(questionCategoryMap
                                                                    .toString());
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: Container(
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        16.0,
                                                                    vertical:
                                                                        10.0),
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10.0),
                                                                    color:
                                                                        kPrimary),
                                                                child: Text(
                                                                  'Save',
                                                                  style: theme
                                                                      .textTheme
                                                                      .headline6!
                                                                      .copyWith(
                                                                          fontSize:
                                                                              14.0,
                                                                          color:
                                                                              kWhite),
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
                                          setState(() {});
                                        },
                                        child: const Text('Save'),
                                        style: ElevatedButton.styleFrom(
                                            primary: kPrimary),
                                      ),
                                    ],
                                  ))
                            ],
                          ),
                        ),
                    ],
                  )
                ],
              ),
            )),
            const SizedBox(
              height: 16.0,
            ),
            GestureDetector(
              onTap: () async {
                load = true;
                setState(() {});
                await FirebaseFirestore.instance
                    .collection('organisation')
                    .doc(widget.quizInstitute.toLowerCase() +
                        '-' +
                        widget.quizDept.toLowerCase())
                    .collection(widget.quizSem)
                    .doc(widget.quizName)
                    .set({
                  'quizName': widget.quizName,
                  'question': questionList,
                  'questionOptionMap': questionsOptionMap,
                  'questionAnswerMap': questionsAnswerMap,
                  'questionCategoryMap': questionCategoryMap
                }, SetOptions(merge: false)).then((value) {
                  load = false;
                  setState(() {});
                  Navigator.pop(context);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('Quiz Created')));
                }).catchError((e) {
                  load = false;
                });

                setState(() {});
              },
              child: Container(
                height: 50,
                // padding: EdgeInsets.symmetric(vertical: 14),
                width: size.width,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0), color: kPrimary),
                child: load
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
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
                          'Create',
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
