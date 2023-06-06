import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hospital/screens/booking_screen.dart';
import 'package:hospital/screens/doctors_screen.dart';
import 'package:hospital/screens/home_screen.dart';
import 'package:hospital/screens/search_by_name.dart';
import 'package:hospital/screens/search_by_specialty.dart';
import 'package:hospital/screens/sign.dart';
import 'package:hospital/screens/sms_verification_screen.dart';
import 'package:hospital/providers/home_tab_providers.dart';
import 'package:hospital/providers/sign_providers.dart';
import 'package:hospital/theme.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<SignProvider>(create: (_) => SignProvider()),
    ChangeNotifierProvider<HomeTabProviders>(create: (_) => HomeTabProviders()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<HomeTabProviders>(context);
    var sProvider = Provider.of<SignProvider>(context);

    return MaterialApp(
      initialRoute: provider.firebaseUser != null && sProvider.isLogin
          ? HomeScreen.routName
          : Sign.routName,
      routes: {
        Sign.routName: (context) => const Sign(),
        HomeScreen.routName: (context) => HomeScreen(),
        SmsVerification.routName: (context) => const SmsVerification(),
        SearchByName.routName: (context) => const SearchByName(),
        DoctorsScreen.routName: (context) => const DoctorsScreen(),
        BookingScreen.routName: (context) => const BookingScreen(),
        SearchBySpecialtyScreen.routName: (context) =>
            const SearchBySpecialtyScreen(),
      },
      themeMode: ThemeMode.light,
      theme: Themes.lightTheme,
    );
  }
}
