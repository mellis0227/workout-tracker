import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileData {
  String userID;
  String height;
  String weight;
  late DateTime date;

  ProfileData({
    required this.userID,
    required this.height,
    required this.weight,
    required this.date,
  });

  Map<String,dynamic> toMap() { return {
    'height': height,
    'weight': weight,
    'date': date,
  };
  }
}

class ProfileModel {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  ProfileModel();
  List<ProfileData> profilePage = [];

  Future<void> saveProfileData({
    required String userID,
    required String height,
    required String weight,
    required DateTime date,
}) async {
    await firestore
        .collection('user_data')
        .doc(userID)
        .collection('profile data')
        .add({
      'height': height,
      'weight': weight,
      'date': date,
    });
  }
}