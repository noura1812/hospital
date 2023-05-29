import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hospital/model/appointment.dart';
import 'package:hospital/model/doctors.dart';
import 'package:hospital/providers/hometabProviders.dart';
import 'package:hospital/services/size_config.dart';
import 'package:hospital/theme.dart';
import 'package:hospital/widgets/toast.dart';
import 'package:provider/provider.dart';

class DoctorsScreen extends StatelessWidget {
  static const String routname = 'Doctors screen ';

  const DoctorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var homeTabProvider = Provider.of<HmeTabProviders>(context);
    bool isDoctorFound = false;
    double stars = 0;

    DoctorsModel doctorsModel =
        ModalRoute.of(context)!.settings.arguments as DoctorsModel;
    for (Appointment appointment in homeTabProvider.userdata.appointments) {
      if (appointment.doctorsID == doctorsModel.id) {
        isDoctorFound = true;
        break;
      }
    }
    for (var review in doctorsModel.reviews) {
      stars += review.numstars;
    }
    stars = stars / doctorsModel.reviews.length;
    return Scaffold(
        backgroundColor: Themes.lighbackgroundColor,
        appBar: AppBar(
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                size: 25,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text(
              (doctorsModel.name.substring(0, 1).toUpperCase() +
                  doctorsModel.name.substring(1)),
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontSize: 20),
            )),
        body: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          CircleAvatar(
            radius: 63,
            backgroundColor: Theme.of(context).primaryColor,
            child: CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(doctorsModel.imageurl),
              backgroundColor: Theme.of(context).primaryColor,
            ),
          ),
          SizedBox(
            height: getProportionateScreenWidth(15),
          ),
          Text(
            doctorsModel.specialty,
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          SizedBox(
            height: getProportionateScreenWidth(7),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.star,
                color: Colors.yellow,
              ),
              Text(
                ' ${doctorsModel.reviews.isEmpty ? 0 : stars.toStringAsFixed(1)} (${doctorsModel.reviews.length > 999 ? ((doctorsModel.reviews.length) / 1000).floor() : doctorsModel.reviews.length}${doctorsModel.reviews.length > 999 ? 'k' : ''} reviews)',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(fontSize: 15),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          SizedBox(
            height: getProportionateScreenWidth(15),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Themes.backgroundColor),
            child: Column(children: [
              Text(
                'Experiance',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Themes.grey,
                    fontSize: 17,
                    fontWeight: FontWeight.w400),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                '${doctorsModel.yersofexp.toString()} Years',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(fontSize: 17, fontWeight: FontWeight.w500),
              )
            ]),
          ),
          homeTabProvider.userdata.id == doctorsModel.id
              ? Container()
              : Container(
                  height: SizeConfig.screenHeight * .06,
                  width: SizeConfig.screenWidth * .5,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: ElevatedButton(
                    onPressed: () {
                      //move to boking screen
                    },
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        backgroundColor: Themes.blue),
                    child: Text(
                      'Book apointment',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 15),
                    ),
                  ),
                ),
          isDoctorFound
              ? Container() //should be the appontment date
              : Container(
                  margin: const EdgeInsets.all(10),
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  height: SizeConfig.screenHeight * .13,
                  width: SizeConfig.screenWidth * .65,
                  decoration: BoxDecoration(
                      color: Themes.red,
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'Working hours',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w600),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.access_time,
                            size: 15,
                            color: Colors.white,
                          ),
                          Flexible(
                            child: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Text(
                                ' ${wdays(doctorsModel)}(${doctorsModel.workinghours.starthour} - ${doctorsModel.workinghours.endhour})',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                        fontSize: 17, color: Colors.white),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                )
        ]));
  }

  String wdays(DoctorsModel doctorsModel) {
    doctorsModel.workinghours.days.sort();
    if (doctorsModel.workinghours.days.length == 7) {
      return 'Sun-Fri';
    }
    var isContinuous = true;

    for (var i = 0; i < doctorsModel.workinghours.days.length - 1; i++) {
      if (doctorsModel.workinghours.days[i + 1] -
              doctorsModel.workinghours.days[i] !=
          1) {
        isContinuous = false;
        break;
      }
    }

    List<int> nums = [1, 2, 3, 4, 5, 6, 7];
    var listEquality = const ListEquality<int>();
    if (doctorsModel.workinghours.days.length >= 3 && isContinuous) {
      for (int i = 0; i < nums.length; i++) {
        for (int j = i; j < nums.length; j++) {
          List<int> subList = nums.sublist(i, j + 1);
          if (listEquality.equals(subList, doctorsModel.workinghours.days)) {
            String start = '';
            String end = '';
            if (subList[0] == 1) {
              start = 'Sat';
            } else if (subList[0] == 2) {
              start = 'Syn';
            } else if (subList[0] == 3) {
              start = 'Mon';
            } else if (subList[0] == 4) {
              start = 'Tue';
            }
            if (subList[subList.length - 1] == 3) {
              end = 'Mon';
            } else if (subList[subList.length - 1] == 4) {
              end = 'Tue';
            } else if (subList[subList.length - 1] == 5) {
              end = 'Wed';
            } else if (subList[subList.length - 1] == 6) {
              end = 'Thu';
            } else if (subList[subList.length - 1] == 7) {
              end = 'Fri';
            }

            return '$start-$end';
          }
        }
      }
    }

    String days = '';
    for (int i = 0; i < doctorsModel.workinghours.days.length; i++) {
      if (doctorsModel.workinghours.days[i] == 1) {
        days = '${days}Sat-';
      } else if (doctorsModel.workinghours.days[i] == 2) {
        days = '${days}Sun-';
      } else if (doctorsModel.workinghours.days[i] == 3) {
        days = '${days}Mon-';
      } else if (doctorsModel.workinghours.days[i] == 4) {
        days = '${days}Tue-';
      } else if (doctorsModel.workinghours.days[i] == 5) {
        days = '${days}Wed-';
      } else if (doctorsModel.workinghours.days[i] == 6) {
        days = '${days}Thu-';
      } else if (doctorsModel.workinghours.days[i] == 7) {
        days = '${days}Fri-';
      }
    }
    return days.substring(0, days.length - 1);
  }
}
