import 'package:flutter/material.dart';
import 'package:hospital/providers/hometabProviders.dart';
import 'package:hospital/services/size_config.dart';
import 'package:hospital/screens/tabs/hometab.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  static const String routname = 'homescreen';
  List tabs = [HomeTab()];
  int index = 0;

  HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    var homeTabProvider = Provider.of<HmeTabProviders>(context);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hi !',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            Text(
              DateTime.now().hour < 12 ? 'Good morning' : 'Good afternoon',
              style: Theme.of(context).textTheme.bodyMedium,
            )
          ],
        ),
        actions: [
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
