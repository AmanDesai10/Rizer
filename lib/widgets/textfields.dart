import 'package:flutter/material.dart';

class AuthTextField extends StatelessWidget {
  const AuthTextField(
      {Key? key,
      this.title,
      this.hintText,
      this.onChanged,
      this.validator,
      this.isObscure = false,
      this.suffixIcon,
      this.maxLines = 1,
      this.readOnly = false,
      this.autofocus = false,
      this.initialValue,
      this.hintStyle})
      : super(key: key);

  final String? title;
  final String? hintText;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final bool isObscure;
  final Widget? suffixIcon;
  final int maxLines;
  final bool readOnly;
  final String? initialValue;
  final bool autofocus;
  final TextStyle? hintStyle;
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return TextFormField(
      readOnly: readOnly,
      maxLines: maxLines,
      autofocus: autofocus,
      cursorColor: theme.colorScheme.secondary,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: TextInputType.emailAddress,
      cursorRadius: const Radius.circular(16.0),
      initialValue: initialValue,
      cursorWidth: 1.0,
      autocorrect: false,
      obscureText: isObscure,
      onChanged: onChanged,
      style: theme.textTheme.headline6!.copyWith(fontSize: 16),
      validator: validator,
      // textInputAction: widget.textInputAction,
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelText: title,
        alignLabelWithHint: true,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18.0),
            borderSide: BorderSide(color: Colors.grey.shade400)),

        hintText: hintText,
        contentPadding:
            const EdgeInsets.all(16 * 1.4).copyWith(right: 16 * 1.4 * 2),
        labelStyle: theme.textTheme.bodyText2!
            .copyWith(fontSize: 20.0, color: Colors.grey[400]),
        // errorText: 'widget.errorText',
        hintStyle: hintStyle ??
            theme.textTheme.bodyText2!
                .copyWith(fontSize: 16.0, color: Colors.grey.shade400),
      ),
    );
  }
}
