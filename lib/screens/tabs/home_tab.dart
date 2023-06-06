import 'package:flutter/material.dart';
import 'package:hospital/model/doctors.dart';
import 'package:hospital/model/fields_model.dart';
import 'package:hospital/providers/home_tab_providers.dart';
import 'package:hospital/screens/search_by_name.dart';
import 'package:hospital/screens/search_by_specialty.dart';
import 'package:hospital/services/firebase/firebase_main_functions.dart';
import 'package:hospital/services/size_config.dart';
import 'package:hospital/theme.dart';
import 'package:hospital/widgets/doctors_long_card.dart';
import 'package:provider/provider.dart';

class HomeTab extends StatelessWidget {
  HomeTab({super.key});

  final TextEditingController searchController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var homeTabProvider = Provider.of<HomeTabProviders>(context);
    return Padding(
      padding: EdgeInsets.all(getProportionateScreenWidth(15)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Container(
          margin: EdgeInsets.only(
              top: getProportionateScreenWidth(10),
              bottom: getProportionateScreenWidth(30)),
          width: double.infinity,
          child: Column(children: [
            Text(
              'Find',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              'Your Doctor',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ]),
        ),
        Container(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(30)),
          child: TextFormField(
            focusNode: focusNode,
            onTap: () {
              focusNode.unfocus();

              Navigator.pushNamed(context, SearchByName.routName);
            },
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Themes.grey, decoration: TextDecoration.none),
            controller: searchController,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
                prefixIconColor: Themes.grey,
                prefixIconConstraints: const BoxConstraints(
                  minWidth: 0,
                  minHeight: 0,
                ),
                prefixIcon: const Padding(
                  padding:
                      EdgeInsets.only(top: 5, bottom: 5, right: 7, left: 12),
                  child: Icon(
                    Icons.search,
                    size: 20,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 15.0),
                filled: true,
                fillColor: Themes.lightBackgroundColor,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(20),
                ),
                hintText: 'Search doctors',
                hintStyle: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Themes.grey, fontSize: 15)),
          ),
        ),
        Container(
          height: SizeConfig.screenHeight * .13,
          padding:
              EdgeInsets.symmetric(vertical: getProportionateScreenWidth(20)),
          child: Row(
            children: [
              ...homeTabProvider.fields.map((e) {
                return fieldCard(e, context);
              }).toList()
            ],
          ),
        ),
        Row(
          children: [
            Text(
              'Top Doctors',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const Spacer(),
            Text(
              'See all',
              style: Theme.of(context).textTheme.bodySmall,
            )
          ],
        ),
        SizedBox(
          height: getProportionateScreenWidth(10),
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
          stream: FirebaseMainFunctions.getAllDoctors(),
        ),
      ]),
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
            Navigator.pushNamed(context, SearchBySpecialtyScreen.routName);
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
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}
