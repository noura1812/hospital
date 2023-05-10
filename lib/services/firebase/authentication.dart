import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:hospital/model/doctors.dart';
import 'package:hospital/model/pationtmodel.dart';
import 'package:hospital/model/workinghours.dart';
import 'package:hospital/screens/homescreen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hospital/services/providers/signproviders.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hospital/theme.dart';
import 'package:provider/provider.dart';

class Authentication {
  FirebaseAuth auth = FirebaseAuth.instance;
  String url = '';
  //bool smscurser = true;
// Function to verify phone number
  Future<void> verifyPhoneNumber(String phoneNumber, context, pationtdata,
      imagefile, provider, methodprovider) async {
    auth.verifyPhoneNumber(
      timeout: const Duration(seconds: 120),
      phoneNumber: phoneNumber,
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
        String smsCode = '';
        //show dialog to take input from the user
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
                    title: Text(
                      "Enter SMS Code",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    content: SizedBox(
                      width: 500,
                      height: 50,
                      child: VerificationCode(
                        itemSize: 40,
                        textStyle: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(color: Themes.grey, fontSize: 20),
                        keyboardType: TextInputType.number,
                        length: 6,
                        onCompleted: (message) {
                          smsCode = message.trim();
                          auth
                              .signInWithCredential(
                                  PhoneAuthProvider.credential(
                                      verificationId: verificationId,
                                      smsCode: smsCode))
                              .then((value) async {
                            Provider.of<signprividers>(context, listen: false)
                                .changesmscurser(false);
                            final ref = FirebaseStorage.instance
                                .ref()
                                .child('user_images')
                                .child('$phoneNumber.jpg');
                            await ref.putFile(imagefile!);
                            url = await ref.getDownloadURL();
                          }).then((v) async {
                            if (provider.isadoctor) {
                              await FirebaseFirestore.instance
                                  .collection('doctors')
                                  .doc(phoneNumber.substring(2))
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

                                Navigator.pushReplacementNamed(
                                    context, HomeScreen.routname);
                              });
                            } else {
                              await FirebaseFirestore.instance
                                  .collection('pationts')
                                  .doc(phoneNumber.substring(2))
                                  .set({
                                'username': pationtdata.name,
                                'password': pationtdata.password,
                                'phone': pationtdata.phone,
                                'imageurl': url
                              }).then((value) {
                                toastmessage('Signed up successfully!', false);

                                //     callback(false);
                                methodprovider.changeloading(false);

                                Navigator.pushReplacementNamed(
                                    context, HomeScreen.routname);
                              });
                            }
                          }).catchError((e) {});
                        },
                        autofocus: true,
                        onEditing: (bool value) {},
                      ),
                    ),
                    actions: [
                      TextButton(
                          onPressed:
                              Provider.of<signprividers>(context).smscurser
                                  ? () {
                                      //      callback(false);
                                      methodprovider.changeloading(false);

                                      Navigator.pop(context);
                                    }
                                  : null,
                          child: !Provider.of<signprividers>(context).smscurser
                              ? const SizedBox(
                                  height: 20.0,
                                  width: 20.0,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3.5,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  'Cancel',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                          color: Themes.red, fontSize: 20),
                                ))
                    ]));
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        provider.smscurser
            ? toastmessage('Sms time out try again later.', true)
            : null;
      },
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
//pationts
    if (doctorsdata.exists || pationtssdata.exists) {
      var data = doctorsdata.exists ? doctorsdata : pationtssdata;
      if (data['password'] == password) {
        //callback(false);
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
        //return PationtModel(
        //  name: data['username'], phone: phone, password: password);
      } else {
        //callback(false);
        methodprovider.changeloading(false);

        toastmessage('Wrong password!', true);
      }
    } else {
      // callback(false);
      methodprovider.changeloading(false);

      toastmessage('Invalid phone number try sining up!', true);
    }
  }

  chek(String phoneNumber, context, pationtdata, imagefile, provider,
      methodprovider) async {
    final doctorsdata = await FirebaseFirestore.instance
        .collection('doctor')
        .doc(pationtdata.phone)
        .get();

    final pationtssdata = await FirebaseFirestore.instance
        .collection('pationts')
        .doc(pationtdata.phone)
        .get();

    if (doctorsdata.exists || pationtssdata.exists) {
      //   callback(false);

      methodprovider.changeloading(false);

      toastmessage('already signed up try signing in!', true);
    } else {
      if (imagefile == null) {
        methodprovider.changeloading(false);

        toastmessage('Please add your image.', true);
        return;
      } else {
        verifyPhoneNumber(phoneNumber, context, pationtdata, imagefile,
            provider, methodprovider);
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
