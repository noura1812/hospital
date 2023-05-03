import 'package:flutter/material.dart';
import 'package:hospital/services/providers/signproviders.dart';
import 'package:hospital/services/size_config.dart';
import 'package:hospital/theme.dart';
import 'package:provider/provider.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class Workingtime extends StatelessWidget {
  final days = [
    {'id': 1, 'name': 'Saturday'},
    {'id': 2, 'name': 'Sunday'},
    {'id': 3, 'name': 'Monday'},
    {'id': 4, 'name': 'Tuesday'},
    {'id': 5, 'name': 'Wednesday'},
    {'id': 6, 'name': 'Thursday'},
  ];

  Workingtime({super.key});

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<signprividers>(context);
    var methodprovider = Provider.of<signprividers>(context, listen: false);

    return Stack(
      children: [
        Container(
          margin:
              EdgeInsets.symmetric(vertical: getProportionateScreenHeight(10)),
          padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenHeight(10)),
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
                          if (value == null || value.isEmpty) {
                            return 'Pleas enter a valid phone number';
                          }
                          return null;
                        },
                        onSaved: ((newValue) => provider.starttime = newValue!),
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          suffixIcon: ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxWidth:
                                  50, // Minimum Width of the DropdownButtonFormField
                            ),
                            child: dropdownpmam(
                                context, 'start', provider, methodprovider),
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
                          if (value == null || value.isEmpty) {
                            return 'Pleas enter a valid phone number';
                          }
                          return null;
                        },
                        onSaved: ((newValue) => provider.endtime = newValue!),
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          suffixIcon: ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxWidth:
                                  50, // Minimum Width of the DropdownButtonFormField
                            ),
                            child: dropdownpmam(
                                context, 'end', provider, methodprovider),
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
                      print(provider.days);
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
            color: Themes.lighbackgroundColor,
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

  dropdownpmam(context, String state, provider, methodprovider) {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        border: InputBorder.none,
      ),
      value: state == 'start' ? provider.startpm : provider.endpm,
      onSaved: (newValue) => state == 'start'
          ? provider.startpm = newValue!
          : provider.endpm = newValue!,
      items: ['PM', "AM"].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (newValueSelected) {
        state == 'start'
            ? methodprovider.changstartpm(newValueSelected)
            : methodprovider.changendtpm(newValueSelected);
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
            Provider.of<signprividers>(context, listen: false)
                .setdayvalue(results);
          },
          initialValue: Provider.of<signprividers>(context).days,
        );
      },
    );
  }
}
