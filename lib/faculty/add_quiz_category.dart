import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rizer/faculty/add_questions.dart';

import '../constants/colors.dart';
import '../constants/validators.dart';
import '../widgets/questionContainer.dart';
import '../widgets/textfields.dart';
import '../widgets/titles.dart';

class AddQuizNameAndCategory extends StatefulWidget {
  const AddQuizNameAndCategory(
      {Key? key,
      required this.quizInstitute,
      required this.quizDept,
      required this.quizSem})
      : super(key: key);

  final String quizInstitute, quizDept, quizSem;
  @override
  _AddQuizNameAndCategoryState createState() => _AddQuizNameAndCategoryState();
}

class _AddQuizNameAndCategoryState extends State<AddQuizNameAndCategory> {
  List<String> categoryList = [];
  String quizName = '';
  bool load = false;

  final _formKey = GlobalKey<FormState>();
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
          'New Template',
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
                  const TitleText(text: 'Name'),
                  const SizedBox(
                    height: 16.0,
                  ),
                  AuthTextField(
                      hintText: 'Enter Quiz name',
                      onChanged: (value) {
                        quizName = value;
                      }),
                  const SizedBox(
                    height: 24.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const TitleText(
                                text: 'Categories',
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (context) {
                                          String category = '';

                                          return AlertDialog(
                                            content: Form(
                                              key: _formKey,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const TitleText(
                                                      text: 'Category'),
                                                  const SizedBox(
                                                    height: 12.0,
                                                  ),
                                                  SizedBox(
                                                    width: double.maxFinite,
                                                    child: AuthTextField(
                                                        autofocus: true,
                                                        validator:
                                                            fieldValidator,
                                                        hintText:
                                                            'Enter category name',
                                                        onChanged: (value) {
                                                          category = value;
                                                          setState(() {});
                                                        }),
                                                  ),
                                                ],
                                              ),
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
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal:
                                                                    16.0,
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
                                                        if (_formKey
                                                            .currentState!
                                                            .validate()) {
                                                          categoryList
                                                              .add(category);

                                                          setState(() {});
                                                          Navigator.pop(
                                                              context);
                                                        }
                                                      },
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal:
                                                                    16.0,
                                                                vertical: 10.0),
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0),
                                                            color: kPrimary),
                                                        child: Text(
                                                          'Add',
                                                          style: theme.textTheme
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
                          const SizedBox(
                            height: 16.0,
                          ),
                          categoryList.isEmpty
                              ? Center(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 24.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16.0),
                                      color: kWhite,
                                    ),
                                    child: Text(
                                      'You haven\'t added any category yet!!!',
                                      style: theme.textTheme.headline6!
                                          .copyWith(fontSize: 18.0),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                )
                              : Container(
                                  padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0, vertical: 16.0)
                                      .copyWith(right: 8.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16.0),
                                    color: kWhite,
                                  ),
                                  child: Column(
                                    children: List.generate(
                                        categoryList.length,
                                        (index) => Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12.0),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    '${index + 1}',
                                                    style: theme
                                                        .textTheme.headline6!
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                  ),
                                                  const SizedBox(
                                                    width: 24.0,
                                                  ),
                                                  Expanded(
                                                      child: Text(
                                                          categoryList[index],
                                                          style: theme.textTheme
                                                              .bodyText1!
                                                              .copyWith(
                                                                  fontSize:
                                                                      18.0))),
                                                  GestureDetector(
                                                      onDoubleTap: () {},
                                                      onTap: () {
                                                        categoryList
                                                            .removeAt(index);
                                                        setState(() {});
                                                      },
                                                      child: const Icon(
                                                        Icons.delete_outline,
                                                        color: Colors.red,
                                                      )),
                                                  const SizedBox(
                                                    width: 8.0,
                                                  ),
                                                ],
                                              ),
                                            )),
                                  ),
                                ),
                        ],
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
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddQuestions(
                              quizName: quizName,
                              categoryList: categoryList,
                              quizDept: widget.quizDept,
                              quizInstitute: widget.quizInstitute,
                              quizSem: widget.quizSem,
                            )));
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
                              child: const CircularProgressIndicator(
                                color: kWhite,
                                strokeWidth: 3,
                              )),
                        ],
                      )
                    : Center(
                        child: Text(
                          'Next',
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
