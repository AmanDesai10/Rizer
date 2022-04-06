import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';
import 'package:rizer/Signup/signup_view.dart';
import 'package:rizer/category_forwarding.dart';
import 'package:rizer/constants/colors.dart';
import 'package:rizer/constants/validators.dart';
import 'package:rizer/login/provider/login_provider.dart';
import 'package:rizer/widgets/textfields.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Size size = MediaQuery.of(context).size;
    return Consumer<LoginProvider>(builder: (context, user, _) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(alignment: Alignment.topCenter, children: [
          Align(
            alignment: Alignment.topCenter,
            child: ClipPath(
              child: Container(
                width: size.width,
                height: size.height * 0.75,
                color: kPrimary,
              ),
              clipper: CustomClipPath(),
            ),
          ),
          Positioned(
            top: size.height * 0.2,
            child: Container(
              height: size.height * 0.6,
              width: size.width - 50 > 450 ? 450 : size.width - 50,
              margin: const EdgeInsets.symmetric(horizontal: 25),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(color: Colors.grey, blurRadius: 20)
                  ]),
              child: Padding(
                padding: const EdgeInsets.all(15.0).copyWith(top: 30),
                child: Column(
                  children: [
                    Text(
                      'Login',
                      style: theme.textTheme.headline6!.copyWith(
                          fontSize: 28,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      'Signin to continue!!',
                      style: theme.textTheme.subtitle1!.copyWith(
                        fontSize: 12,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Expanded(
                      child: Form(
                        key: _formKey,
                        child: ListView(
                          shrinkWrap: true,
                          padding: const EdgeInsets.all(16).copyWith(
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                          ),
                          children: [
                            AuthTextField(
                              title: 'Email',
                              hintText: 'Enter your email',
                              onChanged: (email) => user.emailChange(email),
                              validator: emailValidator,
                            ),
                            const SizedBox(
                              height: 32,
                            ),
                            AuthTextField(
                              title: 'Password',
                              hintText: 'Enter your password',
                              onChanged: (password) =>
                                  user.passwordChange(password),
                              isObscure: !user.isObscure,
                              validator: passwordValidator,
                              suffixIcon: GestureDetector(
                                child: Icon(
                                  !user.isObscure
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.grey,
                                ),
                                onTap: () =>
                                    user.toggleObscure(!user.isObscure),
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              children: [
                                // Transform.scale(
                                //   scale: 0.8,
                                //   child: Checkbox(
                                //     materialTapTargetSize:
                                //         MaterialTapTargetSize.shrinkWrap,
                                //     value: isRemember,
                                //     onChanged: (check) {
                                //       isRemember = check!;
                                //       setState(() {});
                                //     },
                                //   ),
                                // ),
                                // Text(
                                //   'Remember Me',
                                //   style: theme.textTheme.headline6!.copyWith(
                                //       fontSize: 14,
                                //       fontWeight: FontWeight.bold),
                                // ),
                                // Spacer(),
                                Text(
                                  'Forgot Password?',
                                  style: theme.textTheme.bodyText1!
                                      .copyWith(color: theme.primaryColor),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 32,
                            ),
                            GestureDetector(
                              onTap: () async {
                                if (_formKey.currentState!.validate() &&
                                    user.isValidated) {
                                  user.loadLogin(true);
                                  String msg = await user.firebaseLogin();
                                  if (msg == 'success') {
                                    await categoryForwarding(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Successfully logged in')));
                                  } else if (msg == 'verify email') {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'please verify your email.')));
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(msg)));
                                  }
                                  user.loadLogin(false);
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .removeCurrentSnackBar();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Please enter valid input.')));
                                }
                              },
                              child: Container(
                                height: size.height * 0.07,
                                // padding: EdgeInsets.symmetric(vertical: 14),
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16.0),
                                    color: !user.isValidated
                                        ? Colors.grey
                                        : kPrimary),
                                child: user.load
                                    ? Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                          'Login',
                                          style: theme.textTheme.headline6!
                                              .copyWith(
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
                    )
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            // top: 560,
            top: size.height - 100,
            left: 10.0,
            right: 20.0,
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(children: [
                TextSpan(
                    text: "Don't have an account?",
                    style: theme.textTheme.bodyText1),
                WidgetSpan(
                    child: GestureDetector(
                  child: Text(" SignUp",
                      style: theme.textTheme.bodyText1!.copyWith(
                          color: const Color(0xff4A5CFF),
                          fontWeight: FontWeight.bold)),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SignupView()));
                  },
                ))
              ]),
            ),
          )
        ]),
      );
    });
  }
}

class CustomClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 100);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 100);
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
