import 'package:flutter/material.dart';
import 'package:hospital/model/doctors.dart';
import 'package:hospital/providers/hometabProviders.dart';
import 'package:hospital/services/firebase/firebase_main_functions.dart';
import 'package:hospital/services/size_config.dart';
import 'package:hospital/theme.dart';
import 'package:hospital/widgets/doctorsLongCard.dart';
import 'package:provider/provider.dart';

class SearchByName extends StatefulWidget {
  static const String routname = 'Search by name ';

  SearchByName({super.key});

  @override
  State<SearchByName> createState() => _SearchByNameState();
}

class _SearchByNameState extends State<SearchByName> {
  TextEditingController searchController = TextEditingController();

  String searchString = '';

  @override
  Widget build(BuildContext context) {
    var homeTabProvider = Provider.of<HmeTabProviders>(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 25,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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
      body: Column(
        children: [
          SizedBox(
            height: getProportionateScreenWidth(30),
          ),
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(30)),
            child: TextFormField(
              onChanged: (value) {
                searchString = value;
                setState(() {});
              },
              autofocus: true,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Themes.grey, decoration: TextDecoration.none),
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
              if (searchString == '') {
                doctorsModel = [];
              }
              doctorsModel = doctorsModel
                  .where((element) => element.name.contains(searchString))
                  .toList();
              if (doctorsModel.isEmpty) {
                return Container();
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
        ],
      ),
    );
  }
}
