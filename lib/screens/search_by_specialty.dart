import 'package:flutter/material.dart';
import 'package:hospital/model/doctors.dart';
import 'package:hospital/model/fields_model.dart';
import 'package:hospital/providers/home_tab_providers.dart';
import 'package:hospital/services/firebase/firebase_main_functions.dart';
import 'package:hospital/services/size_config.dart';
import 'package:hospital/theme.dart';
import 'package:hospital/widgets/sorted_doctors.dart';
import 'package:hospital/widgets/top_doctors_card.dart';
import 'package:provider/provider.dart';

class SearchBySpecialtyScreen extends StatelessWidget {
  static const String routName = 'SearchBySpecialtyScreen';
  const SearchBySpecialtyScreen({super.key});
  @override
  Widget build(BuildContext context) {
    var homeTabProvider = Provider.of<HomeTabProviders>(context);
    var homeTabMethods = Provider.of<HomeTabProviders>(context, listen: false);
    return WillPopScope(
      onWillPop: () {
        homeTabMethods.changeSpecialty('');
        homeTabMethods.resetFields();
        Navigator.pop(context);
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 25,
            ),
            onPressed: () {
              homeTabMethods.changeSpecialty('');
              homeTabMethods.resetFields();
              Navigator.pop(context);
            },
          ),
          title: Text(
            '${homeTabProvider.specialty}s',
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
                      NetworkImage(homeTabProvider.userData.imageUrl)),
            )
          ],
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
              vertical: getProportionateScreenWidth(10),
              horizontal: getProportionateScreenWidth(15)),
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
              FutureBuilder(
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Expanded(
                        child: Center(child: CircularProgressIndicator()));
                  }
                  List<DoctorsModel> doctorsModel =
                      snapshot.data?.docs.map((doc) => doc.data()).toList() ??
                          [];
                  List<DoctorsModel> sortedDoctors = doctorsModel;

                  sortedDoctors.sort(
                      (a, b) => b.reviews.length.compareTo(a.reviews.length));
                  if (doctorsModel.isEmpty) {
                    return const Expanded(
                      child: Center(
                        child: Text('No doctors Available!'),
                      ),
                    );
                  }
                  return Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: getProportionateScreenWidth(180),
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: doctorsModel.length < 10
                                ? doctorsModel.length
                                : 10,
                            itemBuilder: (context, index) {
                              return SizedBox(
                                child: TopDoctorsCard(
                                    doctorsModel: sortedDoctors[index]),
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return SizedBox(
                                width: getProportionateScreenWidth(10),
                              );
                            },
                          ),
                        ),
                        const SortedDoctors(),
                      ],
                    ),
                  );
                },
                future: FirebaseMainFunctions.getDoctorsBySpecialty(
                    homeTabProvider.specialty),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Expanded fieldCard(
    FieldsModel e,
    BuildContext context,
  ) {
    var homeTabMethods = Provider.of<HomeTabProviders>(context, listen: false);

    return Expanded(
      flex: e.selected ? 9 : 5,
      child: Container(
        margin:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(5)),
        padding: EdgeInsets.all(getProportionateScreenWidth(5)),
        decoration: BoxDecoration(
            color: e.selected
                ? Theme.of(context).primaryColor
                : Themes.lightBackgroundColor,
            borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          onTap: () {
            homeTabMethods.selectField(e);
            homeTabMethods.changeSpecialty(e.name != 'Dentist'
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
                                      : Themes.textColor,
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
