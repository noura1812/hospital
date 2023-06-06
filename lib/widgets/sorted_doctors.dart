import 'package:flutter/material.dart';
import 'package:hospital/model/doctors.dart';
import 'package:hospital/providers/home_tab_providers.dart';
import 'package:hospital/services/firebase/firebase_main_functions.dart';
import 'package:hospital/services/size_config.dart';
import 'package:hospital/theme.dart';
import 'package:hospital/widgets/doctors_long_card.dart';
import 'package:provider/provider.dart';

class SortedDoctors extends StatefulWidget {
  const SortedDoctors({super.key});

  @override
  State<SortedDoctors> createState() => _SortedDoctorsState();
}

class _SortedDoctorsState extends State<SortedDoctors> {
  final List<String> sortBy = [
    '',
    'Number of Stars',
    'Number of Patients',
    'Years of Exp'
  ];

  int indexOfSort = 0;

  @override
  Widget build(BuildContext context) {
    var homeTabProvider = Provider.of<HomeTabProviders>(context);
    var homeTabMethods = Provider.of<HomeTabProviders>(context, listen: false);
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Themes.lightBackgroundColor,
            ),
            margin:
                EdgeInsets.symmetric(vertical: getProportionateScreenWidth(15)),
            padding: const EdgeInsets.all(5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Sort by: ',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(fontSize: 15),
                ),
                dropdownSort(context, homeTabMethods)
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
                  snapshot.data?.docs.map((doc) => doc.data()).toList() ?? [];
              if (indexOfSort == 0) {
                doctorsModel =
                    snapshot.data?.docs.map((doc) => doc.data()).toList() ?? [];
              } else if (indexOfSort == 1) {
                doctorsModel
                    .sort((a, b) => getTotalStars(b) - getTotalStars(a));
              } else if (indexOfSort == 2) {
                doctorsModel.sort(
                    (a, b) => b.reviews.length.compareTo(a.reviews.length));
              } else if (indexOfSort == 3) {
                doctorsModel.sort((a, b) => double.parse(b.yearsOfExp)
                    .compareTo(double.parse(a.yearsOfExp)));
              }

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
            future: FirebaseMainFunctions.getDoctorsBySpecialty(
                homeTabProvider.specialty),
          ),
        ],
      ),
    );
  }

  int getTotalStars(DoctorsModel doctor) {
    int sum = 0;
    for (var review in doctor.reviews) {
      sum += review.numStars;
    }
    return sum;
  }

  dropdownSort(context, HomeTabProviders methodprovider) {
    return Consumer<HomeTabProviders>(
      builder: (context, value, child) {
        return DropdownButton<String>(
          underline: const SizedBox(),
          value: sortBy[indexOfSort],
          items: sortBy.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (newValueSelected) {
            if (newValueSelected != null) {
              indexOfSort = sortBy.indexOf(newValueSelected);
              setState(() {});
            }
          },
          icon: const Icon(
            Icons.keyboard_arrow_down_outlined,
            color: Themes.grey,
            size: 25,
          ),
          style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 15),
        );
      },
    );
  }
}
