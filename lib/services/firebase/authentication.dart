import 'package:firebase_auth/firebase_auth.dart';
import 'package:hospital/model/doctors.dart';
import 'package:hospital/model/pationtmodel.dart';
import 'package:hospital/providers/hometabProviders.dart';
import 'package:hospital/providers/signProviders.dart';
import 'package:hospital/services/firebase/firebase_main_functions.dart';
import 'package:hospital/widgets/toast.dart';

class Authentication {
  static Future<void> verifyPhoneNumber(
      provider, Signprividers methodprovider, Function goHome) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    auth.verifyPhoneNumber(
      timeout: const Duration(seconds: 60),
      phoneNumber: '+2${provider.phone}',
      verificationCompleted: (PhoneAuthCredential credential) async {
        auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        methodprovider.changeloading(false);

        if (e.code == 'invalid-phone-number') {
          ToastMessage.toastmessage('Invalid phone number.', true);
        } else if (e.code == 'session-expired') {
          ToastMessage.toastmessage('try again later.', true);
        } else if (e.code == 'code-expired') {
          ToastMessage.toastmessage('Code expired try again later.', true);
        } else if (e.code == 'invalid-verification-code') {
          ToastMessage.toastmessage('Invalid verification code.', true);
        } else {
          ToastMessage.toastmessage(
              'There was an arror try again later.', true);
        }
      },
      codeSent: (String verificationId, [int? forceResendingToken]) {
        methodprovider.changeVerificationId(verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  void signin(
      //get users data
      Signprividers methodprovider,
      Signprividers provider,
      HomeTabProviders homeTabProviderMethods,
      Function goHome) async {
    final doctorsdata =
        await FirebaseMainFunctions.searchForADoctors(provider.phone);
    final pationtssdata =
        await FirebaseMainFunctions.searchForAPationt(provider.phone);

    if (doctorsdata.docs.isNotEmpty || pationtssdata.docs.isNotEmpty) {
      methodprovider.changeloading(false);

      if (doctorsdata.docs.isNotEmpty) {
        DoctorsModel doctorsModel = doctorsdata.docs[0].data();
        methodprovider.changeisadoctor(true);
        methodprovider.getdoctorsdata(doctorsModel);
        homeTabProviderMethods.setIsdoctor(true);
        homeTabProviderMethods.setUserData(doctorsModel);
      } else {
        PationtModel pationtModel = pationtssdata.docs[0].data();
        methodprovider.changeisadoctor(false);
        methodprovider.getPationtsData(pationtModel);
        homeTabProviderMethods.setIsdoctor(false);

        homeTabProviderMethods.setUserData(pationtModel);
      }

      ToastMessage.toastmessage('logged in successfully!', false);

      goHome();
    } else {
      methodprovider.changeloading(false);

      ToastMessage.toastmessage('Invalid phone number!', true);
    }
  }

  static Future<bool> chek(Signprividers provider, methodprovider) async {
    final doctorsdata =
        await FirebaseMainFunctions.searchForADoctors(provider.phone);

    final pationtssdata =
        await FirebaseMainFunctions.searchForAPationt(provider.phone);

    if (provider.islogin) {
      if (doctorsdata.docs.isNotEmpty || pationtssdata.docs.isNotEmpty) {
        methodprovider.changeloading(false);
        return true;
      } else {
        ToastMessage.toastmessage('Invaled Phone Number!', true);
        methodprovider.changeloading(false);

        return false;
      }
    } else {
      if (doctorsdata.docs.isNotEmpty || pationtssdata.docs.isNotEmpty) {
        methodprovider.changeloading(false);

        ToastMessage.toastmessage('already signed up try signing in!', true);
        return false;
      } else {
        if (provider.imageFile == null) {
          methodprovider.changeloading(false);

          ToastMessage.toastmessage('Please add your image.', true);
          return false;
        } else {
          return true;
        }
      }
    }
  }
}
