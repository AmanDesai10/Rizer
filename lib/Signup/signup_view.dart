import 'package:flutter/foundation.dart' as f;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rizer/Signup/institute_details.dart';
import 'package:rizer/Signup/provider/signup_provider.dart';
import 'package:rizer/constants/colors.dart';
import 'package:rizer/constants/validators.dart';
import 'package:rizer/widgets/textfields.dart';

class SignupView extends StatefulWidget {
  const SignupView({
    Key? key,
  }) : super(key: key);

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Size size = MediaQuery.of(context).size;
    return Consumer<SignupProvider>(builder: (context, newUser, _) {
      return SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              // Align(
              //   alignment: Alignment.topRight,
              //   child: SvgPicture.asset(
              //     'images/topright.svg',
              //     height: isDesktop ? null : size.height * 0.2,
              //   ),
              // ),
              // Align(
              //   alignment: Alignment.bottomLeft,
              //   child: SvgPicture.asset(
              //     'images/bottomleft.svg',
              //     height: isDesktop ? null : size.height * 0.2,
              //   ),
              // ),
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(35.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: f.kIsWeb
                          ? CrossAxisAlignment.center
                          : CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Signup',
                          style: theme.textTheme.headline6!.copyWith(
                              fontWeight: FontWeight.bold, fontSize: 28),
                        ),
                        SizedBox(
                          height: size.height * 0.06,
                        ),
                        Center(
                          child: SizedBox(
                            // height: size.height * 0.75,
                            width: size.width > 450 ? 450 : null,
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom),
                                  child: SingleChildScrollView(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 16.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          AuthTextField(
                                            title: 'Username',
                                            hintText: 'Enter full Name',
                                            onChanged: (userName) => newUser
                                                .usernameChange(userName),
                                            validator: nameValidator,
                                          ),
                                          const SizedBox(
                                            height: 28,
                                          ),
                                          AuthTextField(
                                            title: 'Email',
                                            hintText: 'Enter Email',
                                            onChanged: (email) =>
                                                newUser.emailChange(email),
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'This field is required.';
                                              }
                                              if (!value.contains(
                                                  newUser.userCategory ==
                                                          Category.student
                                                      ? '@charusat.edu.in'
                                                      : '@charusat.ac.in')) {
                                                return 'Please enter charusat email id';
                                              }
                                              return null;
                                            },
                                          ),
                                          const SizedBox(
                                            height: 28,
                                          ),
                                          AuthTextField(
                                            title: 'Password',
                                            hintText: 'Enter Password',
                                            onChanged: (password) => newUser
                                                .passwordChange(password),
                                            isObscure: newUser.isObscure,
                                            validator: passwordValidator,
                                            suffixIcon: GestureDetector(
                                              onTap: () =>
                                                  newUser.toggleObscure(
                                                      !newUser.isObscure),
                                              child: Icon(
                                                newUser.isObscure
                                                    ? Icons
                                                        .visibility_off_outlined
                                                    : Icons.visibility_outlined,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 28,
                                          ),
                                          AuthTextField(
                                            title: 'Confirm Password',
                                            hintText: 'Confirm Your Password',
                                            onChanged: (confirmPassword) =>
                                                newUser.confirmPasswordChange(
                                                    confirmPassword),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return "Please Enter password to Confirm";
                                              } else if (value !=
                                                  newUser.password) {
                                                return "Password does not match";
                                              }
                                            },
                                            isObscure: newUser.isObscure,
                                            // suffixIcon: GestureDetector(
                                            //   onTap: () {
                                            //     confirmObscure =
                                            //         !confirmObscure;
                                            //     setState(() {});
                                            //   },
                                            //   child: Icon(
                                            //     confirmObscure
                                            //         ? Icons
                                            //             .visibility_off_outlined
                                            //         : Icons.visibility_outlined,
                                            //     color: Colors.grey,
                                            //   ),
                                            // ),
                                          ),
                                          const SizedBox(
                                            height: 28,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 18.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Radio<Category>(
                                                        value: Category.student,
                                                        groupValue: newUser
                                                            .userCategory,
                                                        onChanged: (value) =>
                                                            newUser
                                                                .categoryChange(
                                                                    value!)),
                                                    const SizedBox(
                                                      width: 16.0,
                                                    ),
                                                    Text(
                                                      'Student',
                                                      style: theme
                                                          .textTheme.bodyText1,
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Radio<Category>(
                                                        value: Category.faculty,
                                                        groupValue: newUser
                                                            .userCategory,
                                                        onChanged: (value) =>
                                                            newUser
                                                                .categoryChange(
                                                                    value!)),
                                                    const SizedBox(
                                                      width: 16.0,
                                                    ),
                                                    Text(
                                                      'Faculty',
                                                      style: theme
                                                          .textTheme.bodyText1,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 24.0,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    if (_formKey.currentState!.validate() &&
                                        newUser.isValidated) {
                                      newUser.changeCollege('');
                                      newUser.changeDepartment('');
                                      newUser.changeSemester('');
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const UserDetails()));
                                    }
                                  },
                                  child: Container(
                                    width: size.width,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    decoration: BoxDecoration(
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Colors.black,
                                            blurRadius: 2.0,
                                            spreadRadius: 0.0,
                                          ),
                                        ],
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                        color: newUser.isValidated
                                            ? kPrimary
                                            : Colors.grey),
                                    child: Text(
                                      'Next',
                                      style: theme.textTheme.headline6!
                                          .copyWith(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                // !_formKey.currentState!.validate()
                                //     ? SizedBox(
                                //         height: size.height * 0.1,
                                //       )
                                //     : SizedBox()
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
