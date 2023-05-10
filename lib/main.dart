import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hospital/screens/homescreen.dart';
import 'package:hospital/screens/sign.dart';
import 'package:hospital/services/firebase/getDoctorsData.dart';
import 'package:hospital/services/providers/hometabProviders.dart';
import 'package:hospital/services/providers/signproviders.dart';
import 'package:hospital/theme.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<signprividers>(create: (_) => signprividers()),
    ChangeNotifierProvider<HmeTabProviders>(create: (_) => HmeTabProviders()),
    ChangeNotifierProvider<GetDoctorsData>(create: (_) => GetDoctorsData()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: Sign.routname,
      routes: {
        Sign.routname: (context) => const Sign(),
        HomeScreen.routname: (context) => HomeScreen(),
      },
      theme: Themes.lightTheme,
    );
  }
}
