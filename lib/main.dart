import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hospital/screens/booking_screen.dart';
import 'package:hospital/screens/doctors_screen.dart';
import 'package:hospital/screens/home_screen.dart';
import 'package:hospital/screens/search_by_name.dart';
import 'package:hospital/screens/search_by_speciality.dart';
import 'package:hospital/screens/sign.dart';
import 'package:hospital/screens/smsVirefecatiom.dart';
import 'package:hospital/providers/hometabProviders.dart';
import 'package:hospital/providers/signProviders.dart';
import 'package:hospital/theme.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<Signprividers>(create: (_) => Signprividers()),
    ChangeNotifierProvider<HomeTabProviders>(create: (_) => HomeTabProviders()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<HomeTabProviders>(context);

    return MaterialApp(
      initialRoute:
          provider.firebaseUser != null ? HomeScreen.routname : Sign.routname,
      routes: {
        Sign.routname: (context) => const Sign(),
        HomeScreen.routname: (context) => HomeScreen(),
        SmsVerification.routname: (context) => const SmsVerification(),
        SearchByName.routname: (context) => const SearchByName(),
        DoctorsScreen.routname: (context) => const DoctorsScreen(),
        BookingScreen.routname: (context) => const BookingScreen(),
        SearchBySpecialityScreen.routname: (context) =>
            const SearchBySpecialityScreen(),
      },
      theme: Themes.lightTheme,
    );
  }
}
