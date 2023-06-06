import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hospital/providers/home_tab_providers.dart';
import 'package:hospital/providers/sign_providers.dart';
import 'package:hospital/screens/sign.dart';
import 'package:hospital/services/size_config.dart';
import 'package:hospital/screens/tabs/home_tab.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  static const String routName = 'homeScreen';
  final List tabs = [HomeTab()];

  HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    int index = 0;

    var homeTabProvider = Provider.of<HomeTabProviders>(context);
    var signInProvider = Provider.of<SignProvider>(context, listen: false);

    return homeTabProvider.userData == null
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hi ! ${(homeTabProvider.userData.name.substring(0, 1).toUpperCase() + homeTabProvider.userData.name.substring(1))}',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Text(
                    DateTime.now().hour < 12
                        ? 'Good morning'
                        : 'Good afternoon',
                    style: Theme.of(context).textTheme.bodyMedium,
                  )
                ],
              ),
              actions: [
                IconButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      signInProvider.changeVerified(false);
                      Navigator.of(context).pushReplacementNamed(Sign.routName);
                    },
                    icon: const Icon(Icons.logout_sharp)),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: CircleAvatar(
                      radius: 25,
                      backgroundImage:
                          NetworkImage(homeTabProvider.userData.imageUrl)),
                )
              ],
            ),
            body: tabs[index],
          );
  }
}
