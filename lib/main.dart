import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rizer/Signup/provider/signup_provider.dart';
import 'package:rizer/category_forwarding.dart';
import 'package:rizer/firebase_options.dart';
import 'package:rizer/login/login_view.dart';
import 'package:rizer/login/provider/login_provider.dart';
import 'package:rizer/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => LoginProvider()),
    ChangeNotifierProvider(create: (context) => SignupProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget home = const SplashScreen();

  Future<void> getData() async {
    if (FirebaseAuth.instance.currentUser != null) {
      home = await categoryForwarding(context);
      setState(() {});
      return;
    }
    home = const LoginView();
    setState(() {});
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rizer',
      theme: ThemeData(
        fontFamily: 'Montserrat',
      ),
      home: home,
    );
  }
}
