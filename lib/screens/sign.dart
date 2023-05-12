import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hospital/model/pationtmodel.dart';
import 'package:hospital/services/providers/signproviders.dart';
import 'package:hospital/services/size_config.dart';
import 'package:hospital/theme.dart';
import 'package:hospital/services/firebase/authentication.dart';
import 'package:hospital/widgets/enterdoctorsdata.dart';
import 'package:hospital/widgets/user_imagepicker.dart';
import 'package:provider/provider.dart';

class Sign extends StatefulWidget {
  static const String routname = 'sign';

  const Sign({super.key});

  @override
  State<Sign> createState() => _SignState();
}

class _SignState extends State<Sign> {
  final _formKey = GlobalKey<FormState>();
  List<String> dropdownOptions = [
    'Eye',
    'Nose',
    'Heart',
    'Ear',
    'Skin',
    'Teeth'
  ];

  File? imageFile;
  void pickedImage(File pickedImage) {
    imageFile = pickedImage;
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
                      if (!provider.islogin)
                        UserImagePicker(methodprovider.pickedImage),
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
                            onSaved: ((newValue) =>
                                methodprovider.changname(newValue!)),
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
                          onSaved: ((newValue) =>
                              methodprovider.changphone(newValue!)),
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
                          onSaved: ((newValue) =>
                              methodprovider.changpassword(newValue!)),
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
                            radiobutton('Patient', false),
                            radiobutton('Doctor', true),
                          ],
                        ),
                      if (provider.isadoctor && !provider.islogin)
                        EnterDocsData(),
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
                                      methodprovider.setdoctorsdata();
                                      if (provider.days.isEmpty &&
                                          !provider.islogin &&
                                          provider.isadoctor) {
                                        Authentication().toastmessage(
                                            'Select your working days!', true);
                                        methodprovider.changeloading(false);
                                        return;
                                      }

                                      !provider.islogin
                                          ? Authentication().chek(
                                              context, provider, methodprovider)
                                          : Authentication().signin(
                                              context,
                                              provider.phone,
                                              provider.password);
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
