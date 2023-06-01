import 'package:flutter/material.dart';
import 'package:hospital/model/appointment.dart';
import 'package:hospital/model/doctors.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:hospital/model/pationtmodel.dart';
import 'package:hospital/services/firebase/firebase_main_functions.dart';
import 'package:intl/intl.dart';
import 'package:hospital/providers/hometabProviders.dart';
import 'package:hospital/services/size_config.dart';
import 'package:hospital/theme.dart';
import 'package:provider/provider.dart';

class BookingScreen extends StatefulWidget {
  static const String routname = 'booking screen';

  BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  List<DateTime> wDays = [];
  final _formKey = GlobalKey<FormState>();

  DateTime selectedValue = DateTime.now();
  String symptoms = '';
  List<String> wHours = [];
  int selectedHour = 0;
  @override
  Widget build(BuildContext context) {
    var homeTabProvider = Provider.of<HmeTabProviders>(context);

    DoctorsModel doctorsModel =
        ModalRoute.of(context)!.settings.arguments as DoctorsModel;
    if (wDays.isEmpty) {
      wDays = workingDays(doctorsModel.workinghours.days);
    }
    if (wHours.isEmpty) {
      wHours = WorkingHours(doctorsModel.workinghours.starthour,
          doctorsModel.workinghours.endhour);
    }
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
            style:
                Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 20),
          )),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DatePicker(
                daysCount: 356,
                DateTime.now(),
                initialSelectedDate:
                    wDays.isNotEmpty ? wDays[0] : selectedValue,
                selectionColor: Theme.of(context).primaryColor,
                deactivatedColor: Themes.grey.withOpacity(.7),
                selectedTextColor: Colors.white,
                dateTextStyle: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(fontSize: 15),
                dayTextStyle: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(fontSize: 15),
                monthTextStyle: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(fontSize: 15),
                activeDates: workingDays(doctorsModel.workinghours.days),
                height: 100,
                onDateChange: (selectedDate) {
                  selectedValue = selectedDate;
                  setState(() {});
                },
              ),
              Container(
                height: SizeConfig.screenHeight * .25,
                margin: EdgeInsets.only(
                    top: getProportionateScreenHeight(30),
                    bottom: getProportionateScreenHeight(20)),
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Themes.grey),
                    key: const ValueKey('symptoms'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Pleas enter your symptoms';
                      }
                      return null;
                    },
                    maxLines: 10,
                    onSaved: ((newValue) => symptoms = newValue!),
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      errorStyle: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Themes.red, fontSize: 15),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 25.0, horizontal: 20.0),
                      fillColor: Themes.backgroundColor,
                      filled: true,
                      labelText: 'Your symptoms...',
                      alignLabelWithHint:
                          true, // Align the label with the hint text

                      labelStyle: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Themes.grey, fontSize: 20),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
              ),
              Text(
                'Select Time',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontSize: 17, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: getProportionateScreenHeight(20),
              ),
              SizedBox(
                height: SizeConfig.screenHeight * .2,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: 10,
                      crossAxisCount: 4,
                      mainAxisExtent: 50,
                      mainAxisSpacing: 10),
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        selectedHour = index;
                        setState(() {});
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 7),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: index == selectedHour
                                ? Theme.of(context).primaryColor
                                : Themes.backgroundColor),
                        child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Text(
                            wHours[index],
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                    color: index == selectedHour
                                        ? Colors.white
                                        : Themes.textcolor,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: wHours.length,
                ),
              ),
              Container(
                width: double.infinity,
                height: SizeConfig.screenHeight * .08,
                margin: const EdgeInsets.only(
                    top: 20, bottom: 30, right: 30, left: 30),
                child: ElevatedButton(
                  onPressed: () {
                    bool validate = _subnmit();
                    if (validate) {
                      Appointment appointment = Appointment(
                          id:
                              '${homeTabProvider.userdata.id}${doctorsModel.id}',
                          pationtsID: homeTabProvider.userdata.id,
                          doctorsID: doctorsModel.id,
                          date: DateFormat('hh:mm a')
                              .parse(wHours[selectedHour])
                              .millisecondsSinceEpoch,
                          complains: symptoms);
                      PationtModel pationtModel = homeTabProvider.userdata;
                      pationtModel.appointments.add(appointment);
                      doctorsModel.appointments.add(appointment);
                      FirebaseMainFunctions.updatePationt(pationtModel);
                      FirebaseMainFunctions.updateDoctors(doctorsModel);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      backgroundColor: Theme.of(context).primaryColor),
                  child: Text(
                    'Book Appointment',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<String> WorkingHours(String start, String end) {
    String startDayTime = start.split(' ')[1];
    String endDayTime = end.split(' ')[1];
    int startHour = 0;
    int hours = 0;
    List<String> finalHours = [];
    if (startDayTime == endDayTime) {
      hours = int.parse(end.split(':')[0]) - int.parse(start.split(':')[0]);
      startHour = int.parse(start.split(':')[0]);
      for (var i = 0; i < hours; i++) {
        finalHours.add('${startHour + i}:00 $startDayTime');
      }
      return finalHours;
    } else {
      hours = 12 - int.parse(start.split(':')[0]);
      int counter = 0;
      String dayTime = startDayTime;
      hours = hours + int.parse(end.split(':')[0]);
      startHour = int.parse(start.split(':')[0]);
      for (var i = 0; i < hours; i++) {
        if (counter == 12) {
          counter = 0;
          dayTime = endDayTime;
        }

        finalHours.add('${startHour + counter}:00 $dayTime');
        counter++;
      }
      return finalHours;
    }
  }

  bool _subnmit() {
    final isvalid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isvalid) {
      _formKey.currentState!.save();
      return true;
    } else {
      return false;
    }
  }

  workingDays(List<int> days) {
    var firstDayOfYear =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    var lastDayOfYear = DateTime(
        DateTime.now().year + 1, DateTime.now().month, DateTime.now().day);
    List<DateTime> validDays = [];
    for (int i = 0; i < days.length; i++) {
      int day = 0;
      if (days[i] == 1) {
        day = DateTime.saturday;
      }
      if (days[i] == 2) {
        day = DateTime.sunday;
      }
      if (days[i] == 3) {
        day = DateTime.monday;
      }
      if (days[i] == 4) {
        day = DateTime.tuesday;
      }
      if (days[i] == 5) {
        day = DateTime.wednesday;
      }
      if (days[i] == 6) {
        day = DateTime.thursday;
      }
      List<DateTime> sublist = List.generate(
              lastDayOfYear.difference(firstDayOfYear).inDays + 1,
              (index) => firstDayOfYear.add(Duration(days: index)))
          .where((date) => date.weekday == day)
          .toList();

      validDays.addAll(sublist);
    }
    validDays.sort((a, b) => a.compareTo(b));

    return validDays;
  }
}
