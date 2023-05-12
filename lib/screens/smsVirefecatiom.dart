import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hospital/model/doctors.dart';
import 'package:hospital/model/pationtmodel.dart';
import 'package:hospital/screens/homescreen.dart';
import 'package:hospital/services/firebase/authentication.dart';
import 'package:hospital/services/providers/signproviders.dart';
import 'package:hospital/theme.dart';
import 'package:provider/provider.dart';
import 'dart:async';

class SmsVerification extends StatefulWidget {
  static const String routname = 'smsscreen';

  @override
  State<SmsVerification> createState() => _SmsVerificationState();
}

class _SmsVerificationState extends State<SmsVerification> {
  int _countdown = 70;

  bool _disabled = false;
  bool verefing = false;
  bool wrong = false;

  void _startTimer() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdown > 0) {
          _countdown--;
        } else {
          _disabled = false;
          verefing = false;
          _countdown = 70;
          timer.cancel();
        }
      });
    });
  }

  void sendAgainVerify() {
    if (!_disabled) {
      _disabled = true;
      _startTimer();
      // Resend verification code here
    }
  }

  @override
  Widget build(BuildContext context) {
    print(_disabled);
//    sendAgainVerify();
    var provider = Provider.of<signprividers>(context);
    var methodprovider = Provider.of<signprividers>(context, listen: false);
    FirebaseAuth auth = FirebaseAuth.instance;
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
              autofocus: false,
              underlineUnfocusedColor: Colors.transparent,
              fillColor: Themes.backgroundColor,
              textStyle: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: Themes.grey, fontSize: 20),
              keyboardType: TextInputType.number,
              length: 6,
              onCompleted: (message) {
                sendAgainVerify();
                verefing = true;
                setState(() {});
                try {
                  auth
                      .signInWithCredential(PhoneAuthProvider.credential(
                          verificationId: provider.verificationId,
                          smsCode: message.trim()))
                      .then((value) async {
                    Provider.of<signprividers>(context, listen: false)
                        .changesmscurser(false);
                    final ref = FirebaseStorage.instance
                        .ref()
                        .child('user_images')
                        .child('+2${provider.phone}.jpg');
                    await ref.putFile(provider.imageFile!);
                    url = await ref.getDownloadURL();
                  }).then((v) async {
                    if (provider.isadoctor) {
                      await FirebaseFirestore.instance
                          .collection('doctors')
                          .doc(provider.phone)
                          .set({
                        'username': provider.doctorsdata.name,
                        'password': provider.doctorsdata.password,
                        'phone': provider.doctorsdata.phoneNumber,
                        'imageurl': url,
                        'specialty': provider.doctorsdata.specialty,
                        'about': provider.doctorsdata.about,
                        'yersofexp': provider.doctorsdata.yersofexp,
                        'statworkinghours':
                            provider.doctorsdata.workinghours.starthour,
                        'endworkinghours':
                            provider.doctorsdata.workinghours.endhour,
                        'workingdays': FieldValue.arrayUnion(
                            provider.doctorsdata.workinghours.days)
                      }).then((value) {
                        toastmessage('Signed up successfully!', false);

                        //     callback(false);
                        methodprovider.changeloading(false);
                        DoctorsModel doctorsModel = DoctorsModel(
                            name: provider.doctorsdata.name,
                            phoneNumber: provider.doctorsdata.phoneNumber,
                            specialty: provider.doctorsdata.specialty,
                            about: provider.doctorsdata.about,
                            yersofexp: provider.doctorsdata.yersofexp,
                            imageurl: url,
                            password: provider.doctorsdata.password,
                            workinghours: provider.doctorsdata.workinghours);
                        methodprovider.getdoctorsdata(doctorsModel);
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            HomeScreen.routname,
                            (Route<dynamic> route) => false);
                      });
                    } else {
                      await FirebaseFirestore.instance
                          .collection('pationts')
                          .doc(provider.phone)
                          .set({
                        'username': provider.name,
                        'password': provider.password,
                        'phone': provider.phone,
                        'imageurl': url
                      }).then((value) {
                        toastmessage('Signed up successfully!', false);

                        //     callback(false);
                        methodprovider.changeloading(false);

                        PationtModel pationtModel = PationtModel(
                          name: provider.name,
                          phone: provider.phone,
                          imageurl: url,
                          password: provider.password,
                        );
                        methodprovider.changeisadoctor(false);
                        methodprovider.getPationtsData(pationtModel);
                        Navigator.pushReplacementNamed(
                            context, HomeScreen.routname);
                      });
                    }
                  }).catchError((e) {});
                } catch (e) {
                  verefing = true;
                  wrong = true;
                  setState(() {});
                }
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
                      Authentication().verifyPhoneNumber(
                          context, provider, methodprovider,
                          resend: true);
                    },
              child: Text(
                _disabled
                    ? 'Resend in $_countdown seconds'
                    : 'Rend Verification Code',
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

  toastmessage(String message, bool type) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: type == true ? Themes.red : Themes.textcolor,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
