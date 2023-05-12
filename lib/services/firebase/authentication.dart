import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hospital/model/doctors.dart';
import 'package:hospital/model/pationtmodel.dart';
import 'package:hospital/model/workinghours.dart';
import 'package:hospital/screens/homescreen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hospital/screens/smsVirefecatiom.dart';
import 'package:hospital/services/providers/signproviders.dart';
import 'package:hospital/theme.dart';
import 'package:provider/provider.dart';

class Authentication {
  FirebaseAuth auth = FirebaseAuth.instance;
  String url = '';
  //bool smscurser = true;
// Function to verify phone number
  Future<void> verifyPhoneNumber(context, provider, methodprovider,
      {bool resend = false}) async {
    auth.verifyPhoneNumber(
      timeout: const Duration(seconds: 60),
      phoneNumber: '+2${provider.phone}',
      verificationCompleted: (PhoneAuthCredential credential) async {
        auth.signInWithCredential(credential).then((result) {
          Navigator.pushReplacementNamed(context, HomeScreen.routname);
        }).catchError((e) {});
      },
      verificationFailed: (FirebaseAuthException e) {
        //  callback(false);
        methodprovider.changeloading(false);

        if (e.code == 'invalid-phone-number') {
          toastmessage('Invalid phone number.', true);
        } else if (e.code == 'session-expired') {
          toastmessage('try again later.', true);
        } else if (e.code == 'code-expired') {
          toastmessage('Code expired try again later.', true);
        } else if (e.code == 'invalid-verification-code') {
          toastmessage('Invalid verification code.', true);
        } else {
          toastmessage('There was an arror try again later.', true);
        }
      },
      codeSent: (String verificationId, [int? forceResendingToken]) {
        methodprovider.changeVerificationId(verificationId);

        resend ? null : Navigator.pushNamed(context, SmsVerification.routname);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  void signin(
    context,
    String phone,
    String password,
  ) async {
    var methodprovider = Provider.of<signprividers>(context, listen: false);

    final doctorsdata =
        await FirebaseFirestore.instance.collection('doctors').doc(phone).get();
    final pationtssdata = await FirebaseFirestore.instance
        .collection('pationts')
        .doc(phone)
        .get();
//

    if (doctorsdata.exists || pationtssdata.exists) {
      var data = doctorsdata.exists ? doctorsdata : pationtssdata;
      if (data['password'] == password) {
        methodprovider.changeloading(false);

        if (doctorsdata.exists) {
          DoctorsModel doctorsModel = DoctorsModel(
              name: data['username'],
              phoneNumber: data['phone'],
              specialty: data['specialty'],
              about: data['about'],
              yersofexp: data['yersofexp'],
              imageurl: data['imageurl'],
              password: data['password'],
              workinghours: WorkingHoursModel(
                  starthour: data['statworkinghours'],
                  endhour: data['endworkinghours'],
                  days: data['workingdays']));
          methodprovider.changeisadoctor(true);
          methodprovider.getdoctorsdata(doctorsModel);
        } else {
          PationtModel pationtModel = PationtModel(
            name: data['username'],
            phone: data['phone'],
            imageurl: data['imageurl'],
            password: data['password'],
          );
          methodprovider.changeisadoctor(false);
          methodprovider.getPationtsData(pationtModel);
        }
        toastmessage('logged in successfully!', false);

        Navigator.pushReplacementNamed(context, HomeScreen.routname);
      } else {
        methodprovider.changeloading(false);

        toastmessage('Wrong password!', true);
      }
    } else {
      methodprovider.changeloading(false);

      toastmessage('Invalid phone number try sining up!', true);
    }
  }

  chek(context, provider, methodprovider) async {
    final doctorsdata = await FirebaseFirestore.instance
        .collection('doctor')
        .doc(provider.phone)
        .get();

    final pationtssdata = await FirebaseFirestore.instance
        .collection('pationts')
        .doc(provider.phone)
        .get();

    if (doctorsdata.exists || pationtssdata.exists) {
      //   callback(false);

      methodprovider.changeloading(false);

      toastmessage('already signed up try signing in!', true);
    } else {
      if (provider.imageurl == null) {
        methodprovider.changeloading(false);

        toastmessage('Please add your image.', true);
        return;
      } else {
        verifyPhoneNumber(context, provider, methodprovider);
      }
    }
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
