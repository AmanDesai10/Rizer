import 'package:flutter/material.dart';

import 'constants/colors.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 45,
            width: 45,
            child: CircularProgressIndicator(
              color: kPrimary,
            ),
          )
        ],
        // child: Image.asset('images/icon1.png'),
      ),
    );
  }
}
