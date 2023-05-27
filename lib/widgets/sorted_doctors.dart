import 'package:flutter/material.dart';
import 'package:hospital/model/doctors.dart';
import 'package:hospital/providers/hometabProviders.dart';
import 'package:hospital/services/firebase/firebase_main_functions.dart';
import 'package:hospital/services/size_config.dart';
import 'package:hospital/theme.dart';
import 'package:hospital/widgets/doctorsLongCard.dart';
import 'package:provider/provider.dart';

class SortedDoctors extends StatefulWidget {
  SortedDoctors({super.key});

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
    var homeTabProvider = Provider.of<HmeTabProviders>(context);
    var homeTabMethods = Provider.of<HmeTabProviders>(context, listen: false);
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Themes.lighbackgroundColor,
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
                print('+++++-----------++');

                doctorsModel =
                    snapshot.data?.docs.map((doc) => doc.data()).toList() ?? [];
              } else if (indexOfSort == 1) {
                print('++++********+++');

                doctorsModel
                    .sort((a, b) => getTotalStars(b) - getTotalStars(a));
              } else if (indexOfSort == 2) {
                print('++1111111111111+++++');

                doctorsModel.sort(
                    (a, b) => b.reviews.length.compareTo(a.reviews.length));
              } else if (indexOfSort == 3) {
                doctorsModel.sort((a, b) => double.parse(b.yersofexp)
                    .compareTo(double.parse(a.yersofexp)));
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
            future: FirebaseMainFunctions.getDoctorsBySpeciality(
                homeTabProvider.speciality),
          ),
        ],
      ),
    );
  }

  int getTotalStars(DoctorsModel doctor) {
    int sum = 0;
    doctor.reviews.forEach((review) => sum += review.numstars);
    return sum;
  }

  dropdownSort(context, HmeTabProviders methodprovider) {
    return Consumer<HmeTabProviders>(
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