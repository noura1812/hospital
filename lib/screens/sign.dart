import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hospital/providers/sign_providers.dart';
import 'package:hospital/screens/home_screen.dart';
import 'package:hospital/screens/sms_verification_screen.dart';
import 'package:hospital/services/size_config.dart';
import 'package:hospital/theme.dart';
import 'package:hospital/services/firebase/authentication.dart';
import 'package:hospital/widgets/enter_doctors_data.dart';
import 'package:hospital/widgets/toast.dart';
import 'package:hospital/widgets/user_image_picker.dart';
import 'package:provider/provider.dart';

class Sign extends StatefulWidget {
  static const String routName = 'sign';

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
  void goHome() {
    Navigator.pushReplacementNamed(context, HomeScreen.routName);
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<SignProvider>(context);
    var methodProvider = Provider.of<SignProvider>(context, listen: false);

    SizeConfig().init(context);

    return Scaffold(
      backgroundColor: Themes.lightBackgroundColor,
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
                          provider.isLogin ? 'Sign in' : 'Sign up',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      if (!provider.isLogin)
                        UserImagePicker(methodProvider.pickedImage),
                      if (!provider.isLogin)
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
                                methodProvider.changName(newValue!)),
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
                              methodProvider.changPhone(newValue!)),
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
                      if (!provider.isLogin)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            radioButton('Patient', false),
                            radioButton('Doctor', true),
                          ],
                        ),
                      if (provider.isaDoctor && !provider.isLogin)
                        EnterDocsData(),
                    ]),
                  ),
                  Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: SizeConfig.screenHeight * .08,
                        margin: const EdgeInsets.only(top: 20),
                        child: ElevatedButton(
                          onPressed: provider.loading
                              ? null
                              : () {
                                  methodProvider.changeLoading(true);
                                  bool validate = _submit();
                                  if (validate == true) {
                                    methodProvider.setDoctorsData();
                                    if (provider.days.isEmpty &&
                                        !provider.isLogin &&
                                        provider.isaDoctor) {
                                      ToastMessage.toastMessage(
                                          'Select your working days!', true);
                                      methodProvider.changeLoading(false);
                                      return;
                                    }
                                    if (!provider.isLogin) {
                                      Authentication.chick(
                                              provider, methodProvider)
                                          .then((value) {
                                        if (value) {
                                          Authentication.verifyPhoneNumber(
                                                  provider,
                                                  methodProvider,
                                                  goHome)
                                              .then((value) {
                                            methodProvider.changeLoading(false);

                                            return Navigator.pushNamed(context,
                                                SmsVerification.routName);
                                          });
                                        }
                                      });
                                    } else {
                                      Authentication.chick(
                                              provider, methodProvider)
                                          .then((value) {
                                        if (value) {
                                          methodProvider.changeLoading(false);

                                          Authentication.verifyPhoneNumber(
                                              provider, methodProvider, goHome);
                                          Navigator.pushNamed(context,
                                              SmsVerification.routName);
                                        }
                                      });
                                    }
                                  } else {
                                    methodProvider.changeLoading(false);
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              backgroundColor: Theme.of(context).primaryColor),
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
                                  provider.isLogin ? 'Sign in' : "Sign up",
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
                            provider.isLogin
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
                              methodProvider.changeIsLogin(!provider.isLogin);
                            },
                            child: Text(
                              provider.isLogin ? " Sign up " : "Sign in",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                      color: Themes.textColor,
                                      fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            )),
      ),
    );
  }

  bool _submit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      return true;
    } else {
      return false;
    }
  }

  radioButton(String title, bool val) {
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
              Provider.of<SignProvider>(context, listen: false).isaDoctor,
          onChanged: (value) {
            Provider.of<SignProvider>(context, listen: false)
                .changeIsaDoctor(value!);
          },
        ),
      ),
    );
  }
}
