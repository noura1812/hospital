import 'package:flutter/material.dart';
import 'package:hospital/services/firebase/getDoctorsData.dart';
import 'package:hospital/services/providers/signproviders.dart';
import 'package:hospital/services/size_config.dart';
import 'package:hospital/screens/tabs/hometab.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  static const String routname = 'homescreen';
  List tabs = [HomeTab()];
  int index = 0;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    var provider = Provider.of<signprividers>(context);
    var getDoctorsData = Provider.of<GetDoctorsData>(context, listen: false);
    getDoctorsData.getData();
    bool isadoctor = provider.isadoctor;
    var userdata = isadoctor ? provider.doctorsdata : provider.pationtdata;
    return tabs[index];
  }
}
