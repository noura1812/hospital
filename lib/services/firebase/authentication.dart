import 'package:firebase_auth/firebase_auth.dart';
import 'package:hospital/model/doctors.dart';
import 'package:hospital/model/patient_model.dart';
import 'package:hospital/providers/home_tab_providers.dart';
import 'package:hospital/providers/sign_providers.dart';
import 'package:hospital/services/firebase/firebase_main_functions.dart';
import 'package:hospital/widgets/toast.dart';

class Authentication {
  static Future<void> verifyPhoneNumber(
      provider, SignProvider methodProvider, Function goHome) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    auth.verifyPhoneNumber(
      timeout: const Duration(seconds: 60),
      phoneNumber: '+2${provider.phone}',
      verificationCompleted: (PhoneAuthCredential credential) async {
        auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        methodProvider.changeLoading(false);

        if (e.code == 'invalid-phone-number') {
          ToastMessage.toastMessage('Invalid phone number.', true);
        } else if (e.code == 'session-expired') {
          ToastMessage.toastMessage('try again later.', true);
        } else if (e.code == 'code-expired') {
          ToastMessage.toastMessage('Code expired try again later.', true);
        } else if (e.code == 'invalid-verification-code') {
          ToastMessage.toastMessage('Invalid verification code.', true);
        } else {
          ToastMessage.toastMessage(
              'There was an error try again later.', true);
        }
      },
      codeSent: (String verificationId, [int? forceResendingToken]) {
        methodProvider.changeVerificationId(verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  void signIn(
      //get users data
      SignProvider methodProvider,
      SignProvider provider,
      HomeTabProviders homeTabProviderMethods,
      Function goHome) async {
    final doctorsData =
        await FirebaseMainFunctions.searchForADoctors(provider.phone);
    final patientsData =
        await FirebaseMainFunctions.searchForAPatient(provider.phone);

    if (doctorsData.docs.isNotEmpty || patientsData.docs.isNotEmpty) {
      methodProvider.changeLoading(false);

      if (doctorsData.docs.isNotEmpty) {
        DoctorsModel doctorsModel = doctorsData.docs[0].data();
        methodProvider.changeIsaDoctor(true);
        methodProvider.getDoctorsData(doctorsModel);
        homeTabProviderMethods.setIsDoctor(true);
        homeTabProviderMethods.setUserData(doctorsModel);
      } else {
        PatientModel patientModel = patientsData.docs[0].data();
        methodProvider.changeIsaDoctor(false);
        methodProvider.getPatientsData(patientModel);
        homeTabProviderMethods.setIsDoctor(false);

        homeTabProviderMethods.setUserData(patientModel);
      }

      ToastMessage.toastMessage('logged in successfully!', false);

      goHome();
    } else {
      methodProvider.changeLoading(false);

      ToastMessage.toastMessage('Invalid phone number!', true);
    }
  }

  static Future<bool> chick(
      SignProvider provider, SignProvider methodProvider) async {
    final doctorsData =
        await FirebaseMainFunctions.searchForADoctors(provider.phone);

    final patientsData =
        await FirebaseMainFunctions.searchForAPatient(provider.phone);

    if (provider.isLogin) {
      if (doctorsData.docs.isNotEmpty || patientsData.docs.isNotEmpty) {
        methodProvider.changeLoading(false);
        return true;
      } else {
        ToastMessage.toastMessage('Invalid Phone Number!', true);
        methodProvider.changeLoading(false);

        return false;
      }
    } else {
      if (doctorsData.docs.isNotEmpty || patientsData.docs.isNotEmpty) {
        methodProvider.changeLoading(false);

        ToastMessage.toastMessage('already signed up try signing in!', true);
        return false;
      } else {
        if (provider.imageFile == null) {
          methodProvider.changeLoading(false);

          ToastMessage.toastMessage('Please add your image.', true);
          return false;
        } else {
          return true;
        }
      }
    }
  }
}
