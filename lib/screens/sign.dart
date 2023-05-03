import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hospital/model/pationtmodel.dart';
import 'package:hospital/services/providers/signproviders.dart';
import 'package:hospital/services/size_config.dart';
import 'package:hospital/theme.dart';
import 'package:hospital/services/firebase/authentication.dart';
import 'package:hospital/widgets/user_imagepicker.dart';
import 'package:provider/provider.dart';

class Sign extends StatefulWidget {
  static const String routname = 'sign';

  const Sign({super.key});

  @override
  State<Sign> createState() => _SignState();
}

class _SignState extends State<Sign> {
  String _phone = '';

  String _password = '';

  String _name = '';
  String startpm = 'PM';
  String endpm = 'PM';
  String _about = '';
  String _yersofexp = '';
  String _specialty = 'Eye';

  final _formKey = GlobalKey<FormState>();
  List<String> dropdownOptions = [
    'Eye',
    'Nose',
    'Heart',
    'Ear',
    'Skin',
    'Teeth'
  ];

  File? _ImageFile;
  void pickedImage(File pickedImage) {
    _ImageFile = pickedImage;
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<signprividers>(context);
    var methodprovider = Provider.of<signprividers>(context, listen: false);

    SizeConfig().init(context);

    return Scaffold(
      backgroundColor: Themes.lighbackgroundColor,
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.only(
                right: getProportionateScreenWidth(30),
                left: getProportionateScreenWidth(30)),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(
                    height: SizeConfig.screenHeight * .8,
                    child: ListView(children: [
                      SizedBox(
                        height: SizeConfig.screenHeight * .2,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: getProportionateScreenHeight(50)),
                        child: Text(
                          provider.islogin ? 'Sign in' : 'Sign up',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      if (!provider.islogin) UserImagePicker(pickedImage),
                      if (!provider.islogin)
                        Container(
                          height: SizeConfig.screenHeight * .08,
                          margin: EdgeInsets.only(
                              top: getProportionateScreenHeight(30),
                              bottom: getProportionateScreenHeight(10)),
                          child: TextFormField(
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: Themes.grey),
                            key: const ValueKey('name'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Pleas enter a valid Name';
                              }
                              return null;
                            },
                            onSaved: ((newValue) => _name = newValue!),
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
                              labelText: 'Full name',
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
                      Container(
                        height: SizeConfig.screenHeight * .08,
                        margin: EdgeInsets.symmetric(
                            vertical: getProportionateScreenHeight(10)),
                        child: TextFormField(
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Themes.grey),
                          key: const ValueKey('Phone'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Pleas enter a valid phone number';
                            }
                            return null;
                          },
                          onSaved: ((newValue) => _phone = newValue!),
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            errorStyle: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: Themes.red, fontSize: 15),
                            prefixText: '+20 ',
                            prefixStyle: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: Themes.grey, fontSize: 20),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 25.0, horizontal: 20.0),
                            fillColor: Themes.backgroundColor,
                            filled: true,
                            labelText: 'Enter Phone',
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
                      Container(
                        height: SizeConfig.screenHeight * .08,
                        margin: EdgeInsets.symmetric(
                            vertical: getProportionateScreenHeight(10)),
                        child: TextFormField(
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Themes.grey),
                          key: const ValueKey('password'),
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.length < 7) {
                              return 'Password must be at leas 7 characters';
                            }
                            return null;
                          },
                          onSaved: ((newValue) => _password = newValue!),
                          obscureText: true,
                          decoration: InputDecoration(
                            errorStyle: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: Themes.red, fontSize: 15),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 25.0, horizontal: 20.0),
                            fillColor: Themes.backgroundColor,
                            filled: true,
                            labelText: 'Password',
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
                      if (!provider.islogin)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            radiobutton('Pationt', false),
                            radiobutton('Doctor', true),
                          ],
                        ),
                      if (provider.isadoctor)
                        DropdownButtonFormField(
                          decoration: InputDecoration(
                            errorStyle: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: Themes.red, fontSize: 15),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 25.0, horizontal: 20.0),
                            fillColor: Themes.backgroundColor,
                            filled: true,
                            labelText: 'Chooe your specialty',
                            labelStyle: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: Themes.grey, fontSize: 20),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          value: _specialty,
                          onSaved: (newValue) => _specialty = newValue!,
                          onChanged: (value) {
                            methodprovider.changspeciality(value ?? '');
                          },
                          items: dropdownOptions
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                        color: Themes.grey, fontSize: 20),
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
                      if (provider.isadoctor)
                        Container(
                          height: SizeConfig.screenHeight * .08,
                          margin: EdgeInsets.symmetric(
                              vertical: getProportionateScreenHeight(10)),
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
                            onSaved: ((newValue) => _yersofexp = newValue!),
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              errorStyle: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: Themes.red, fontSize: 15),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 25.0, horizontal: 20.0),
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
                      if (provider.isadoctor)
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
                                      ?.copyWith(color: Themes.grey),
                                  key: const ValueKey('start'),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Pleas enter a valid phone number';
                                    }
                                    return null;
                                  },
                                  onSaved: ((newValue) => _phone = newValue!),
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                    suffixIcon: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          startpm,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                  color: Themes.grey,
                                                  fontSize: 14),
                                        ),
                                        IconButton(
                                            icon: Icon(
                                              Icons.arrow_drop_down,
                                              color: Themes.grey,
                                            ),
                                            onPressed: null),
                                      ],
                                    ),
                                    errorStyle: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                            color: Themes.red, fontSize: 15),
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 25.0, horizontal: 20.0),
                                    fillColor: Themes.backgroundColor,
                                    filled: true,
                                    labelText: 'Start',
                                    labelStyle: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                            color: Themes.grey, fontSize: 20),
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
                                  onSaved: ((newValue) => _phone = newValue!),
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                    suffixIcon: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          endpm,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                  color: Themes.grey,
                                                  fontSize: 14),
                                        ),
                                        IconButton(
                                            icon: Icon(
                                              Icons.arrow_drop_down,
                                              color: Themes.grey,
                                            ),
                                            onPressed: null),
                                      ],
                                    ),
                                    errorStyle: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                            color: Themes.red, fontSize: 15),
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 25.0, horizontal: 20.0),
                                    fillColor: Themes.backgroundColor,
                                    filled: true,
                                    labelText: 'End',
                                    labelStyle: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                            color: Themes.grey, fontSize: 20),
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
                      if (provider.isadoctor)
                        Container(
                          height: SizeConfig.screenHeight * .2,
                          margin: EdgeInsets.symmetric(
                              vertical: getProportionateScreenHeight(10)),
                          child: TextFormField(
                            expands: true, // and this
                            textAlignVertical: TextAlignVertical
                                .top, // Align the cursor to the top

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
                            onSaved: ((newValue) => _about = newValue!),
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(
                              errorStyle: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: Themes.red, fontSize: 15),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 25.0, horizontal: 20.0),
                              fillColor: Themes.backgroundColor,
                              filled: true,
                              labelText: 'About you...',
                              alignLabelWithHint:
                                  true, // Align the label with the hint text

                              labelStyle: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
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
                    ]),
                  ),
                  Container(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          height: SizeConfig.screenHeight * .08,
                          margin: const EdgeInsets.only(top: 20),
                          child: ElevatedButton(
                            onPressed: provider.loading
                                ? null
                                : () {
                                    //  loadding(true);
                                    methodprovider.changeloading(true);
                                    bool validate = _subnmit();
                                    if (validate == true) {
                                      !provider.islogin
                                          ? Authentication().chek(
                                              '+20$_phone',
                                              context,
                                              PationtModel(
                                                  name: _name,
                                                  phone: '0$_phone',
                                                  password: _password,
                                                  imageurl: ''),
                                              _ImageFile)
                                          : Authentication().signin(
                                              context, '0$_phone', _password);
                                    } else {
                                      // loadding(false);
                                      methodprovider.changeloading(false);
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                backgroundColor:
                                    Theme.of(context).primaryColor),
                            child: provider.loading
                                ? const SizedBox(
                                    height: 20.0,
                                    width: 20.0,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 3.5,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    provider.islogin ? 'Sign in' : "Sign up",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500),
                                  ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              provider.islogin
                                  ? "Don't have an account?"
                                  : "Have an account?",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                      color: Themes.grey,
                                      fontWeight: FontWeight.w500),
                            ),
                            InkWell(
                              onTap: () {
                                methodprovider.changeislogin(!provider.islogin);
                              },
                              child: Text(
                                provider.islogin ? " Sign up " : "Sign in",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                        color: Themes.textcolor,
                                        fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )),
      ),
    );
  }

  void signOut() async {
    //await FirebaseAuth.instance.signOut();

    print(FirebaseAuth.instance.currentUser);
    // Navigate back to the login or home screen
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

  radiobutton(String title, bool val) {
    return Expanded(
      child: ListTile(
        contentPadding: const EdgeInsets.all(0),
        title: Text(
          title,
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: Themes.grey, fontSize: 20),
        ),
        horizontalTitleGap: 0,
        leading: Radio(
          fillColor: MaterialStateProperty.all<Color>(Themes.lightblue),
          value: val,
          groupValue:
              Provider.of<signprividers>(context, listen: false).isadoctor,
          onChanged: (value) {
            Provider.of<signprividers>(context, listen: false)
                .changeisadoctor(value!);
          },
        ),
      ),
    );
  }
}
