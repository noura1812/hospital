import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:hospital/providers/home_tab_providers.dart';
import 'package:hospital/screens/home_screen.dart';
import 'package:hospital/services/firebase/authentication.dart';
import 'package:hospital/providers/sign_providers.dart';
import 'package:hospital/services/firebase/firebase_main_functions.dart';
import 'package:hospital/services/size_config.dart';
import 'package:hospital/theme.dart';
import 'package:hospital/widgets/toast.dart';
import 'package:provider/provider.dart';
import 'dart:async';

class SmsVerification extends StatefulWidget {
  static const String routName = 'smsScreen';

  const SmsVerification({super.key});

  @override
  State<SmsVerification> createState() => _SmsVerificationState();
}

class _SmsVerificationState extends State<SmsVerification> {
  int _countdown = 70;
  String message = '';
  bool _disabled = false;
  bool verifying = false;
  bool verified = false;
  bool wrong = false;
  FirebaseAuth auth = FirebaseAuth.instance;

  late SignProvider gProvider;
  late SignProvider gMethod;
  late HomeTabProviders hProvider;
  late SignProvider sProvider;
  void _startTimer() {
    {
      Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_countdown > 0) {
          _countdown--;
        } else {
          if (verifying) {
            ToastMessage.toastMessage('Time out', true);
            sProvider.changeLoading(false);
          }
          _disabled = false;
          verifying = false;
          _countdown = 70;
          timer.cancel();
        }
        if (verified) {
          timer.cancel();
          return;
        } else {
          setState(() {});
        }
      });
    }
  }

  void goHome() {
    Navigator.of(context).pushNamedAndRemoveUntil(
        HomeScreen.routName, (Route<dynamic> route) => false);
  }

  void sendAgainVerify() {
    Authentication.verifyPhoneNumber(gProvider, gMethod, goHome);
    if (!_disabled) {
      _disabled = true;
      _startTimer();
      // Resend verification code here
    }
  }

  @override
  void initState() {
    _disabled = true;

    _startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

//    sendAgainVerify();
    var provider = Provider.of<SignProvider>(context);
    gProvider = provider;
    var methodProvider = Provider.of<SignProvider>(context, listen: false);
    gMethod = methodProvider;
    sProvider = methodProvider;
    var homeTabMethods = Provider.of<HomeTabProviders>(context, listen: false);
    hProvider = homeTabMethods;
    verified = provider.verified;

    return Scaffold(
      backgroundColor: Themes.lightBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                Text(
                  'We sent you a code to',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'your mobile number',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  '+2${provider.phone}',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 80,
                ),
                Text(
                  'Enter the code',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(
                  height: 40,
                ),
                VerificationCode(
                  clearAll: Container(
                    color: Colors.red,
                  ),
                  autofocus: true,
                  underlineUnfocusedColor: Colors.transparent,
                  fillColor: Themes.backgroundColor,
                  textStyle: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: Themes.grey, fontSize: 20),
                  keyboardType: TextInputType.number,
                  length: 6,
                  onCompleted: (m) {
                    message = m;
                    setState(() {});
                  },
                  onEditing: (bool value) {},
                ),
                const SizedBox(
                  height: 5,
                ),
                verifying
                    ? Text(
                        'verifying...',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(fontSize: 16),
                      )
                    : Container(),
                wrong
                    ? Text(
                        'Wrong code',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(fontSize: 16, color: Themes.red),
                      )
                    : Container(),
                const SizedBox(
                  height: 80,
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: _disabled
                      ? null
                      : () {
                          sendAgainVerify();
                          Authentication.verifyPhoneNumber(
                              provider, methodProvider, goHome);
                        },
                  child: Text(
                    _disabled
                        ? 'Resend in $_countdown seconds'
                        : 'Send Verification Code',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: _disabled
                            ? Themes.textColor
                            : Theme.of(context).primaryColor,
                        fontSize: 18),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: SizeConfig.screenHeight * .08,
                  margin: const EdgeInsets.only(
                      top: 20, bottom: 30, right: 30, left: 30),
                  child: ElevatedButton(
                    onPressed:
                        provider.loading || message.length < 6 || !_disabled
                            ? null
                            : () {
                                methodProvider.changeLoading(true);

                                verifying = true;
                                wrong = false;
                                setState(() {});
                                provider.isLogin ? login() : addUser();
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
                            'verify',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                          ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  addUser() async {
    try {
      final userCredential = await auth.signInWithCredential(
          PhoneAuthProvider.credential(
              verificationId: gProvider.verificationId,
              smsCode: message.trim()));

      String url = await FirebaseMainFunctions.addImage(
          gProvider.phone, gProvider.imageFile);
      if (gProvider.isaDoctor) {
        gMethod.setDoctorsUrl(url);

        await FirebaseMainFunctions.addADoctor(
                gProvider.doctorsData, userCredential.user!.uid)
            .then((value) {
          ToastMessage.toastMessage('Signed up successfully!', false);

          gMethod.changeLoading(false);
          hProvider.setUserData(gProvider.doctorsData);
          gMethod.changeVerified(true);
          gMethod.changeIsLogin(true);
          Navigator.of(context).pushNamedAndRemoveUntil(
              HomeScreen.routName, (Route<dynamic> route) => false);
        });
      } else {
        gMethod.setPatientsUrl(url);
        gMethod.setPatientsData();

        await FirebaseMainFunctions.addAPatient(
                gProvider.patientData, userCredential.user!.uid)
            .then((value) {
          ToastMessage.toastMessage('Signed up successfully!', false);
          hProvider.setUserData(gProvider.patientData);
          //     callback(false);
          gMethod.changeLoading(false);

          gMethod.changeIsaDoctor(false);
          gMethod.changeVerified(true);
          Navigator.of(context).pushNamedAndRemoveUntil(
              HomeScreen.routName, (Route<dynamic> route) => false);
        });
      }
    } on FirebaseAuthException catch (e) {
      if (e.message ==
          'The verification code from SMS/TOTP is invalid. Please check and enter the correct verification code again.') {
        gMethod.changeLoading(false);
        verifying = false;
        wrong = true;
        setState(() {});
      } else {
        gMethod.changeLoading(false);
        ToastMessage.toastMessage('Try again later', true);
        verifying = false;
        setState(() {});
      }
    }
  }

  login() async {
    try {
      await auth.signInWithCredential(PhoneAuthProvider.credential(
          verificationId: gProvider.verificationId, smsCode: message.trim()));

      gMethod.changeLoading(false);
      gMethod.changeVerified(true);

      Authentication().signIn(gMethod, gProvider, hProvider, goHome);
    } on FirebaseAuthException catch (e) {
      if (e.message ==
          'The verification code from SMS/TOTP is invalid. Please check and enter the correct verification code again.') {
        gMethod.changeLoading(false);
        verifying = false;
        wrong = true;
        setState(() {});
      } else {
        gMethod.changeLoading(false);
        ToastMessage.toastMessage('Try again later', true);
        verifying = false;
        setState(() {});
      }
    }
  }
}
