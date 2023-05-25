import 'package:flutter/material.dart';
import 'package:hospital/model/doctors.dart';
import 'package:hospital/model/fieldsmodel.dart';
import 'package:hospital/providers/hometabProviders.dart';
import 'package:hospital/services/firebase/firebase_main_functions.dart';
import 'package:hospital/services/size_config.dart';
import 'package:hospital/theme.dart';
import 'package:hospital/widgets/doctorsLongCard.dart';
import 'package:provider/provider.dart';

class SearchBySpecialityScreen extends StatelessWidget {
  static const String routname = 'SearchBySpecialityScreen';
  const SearchBySpecialityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var homeTabProvider = Provider.of<HmeTabProviders>(context);
    var homeTabMethods = Provider.of<HmeTabProviders>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            homeTabMethods.changeSpeciality('');
            homeTabMethods.resetFields();
            Navigator.pop(context);
          },
        ),
        title: Text(
          '${homeTabProvider.speciality}s',
          style:
              Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 20),
        ),
        centerTitle: true,
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
      body: Padding(
        padding: EdgeInsets.all(getProportionateScreenWidth(10)),
        child: Column(
          children: [
            Container(
              height: SizeConfig.screenHeight * .13,
              padding: EdgeInsets.symmetric(
                  vertical: getProportionateScreenWidth(20)),
              child: Row(
                children: [
                  ...homeTabProvider.fields.map((e) {
                    return fieldCard(e, context);
                  }).toList()
                ],
              ),
            ),
            StreamBuilder(
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Expanded(
                      child: Center(child: CircularProgressIndicator()));
                }
                List<DoctorsModel> doctorsModel =
                    snapshot.data?.docs.map((doc) => doc.data()).toList() ?? [];
                if (doctorsModel.isEmpty) {
                  return const Expanded(
                    child: Center(
                      child: Text('No doctors Available!'),
                    ),
                  );
                }
                return Expanded(
                  child: ListView.builder(
                    itemCount: doctorsModel.length,
                    itemBuilder: (context, index) {
                      return DoctorsLongCard(doctorsModel: doctorsModel[index]);
                    },
                  ),
                );
              },
              stream: FirebaseMainFunctions.getDoctorsBySpeciality(
                  homeTabProvider.speciality),
            ),
          ],
        ),
      ),
    );
  }

  Expanded fieldCard(
    FieldsModel e,
    BuildContext context,
  ) {
    var homeTabMethods = Provider.of<HmeTabProviders>(context, listen: false);

    return Expanded(
      flex: e.selected ? 9 : 5,
      child: Container(
        margin:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(5)),
        padding: EdgeInsets.all(getProportionateScreenWidth(5)),
        decoration: BoxDecoration(
            color: e.selected
                ? Theme.of(context).primaryColor
                : Themes.lighbackgroundColor,
            borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          onTap: () {
            homeTabMethods.selectField(e);
            homeTabMethods.changeSpeciality(e.name != 'Dentist'
                ? '${e.name.substring(0, e.name.length - 1)}ist'
                : e.name);
          },
          child: Column(
            children: [
              Expanded(
                  child: e.icon is String
                      ? ImageIcon(
                          AssetImage(e.icon),
                          color: e.selected
                              ? Colors.white
                              : Theme.of(context).primaryColor,
                        )
                      : Icon(
                          e.icon,
                          color: e.selected
                              ? Colors.white
                              : Theme.of(context).primaryColor,
                        )),
              e.selected
                  ? Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          e.name,
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                  color: e.selected
                                      ? Colors.white
                                      : Themes.textcolor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11),
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
