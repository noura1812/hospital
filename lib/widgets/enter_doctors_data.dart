import 'package:flutter/material.dart';
import 'package:hospital/providers/sign_providers.dart';
import 'package:hospital/services/size_config.dart';
import 'package:hospital/theme.dart';
import 'package:hospital/widgets/working_time.dart';
import 'package:provider/provider.dart';

class EnterDocsData extends StatelessWidget {
  final List<String> dropdownOptions = [
    'Ophthalmologist',
    'Otolaryngologist',
    'Cardiologist',
    'Dermatologist',
    'Dentist',
  ];

  EnterDocsData({super.key});

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<SignProvider>(context);
    var methodprovider = Provider.of<SignProvider>(context, listen: false);

    return Column(children: [
      DropdownButtonFormField(
        decoration: InputDecoration(
          errorStyle: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: Themes.red, fontSize: 15),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 25.0, horizontal: 20.0),
          fillColor: Themes.backgroundColor,
          filled: true,
          labelText: 'Choose your specialty',
          labelStyle: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: Themes.grey, fontSize: 20),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        value: provider.specialty,
        onSaved: (newValue) => provider.specialty = newValue!,
        onChanged: (value) {
          methodprovider.changSpecialty(value ?? '');
        },
        items: dropdownOptions.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Themes.grey, fontSize: 20),
            ),
          );
        }).toList(),
        validator: (value) {
          if (value == null || value == '') {
            return 'Please select an option';
          }
          return null;
        },
      ),
      Container(
        height: SizeConfig.screenHeight * .08,
        margin:
            EdgeInsets.symmetric(vertical: getProportionateScreenHeight(10)),
        child: TextFormField(
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: Themes.grey),
          key: const ValueKey('yearsofexp'),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Pleas enter a valid number';
            }
            return null;
          },
          onSaved: ((newValue) => methodprovider.changYearsOfExp(newValue!)),
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            errorStyle: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Themes.red, fontSize: 15),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 25.0, horizontal: 20.0),
            fillColor: Themes.backgroundColor,
            filled: true,
            labelText: 'Years of experiance',
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
      WorkingTime(),
      Container(
        height: SizeConfig.screenHeight * .2,
        margin:
            EdgeInsets.symmetric(vertical: getProportionateScreenHeight(10)),
        child: TextFormField(
          expands: true, // and this
          textAlignVertical:
              TextAlignVertical.top, // Align the cursor to the top

          maxLines: null, // allows any number of lines

          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: Themes.grey),
          key: const ValueKey('about'),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Pleas enter a description';
            }
            return null;
          },
          onSaved: ((newValue) => methodprovider.changAbout(newValue!)),
          keyboardType: TextInputType.multiline,
          decoration: InputDecoration(
            errorStyle: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Themes.red, fontSize: 15),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 25.0, horizontal: 20.0),
            fillColor: Themes.backgroundColor,
            filled: true,
            labelText: 'About you...',
            alignLabelWithHint: true, // Align the label with the hint text

            labelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Themes.grey,
                  fontSize: 20,
                ),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
    ]);
  }
}
