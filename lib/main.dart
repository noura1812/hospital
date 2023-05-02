import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hospital/screens/homescreen.dart';
import 'package:hospital/screens/sign.dart';
import 'package:hospital/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
  await Firebase.initializeApp();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: Sign.routname,
      routes: {
        Sign.routname: (context) => const Sign(),
        HomeScreen.routname: (context) => const HomeScreen(),
      },
      theme: Themes.lightTheme,
    );
  }
}
