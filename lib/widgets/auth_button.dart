import 'package:flutter/material.dart';
import 'package:rizer/constants/colors.dart';

class AuthButton extends StatelessWidget {
  const AuthButton({Key? key, required this.onTap, required this.text})
      : super(key: key);

  final void Function()? onTap;
  final String text;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 50,
          width: size.width * 0.55,
          color: kPrimary,
          child: Center(
            child: Text(text),
          ),
        ),
      ),
    );
  }
}
