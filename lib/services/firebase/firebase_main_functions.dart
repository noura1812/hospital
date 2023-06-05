import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hospital/model/doctors.dart';
import 'package:hospital/model/pationtmodel.dart';

class FirebaseMainFunctions {
  static CollectionReference<DoctorsModel> getDoctorsCollection() {
    return FirebaseFirestore.instance
        .collection('doctors')
        .withConverter<DoctorsModel>(
      fromFirestore: (snapshot, options) {
        return DoctorsModel.fromjson(snapshot.data()!);
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

  static Future<QuerySnapshot<DoctorsModel>> getDoctorsBySpeciality(
      String speciality) {
    var collection = getDoctorsCollection();
    return collection.where('specialty', isEqualTo: speciality).get();
  }

  static Stream<QuerySnapshot<DoctorsModel>> getDoctorsByname(String name) {
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

  static Future<DocumentSnapshot<PationtModel>> getPationtsById(String id) {
    var collection = getPationtsCollection();
    return collection.doc(id).get();
  }

  static CollectionReference<PationtModel> getPationtsCollection() {
    return FirebaseFirestore.instance
        .collection('pationts')
        .withConverter<PationtModel>(
      fromFirestore: (snapshot, options) {
        return PationtModel.fromjson(snapshot.data()!);
      },
      toFirestore: (value, options) {
        return value.toJson();
      },
    );
  }

  static Future<void> addAPationt(PationtModel pationtModel, id) {
    var collection = getPationtsCollection();
    var docRef = collection.doc(id);
    pationtModel.id = id;
    return docRef.set(pationtModel);
  }

  static Stream<QuerySnapshot<PationtModel>> getAllPationts() {
    var collection = getPationtsCollection();
    return collection.snapshots();
  }

  static Future<QuerySnapshot<PationtModel>> searchForAPationt(phoneNumber) {
    var collection = getPationtsCollection();
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

  static Future<void> updatePationt(PationtModel pationtModel) {
    return getPationtsCollection().doc(pationtModel.id).update({
      'appointments': List<dynamic>.from(
          pationtModel.appointments.map((appointment) => appointment.toJson()))
    });
  }
////////////////////////////////////////

  static Future<void> cancelAppointment(PationtModel pationtModel,
      DoctorsModel doctorsModel, String appointmentid) {
    pationtModel.appointments
        .removeWhere((element) => element.id == appointmentid);
    doctorsModel.appointments
        .removeWhere((element) => element.id == appointmentid);
    updatePationt(pationtModel);
    return updateDoctors(doctorsModel);
  }
}
