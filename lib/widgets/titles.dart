import 'package:flutter/material.dart';

class TitleText extends StatelessWidget {
  const TitleText({Key? key, required this.text, this.textAlign})
      : super(key: key);
  final String text;
  final TextAlign? textAlign;
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Text(
      text,
      style: theme.textTheme.headline6!
          .copyWith(fontWeight: FontWeight.bold, fontSize: 18),
      textAlign: textAlign,
    );
  }
}
