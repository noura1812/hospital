import 'package:flutter/material.dart';
import 'package:hospital/model/appointment.dart';
import 'package:hospital/services/size_config.dart';
import 'package:hospital/theme.dart';
import 'package:intl/intl.dart';

class AppointmentCard extends StatelessWidget {
  final Appointment currentAppointment;
  Function cancelAppointment;
  Function editAppointment;
  AppointmentCard(
      {required this.cancelAppointment,
      required this.currentAppointment,
      required this.editAppointment,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      height: SizeConfig.screenHeight * .11,
      width: SizeConfig.screenWidth * .6,
      decoration: BoxDecoration(
          color: Themes.backgroundColor,
          borderRadius: BorderRadius.circular(20)),
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Stack(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: dropdown(context),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.all(3),
                child: Text(
                  'Your appointment',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Themes.grey,
                      fontSize: 17,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ),
          ],
        ),
        Text(
            DateFormat('yyyy-MM-dd hh:mm a').format(
                (DateTime.fromMillisecondsSinceEpoch(currentAppointment.date))),
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(fontSize: 17, fontWeight: FontWeight.w500))
      ]),
    );
  }

  dropdown(context) {
    return DropdownButton<String>(
      isDense: true,
      underline: const SizedBox(),
      value: '',
      items: ['', 'cancel', 'edit'].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (newValueSelected) {
        if (newValueSelected != null) {
          if (newValueSelected == 'cancel') {
            cancelAppointment();
          } else if (newValueSelected == 'edit') {
            editAppointment();
          }
        }
      },
      icon: const Icon(
        Icons.more_vert,
        color: Themes.grey,
        size: 23,
      ),
      style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 15),
    );
  }
}
