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

  Future<String> getUsersFullName(String userID) async {
    String fullName = "";
    try {

      final currentUserCollection =
      await firestore.collection("user_data").doc(userID).get();

      Map<String, dynamic>? userData = currentUserCollection.data();
      fullName = "${userData?['first_name']}";
      return fullName;
    } catch (e) {
      print("Error getting users name: $e");
    }
    return "";
  }
}