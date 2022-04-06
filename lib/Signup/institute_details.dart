import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rizer/Signup/provider/signup_provider.dart';

import '../constants/colors.dart';
import '../login/login_view.dart';

class UserDetails extends StatelessWidget {
  const UserDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Size size = MediaQuery.of(context).size;
    final List<String> semList = ['1', '2', '3', '4', '5', '6', '7', '8'];
    final List<String> collegeList = ['CSPIT', 'DEPSTAR'];
    final Map<String, List<String>> deptMap = {
      'CSPIT': ['IT', 'ME'],
      'DEPSTAR': ['IT', 'CE', 'CSE']
    };
    return Consumer<SignupProvider>(builder: (context, newUser, _) {
      return Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              'Select your Institute',
              style: theme.textTheme.headline6!
                  .copyWith(fontSize: 28.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 64.0,
            ),
            Center(
              child: SizedBox(
                height: size.height * 0.5,
                width: size.width,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const UserDetailTitle(
                        title: 'College',
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      SizedBox(
                        height: 100,
                        width: double.maxFinite,
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: newUser.college.isEmpty
                                ? null
                                : newUser.college,
                            hint: const Text('Select College'),
                            items: List.generate(
                                collegeList.length,
                                (index) => DropdownMenuItem(
                                    value: collegeList[index],
                                    child:
                                        Text(collegeList[index].toString()))),
                            onChanged: (value) => newUser.changeCollege(value!),
                          ),
                        ),
                      ),
                      const UserDetailTitle(
                        title: 'Department',
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      SizedBox(
                        height: 100,
                        width: double.maxFinite,
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: newUser.dept.isEmpty ? null : newUser.dept,
                            hint: const Text('Select department'),
                            items: List.generate(
                                newUser.college.isEmpty
                                    ? 0
                                    : deptMap[newUser.college]!.length,
                                (index) => DropdownMenuItem(
                                    value: deptMap[newUser.college]![index],
                                    child: Text(deptMap[newUser.college]![index]
                                        .toString()))),
                            onChanged: (value) =>
                                newUser.changeDepartment(value!),
                          ),
                        ),
                      ),
                      if (newUser.userCategory.name == 'student') ...[
                        const UserDetailTitle(
                          title: 'Semester',
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),
                        SizedBox(
                          height: 100,
                          width: double.maxFinite,
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: newUser.sem == '' ? null : newUser.sem,
                              hint: const Text('Select Semester'),
                              items: List.generate(
                                  semList.length,
                                  (index) => DropdownMenuItem(
                                      value: semList[index],
                                      child: Text(semList[index].toString()))),
                              onChanged: (value) =>
                                  newUser.changeSemester(value!),
                            ),
                          ),
                        ),
                      ]
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 24.0,
            ),
            GestureDetector(
              onTap: newUser.isDetailValidated
                  ? () async {
                      newUser.loadSignup(true);
                      String msg = await newUser.firebaseSignup(context);
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(msg)));
                      newUser.loadSignup(false);
                    }
                  : null,
              child: Container(
                width: size.width,
                margin: const EdgeInsets.symmetric(horizontal: 5),
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 2.0,
                        spreadRadius: 0.0,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(16.0),
                    color: newUser.isDetailValidated ? kPrimary : Colors.grey),
                child: newUser.load
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
                    : Text(
                        'Signup',
                        style: theme.textTheme.headline6!.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(children: [
                TextSpan(
                    text: "Already a user?", style: theme.textTheme.bodyText1),
                WidgetSpan(
                    child: GestureDetector(
                  child: Text(" Login",
                      style: theme.textTheme.bodyText1!.copyWith(
                          color: kPrimary, fontWeight: FontWeight.bold)),
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginView()));
                  },
                ))
              ]),
            ),
          ]),
        ),
      );
    });
  }
}

// SizedBox(
//   height: 100,
//   width: 100,
//   child: DropdownButtonHideUnderline(
//       child: DropdownButton<int>(
//           value: newUser.sem == 0
//               ? null
//               : newUser.sem,
//           hint: Text('Select Sem'),
//           items: List.generate(
//               sem.length,
//               (index) =>
//                   DropdownMenuItem(
//                       value:
//                           sem[index],
//                       child: Text(sem[
//                               index]
//                           .toString()))),
//           onChanged: (value) =>
//               newUser.changeSemester(
//                   value!))),
// )

class UserDetailTitle extends StatelessWidget {
  const UserDetailTitle({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Text(
      title,
      style: theme.textTheme.headline6!.copyWith(fontWeight: FontWeight.bold),
      textAlign: TextAlign.start,
    );
  }
}
