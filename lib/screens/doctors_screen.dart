import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hospital/model/appointment.dart';
import 'package:hospital/model/doctors.dart';
import 'package:hospital/providers/home_tab_providers.dart';
import 'package:hospital/screens/booking_screen.dart';
import 'package:hospital/services/firebase/firebase_main_functions.dart';
import 'package:hospital/services/size_config.dart';
import 'package:hospital/theme.dart';
import 'package:hospital/widgets/appointment_card.dart';
import 'package:hospital/widgets/reviews_list.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class DoctorsScreen extends StatefulWidget {
  static const String routName = 'Doctors screen ';

  const DoctorsScreen({super.key});

  @override
  State<DoctorsScreen> createState() => _DoctorsScreenState();
}

class _DoctorsScreenState extends State<DoctorsScreen> {
  int index = 1;

  @override
  Widget build(BuildContext context) {
    var homeTabProvider = Provider.of<HomeTabProviders>(context);
    bool isDoctorFound = false;
    Appointment? currentAppointment;
    double stars = 0;

    DoctorsModel doctorsModel =
        ModalRoute.of(context)!.settings.arguments as DoctorsModel;
    for (Appointment appointment in homeTabProvider.userData.appointments) {
      if (appointment.doctorsID == doctorsModel.id) {
        currentAppointment = appointment;
        isDoctorFound = true;
        break;
      }
    }
    for (var review in doctorsModel.reviews) {
      stars += review.numStars;
    }
    stars = stars / doctorsModel.reviews.length;
    void cancelAppointment() {
      homeTabProvider.deleteUserAppointment(currentAppointment!.id);
      FirebaseMainFunctions.cancelAppointment(
          homeTabProvider.userData, doctorsModel, currentAppointment.id);
    }

    void editAppointment() {
      homeTabProvider.setEditAppointment(currentAppointment);

      Navigator.pushNamed(context, BookingScreen.routName,
          arguments: doctorsModel);
    }

    return Scaffold(
        backgroundColor: Themes.lightBackgroundColor,
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
              backgroundImage: NetworkImage(doctorsModel.imageUrl),
              backgroundColor: Theme.of(context).primaryColor,
            ),
          ),
          SizedBox(
            height: getProportionateScreenHeight(5),
          ),
          Text(
            doctorsModel.specialty,
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          SizedBox(
            height: getProportionateScreenHeight(2),
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
            height: getProportionateScreenHeight(5),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            margin: const EdgeInsets.all(5),
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
                '${doctorsModel.yearsOfExp.toString()} Years',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(fontSize: 17, fontWeight: FontWeight.w500),
              )
            ]),
          ),
          homeTabProvider.isDoctor
              ? Container()
              : isDoctorFound
                  ? Container() //ways of comunication
                  : Container(
                      height: SizeConfig.screenHeight * .06,
                      width: SizeConfig.screenWidth * .5,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, BookingScreen.routName,
                              arguments: doctorsModel);
                          //move to boking screen
                        },
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            backgroundColor: Themes.blue),
                        child: Text(
                          'Book apointment',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15),
                        ),
                      ),
                    ),
          homeTabProvider.isDoctor || currentAppointment == null
              ? Container(
                  margin: const EdgeInsets.all(5),
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  height: SizeConfig.screenHeight * .1,
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
                                ' ${wDays(doctorsModel)}(${doctorsModel.workingHours.startHour} - ${doctorsModel.workingHours.endHour})',
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
              : AppointmentCard(
                  editAppointment: editAppointment,
                  cancelAppointment: cancelAppointment,
                  currentAppointment: currentAppointment),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Themes.backgroundColor),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextButton(
                          onPressed: () {
                            index = 1;
                            setState(() {});
                          },
                          child: Text(
                            'About',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    color: index == 1
                                        ? Theme.of(context).primaryColor
                                        : Themes.grey,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600),
                          )),
                      TextButton(
                          onPressed: () {
                            index = 2;
                            setState(() {});
                          },
                          child: Text(
                            'Reviews',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    color: index == 2
                                        ? Theme.of(context).primaryColor
                                        : Themes.grey,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600),
                          ))
                    ],
                  ),
                  Expanded(
                    child: index == 1
                        ? SingleChildScrollView(
                            child: AnimationConfiguration.synchronized(
                            child: FadeInAnimation(
                              duration: const Duration(seconds: 2),
                              child: SlideAnimation(
                                duration: const Duration(milliseconds: 1200),
                                verticalOffset: 300,
                                child: Text(
                                  doctorsModel.about,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                          height: 1.25, // set line height

                                          fontSize: 17,
                                          color: Themes.grey,
                                          decorationThickness: 10),
                                ),
                              ),
                            ),
                          ))
                        : doctorsModel.reviews.isEmpty
                            ? Center(
                                child: Text(
                                  'No reviews added',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                          height: 1.25, // set line height

                                          fontSize: 17,
                                          color: Themes.grey,
                                          decorationThickness: 10),
                                ),
                              )
                            : ListView.separated(
                                itemCount: doctorsModel.reviews.length,
                                itemBuilder: (context, index) {
                                  return AnimationConfiguration.staggeredList(
                                    position: index,
                                    duration:
                                        const Duration(milliseconds: 1000),
                                    child: SlideAnimation(
                                      verticalOffset: 300,
                                      child: ReviewsList(
                                        reviewsModel:
                                            doctorsModel.reviews[index],
                                      ),
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      child: const Divider(
                                        height: 2,
                                        endIndent: 20,
                                        indent: 20,
                                        color: Themes.textColor,
                                        thickness: 2,
                                      ));
                                },
                              ),
                  )
                ],
              ),
            ),
          )
        ]));
  }

  String wDays(DoctorsModel doctorsModel) {
    doctorsModel.workingHours.days.sort();
    if (doctorsModel.workingHours.days.length == 7) {
      return 'Sun-Fri';
    }
    var isContinuous = true;

    for (var i = 0; i < doctorsModel.workingHours.days.length - 1; i++) {
      if (doctorsModel.workingHours.days[i + 1] -
              doctorsModel.workingHours.days[i] !=
          1) {
        isContinuous = false;
        break;
      }
    }

    List<int> nums = [1, 2, 3, 4, 5, 6, 7];
    var listEquality = const ListEquality<int>();
    if (doctorsModel.workingHours.days.length >= 3 && isContinuous) {
      for (int i = 0; i < nums.length; i++) {
        for (int j = i; j < nums.length; j++) {
          List<int> subList = nums.sublist(i, j + 1);
          if (listEquality.equals(subList, doctorsModel.workingHours.days)) {
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

            return '$start to $end';
          }
        }
      }
    }

    String days = '';
    for (int i = 0; i < doctorsModel.workingHours.days.length; i++) {
      if (doctorsModel.workingHours.days[i] == 1) {
        days = '${days}Sat-';
      } else if (doctorsModel.workingHours.days[i] == 2) {
        days = '${days}Sun-';
      } else if (doctorsModel.workingHours.days[i] == 3) {
        days = '${days}Mon-';
      } else if (doctorsModel.workingHours.days[i] == 4) {
        days = '${days}Tue-';
      } else if (doctorsModel.workingHours.days[i] == 5) {
        days = '${days}Wed-';
      } else if (doctorsModel.workingHours.days[i] == 6) {
        days = '${days}Thu-';
      } else if (doctorsModel.workingHours.days[i] == 7) {
        days = '${days}Fri-';
      }
    }
    return days.substring(0, days.length - 1);
  }
}
