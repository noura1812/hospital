import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hospital/providers/hometabProviders.dart';
import 'package:hospital/screens/sign.dart';
import 'package:hospital/services/size_config.dart';
import 'package:hospital/screens/tabs/hometab.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  static const String routname = 'homescreen';
  final List tabs = [HomeTab()];
  int index = 0;

  HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    var homeTabProvider = Provider.of<HomeTabProviders>(context);

    return homeTabProvider.userdata == null
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
                    'Hi !${homeTabProvider.userdata.name}',
                    style: Theme.of(context).textTheme.headlineLarge,
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

                      Navigator.pushReplacementNamed(context, Sign.routname);
                    },
                    icon: const Icon(Icons.logout_sharp)),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: CircleAvatar(
                      radius: 25,
                      backgroundImage:
                          NetworkImage(homeTabProvider.userdata.imageurl)),
                )
              ],
            ),
            body: tabs[index],
          );
  }
}
