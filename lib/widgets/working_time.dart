import 'package:flutter/material.dart';
import 'package:hospital/providers/sign_providers.dart';
import 'package:hospital/services/size_config.dart';
import 'package:hospital/theme.dart';
import 'package:provider/provider.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class WorkingTime extends StatelessWidget {
  final days = [
    {'id': 1, 'name': 'Saturday'},
    {'id': 2, 'name': 'Sunday'},
    {'id': 3, 'name': 'Monday'},
    {'id': 4, 'name': 'Tuesday'},
    {'id': 5, 'name': 'Wednesday'},
    {'id': 6, 'name': 'Thursday'},
  ];
  final RegExp regExp = RegExp(r'^([01]?[0-9]|2[0-3]):00$');

  WorkingTime({super.key});

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<SignProvider>(context);
    var methodProvider = Provider.of<SignProvider>(context, listen: false);

    return Stack(
      children: [
        Container(
          margin:
              EdgeInsets.symmetric(vertical: getProportionateScreenHeight(10)),
          padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenHeight(10),
              vertical: getProportionateScreenHeight(10)),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Themes.grey,
              width: .5,
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: SizeConfig.screenHeight * .08,
                      margin: EdgeInsets.symmetric(
                          vertical: getProportionateScreenHeight(10)),
                      child: TextFormField(
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: Themes.grey, fontSize: 20),
                        key: const ValueKey('start'),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              !regExp.hasMatch(value)) {
                            return 'Pleas enter a valid start hour';
                          }
                          return null;
                        },
                        onSaved: ((newValue) => provider.startTime = newValue!),
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          suffixIcon: ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxWidth:
                                  50, // Minimum Width of the DropdownButtonFormField
                            ),
                            child: dropDownPmAm(
                                context, 'start', provider, methodProvider),
                          ),
                          errorStyle: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Themes.red, fontSize: 15),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 25.0, horizontal: 20.0),
                          fillColor: Themes.backgroundColor,
                          filled: true,
                          labelText: 'Start',
                          hintText: '12:00',
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
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Container(
                      height: SizeConfig.screenHeight * .08,
                      margin: EdgeInsets.symmetric(
                          vertical: getProportionateScreenHeight(10)),
                      child: TextFormField(
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: Themes.grey),
                        key: const ValueKey('End'),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              !regExp.hasMatch(value)) {
                            return 'Pleas enter a valid end hour';
                          } else if (provider.endPm == provider.startPm) {
                            if (int.parse(value.split(':')[0]) <
                                int.parse(provider.startTime.split(':')[0])) {
                              return 'Pleas enter a valid end hour';
                            }
                          }
                          return null;
                        },
                        onSaved: ((newValue) => provider.endTime = newValue!),
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          suffixIcon: ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxWidth:
                                  50, // Minimum Width of the DropdownButtonFormField
                            ),
                            child: dropDownPmAm(
                                context, 'end', provider, methodProvider),
                          ),
                          errorStyle: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Themes.red, fontSize: 15),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 25.0, horizontal: 20.0),
                          fillColor: Themes.backgroundColor,
                          filled: true,
                          labelText: 'End',
                          hintText: '12:00',
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
                ],
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(
                    bottom: getProportionateScreenHeight(10),
                    left: getProportionateScreenHeight(5),
                    right: getProportionateScreenHeight(5)),
                child: InkWell(
                    onTap: () {
                      return _showMultiSelect(context);
                    },
                    child: Text(
                      'Select working days!',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).primaryColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w500),
                    )),
              )
            ],
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Container(
            color: Themes.lightBackgroundColor,
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenHeight(5),
                vertical: getProportionateScreenHeight(3)),
            margin: EdgeInsets.symmetric(
                horizontal: getProportionateScreenHeight(10)),
            child: Text(
              'Set Working Time',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Themes.grey, fontSize: 15),
            ),
          ),
        ),
      ],
    );
  }

  dropDownPmAm(context, String state, SignProvider provider,
      SignProvider methodProvider) {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        border: InputBorder.none,
      ),
      value: state == 'start' ? provider.startPm : provider.endPm,
      onSaved: (newValue) => state == 'start'
          ? provider.startPm = newValue!
          : provider.endPm = newValue!,
      items: ['PM', "AM"].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (newValueSelected) {
        if (newValueSelected != null) {
          state == 'start'
              ? methodProvider.changeStartPm(newValueSelected)
              : methodProvider.changeEndPm(newValueSelected);
        }
      },
      icon: const Icon(
        Icons.arrow_drop_down,
        color: Themes.grey,
      ),
      style: Theme.of(context)
          .textTheme
          .bodySmall
          ?.copyWith(color: Themes.grey, fontSize: 15),
    );
  }

  void _showMultiSelect(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelectDialog(
          title: Text(
            'Select',
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          height: 350,
          itemsTextStyle: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: Themes.grey),
          items: days
              .map((option) =>
                  MultiSelectItem(option['id'], option['name'].toString()))
              .toList(),
          onConfirm: (results) {
            Provider.of<SignProvider>(context, listen: false)
                .setDayValue(results);
          },
          initialValue: Provider.of<SignProvider>(context).days,
        );
      },
    );
  }
}
