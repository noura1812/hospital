import 'package:flutter/material.dart';
import 'package:hospital/model/fieldsmodel.dart';
import 'package:hospital/services/firebase/getDoctorsData.dart';
import 'package:hospital/services/providers/hometabProviders.dart';
import 'package:hospital/services/providers/signproviders.dart';
import 'package:hospital/services/size_config.dart';
import 'package:hospital/theme.dart';
import 'package:hospital/widgets/doctorsLongCard.dart';
import 'package:provider/provider.dart';

class HomeTab extends StatefulWidget {
  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  TextEditingController searchController = TextEditingController();
  bool _isloading = true;
  @override
  void initState() {
    Provider.of<GetDoctorsData>(context, listen: false).getData().then((value) {
      setState(() {
        _isloading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    var signInProvider = Provider.of<signprividers>(context);
    var homeTabProvider = Provider.of<HmeTabProviders>(context);
    var getDoctorsData = Provider.of<GetDoctorsData>(context);
    List doctors = getDoctorsData.doctors;
    bool isadoctor = signInProvider.isadoctor;
    var userdata =
        isadoctor ? signInProvider.doctorsdata : signInProvider.pationtdata;
    return Scaffold(
      backgroundColor: Themes.backgroundColor,
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
                backgroundImage: NetworkImage(isadoctor
                    ? signInProvider.doctorsdata.imageurl
                    : signInProvider.pationtdata.imageurl)),
          )
        ],
      ),
      body: _isloading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.all(getProportionateScreenWidth(15)),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
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
                      padding: EdgeInsets.symmetric(
                          horizontal: getProportionateScreenWidth(30)),
                      child: TextFormField(
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Themes.grey,
                            decoration: TextDecoration.none),
                        controller: searchController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            prefixIconColor: Themes.grey,
                            prefixIconConstraints: const BoxConstraints(
                              minWidth: 0,
                              minHeight: 0,
                            ),
                            prefixIcon: const Padding(
                              padding: EdgeInsets.only(
                                  top: 5, bottom: 5, right: 7, left: 12),
                              child: Icon(
                                Icons.search,
                                size: 20,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 15.0),
                            filled: true,
                            fillColor: Themes.lighbackgroundColor,
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
                    Expanded(
                      child: ListView.builder(
                        itemCount: doctors.length,
                        itemBuilder: (context, index) {
                          return DoctorsLongCard(doctorsModel: doctors[index]);
                        },
                      ),
                    )
                  ]),
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
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}