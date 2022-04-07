import 'package:flutter/material.dart';
import 'package:rizer/widgets/titles.dart';

import '../constants/colors.dart';

class AddOrEditQuestion extends StatelessWidget {
  const AddOrEditQuestion(
      {Key? key,
      required this.options,
      required this.question,
      required this.ans,
      required this.category})
      : super(key: key);

  final List<String> options;
  final String question;
  final int ans;
  final String category;

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
          TitleText(
            text: 'Category: $category',
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
                        onChanged: (value) {},
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
