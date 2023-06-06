import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hospital/model/doctors.dart';
import 'package:hospital/model/patient_model.dart';

class FirebaseMainFunctions {
  static CollectionReference<DoctorsModel> getDoctorsCollection() {
    return FirebaseFirestore.instance
        .collection('doctors')
        .withConverter<DoctorsModel>(
      fromFirestore: (snapshot, options) {
        return DoctorsModel.fromJson(snapshot.data()!);
      },
      toFirestore: (value, options) {
        return value.toJson();
      },
    );
  }

  static Future<void> addADoctor(DoctorsModel doctorsModel, id) {
    var collection = getDoctorsCollection();
    var docRef = collection.doc(id);
    doctorsModel.id = id;

    return docRef.set(doctorsModel);
  }

  static Stream<QuerySnapshot<DoctorsModel>> getAllDoctors() {
    var collection = getDoctorsCollection();
    return collection.snapshots();
  }

  static Future<QuerySnapshot<DoctorsModel>> getDoctorsBySpecialty(
      String specialty) {
    var collection = getDoctorsCollection();
    return collection.where('specialty', isEqualTo: specialty).get();
  }

  static Stream<QuerySnapshot<DoctorsModel>> getDoctorsByName(String name) {
    var collection = getDoctorsCollection();
    return collection.where('name', isEqualTo: name).snapshots();
  }

  static Future<DocumentSnapshot<DoctorsModel>> getDoctorsById(String id) {
    var collection = getDoctorsCollection();
    return collection.doc(id).get();
  }

  static Future<QuerySnapshot<DoctorsModel>> searchForADoctors(phoneNumber) {
    var collection = getDoctorsCollection();
    return collection.where('phoneNumber', isEqualTo: phoneNumber).get();
  }

  static Future<void> updateDoctors(DoctorsModel doctorsModel) {
    return getDoctorsCollection().doc(doctorsModel.id).update({
      'appointments': List<dynamic>.from(
          doctorsModel.appointments.map((appointment) => appointment.toJson()))
    });
  }
/////////////////////////////////////////////////////////////////////////////////////

  static Future<DocumentSnapshot<PatientModel>> getPatientsById(String id) {
    var collection = getPatientsCollection();
    return collection.doc(id).get();
  }

  static CollectionReference<PatientModel> getPatientsCollection() {
    return FirebaseFirestore.instance
        .collection('pationts')
        .withConverter<PatientModel>(
      fromFirestore: (snapshot, options) {
        return PatientModel.fromJson(snapshot.data()!);
      },
      toFirestore: (value, options) {
        return value.toJson();
      },
    );
  }

  static Future<void> addAPatient(PatientModel patientModel, id) {
    var collection = getPatientsCollection();
    var docRef = collection.doc(id);
    patientModel.id = id;
    return docRef.set(patientModel);
  }

  static Stream<QuerySnapshot<PatientModel>> getAllPatients() {
    var collection = getPatientsCollection();
    return collection.snapshots();
  }

  static Future<QuerySnapshot<PatientModel>> searchForAPatient(phoneNumber) {
    var collection = getPatientsCollection();
    return collection.where('phoneNumber', isEqualTo: phoneNumber).get();
  }

  static Future<String> addImage(phone, imageFile) {
    final ref = FirebaseStorage.instance
        .ref()
        .child('user_images')
        .child('+2$phone.jpg');
    ref.putFile(imageFile);
    return ref.getDownloadURL();
  }

  static Future<void> updatePatient(PatientModel patientModel) {
    return getPatientsCollection().doc(patientModel.id).update({
      'appointments': List<dynamic>.from(
          patientModel.appointments.map((appointment) => appointment.toJson()))
    });
  }
////////////////////////////////////////

  static Future<void> cancelAppointment(PatientModel patientModel,
      DoctorsModel doctorsModel, String appointmentId) {
    patientModel.appointments
        .removeWhere((element) => element.id == appointmentId);
    doctorsModel.appointments
        .removeWhere((element) => element.id == appointmentId);
    updatePatient(patientModel);
    return updateDoctors(doctorsModel);
  }
}
