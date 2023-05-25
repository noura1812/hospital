import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:hospital/providers/hometabProviders.dart';
import 'package:hospital/screens/homescreen.dart';
import 'package:hospital/services/firebase/authentication.dart';
import 'package:hospital/providers/signproviders.dart';
import 'package:hospital/services/firebase/firebase_main_functions.dart';
import 'package:hospital/theme.dart';
import 'package:hospital/widgets/toast.dart';
import 'package:provider/provider.dart';
import 'dart:async';

class SmsVerification extends StatefulWidget {
  static const String routname = 'smsscreen';

  const SmsVerification({super.key});

  @override
  State<SmsVerification> createState() => _SmsVerificationState();
}

class _SmsVerificationState extends State<SmsVerification> {
  int _countdown = 70;

  bool _disabled = false;
  bool verefing = false;
  bool verefied = false;
  bool wrong = false;

  void _startTimer() {
    {
      Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_countdown > 0) {
          _countdown--;
        } else {
          _disabled = false;
          verefing = false;
          _countdown = 70;
          timer.cancel();
        }
        if (verefied) {
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
        HomeScreen.routname, (Route<dynamic> route) => false);
  }

  void sendAgainVerify() {
    if (!_disabled) {
      _disabled = true;
      _startTimer();
      // Resend verification code here
    }
  }

  @override
  void initState() {
    sendAgainVerify();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
//    sendAgainVerify();
    var provider = Provider.of<signprividers>(context);
    var methodprovider = Provider.of<signprividers>(context, listen: false);
    var homeTabMethods = Provider.of<HmeTabProviders>(context, listen: false);
    FirebaseAuth auth = FirebaseAuth.instance;
    verefied = provider.verified;
    String url = '';

    return Scaffold(
      backgroundColor: Themes.lighbackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
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
              onCompleted: (message) {
                verefing = true;
                setState(() {});
                provider.islogin
                    ? login(auth, provider, methodprovider, homeTabMethods,
                        message, url)
                    : addUser(auth, provider, methodprovider, homeTabMethods,
                        message, url);
              },
              onEditing: (bool value) {},
            ),
            const SizedBox(
              height: 5,
            ),
            verefing
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
            TextButton(
              onPressed: _disabled
                  ? null
                  : () {
                      sendAgainVerify();
                      Authentication.verifyPhoneNumber(
                          provider, methodprovider, goHome);
                    },
              child: Text(
                _disabled
                    ? 'Resend in $_countdown seconds'
                    : 'Send Verification Code',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Theme.of(context).primaryColor, fontSize: 18),
              ),
            )
          ],
        ),
      ),
    );
  }

  addUser(
      FirebaseAuth auth,
      signprividers provider,
      signprividers methodprovider,
      HmeTabProviders homeTabMethods,
      message,
      url) async {
    try {
      final userCredential = await auth.signInWithCredential(
          PhoneAuthProvider.credential(
              verificationId: provider.verificationId,
              smsCode: message.trim()));

      url = await FirebaseMainFunctions.addImage(
          provider.phone, provider.imageFile);
      if (provider.isadoctor) {
        methodprovider.setDoctorsUrl(url);

        await FirebaseMainFunctions.addADoctor(
                provider.doctorsdata, userCredential.user!.uid)
            .then((value) {
          ToastMessage.toastmessage('Signed up successfully!', false);

          methodprovider.changeloading(false);
          homeTabMethods.setUserData(provider.doctorsdata);
          methodprovider.changeverified(true);
          Navigator.of(context).pushNamedAndRemoveUntil(
              HomeScreen.routname, (Route<dynamic> route) => false);
        });
      } else {
        methodprovider.setPAtiontssUrl(url);
        methodprovider.setpatentsdata();

        await FirebaseMainFunctions.addAPationt(
                provider.pationtdata, userCredential.user!.uid)
            .then((value) {
          ToastMessage.toastmessage('Signed up successfully!', false);
          homeTabMethods.setUserData(provider.pationtdata);
          //     callback(false);
          methodprovider.changeloading(false);

          methodprovider.changeisadoctor(false);
          methodprovider.changeverified(true);
          Navigator.of(context).pushNamedAndRemoveUntil(
              HomeScreen.routname, (Route<dynamic> route) => false);
        });
      }
    } catch (e) {
      if (e == 'invalid-verification-code') {
        verefing = false;
        wrong = true;
        setState(() {});
      }
    }
  }

  login(FirebaseAuth auth, provider, methodprovider, homeTabMethods, message,
      url) async {
    try {
      final userCredential = await auth.signInWithCredential(
          PhoneAuthProvider.credential(
              verificationId: provider.verificationId,
              smsCode: message.trim()));

      methodprovider.changeloading(false);
      methodprovider.changeverified(true);

      Authentication().signin(methodprovider, provider, homeTabMethods, goHome);
    } catch (e) {
      if (e == 'invalid-verification-code') {
        verefing = false;
        wrong = true;
        setState(() {});
      }
    }
  }
}
