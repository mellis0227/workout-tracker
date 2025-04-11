import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';

class DashboardModel {
  final List<String> _quotes = [
    "Push yourself, because no one else is going to do it for you.",
    "The only bad workout is the one that didn’t happen.",
    "Don’t limit your challenges. Challenge your limits.",
    "You don’t have to be extreme, just consistent.",
    "Success starts with self-discipline.",
  ];

  List<String> get quotes => _quotes;


  Future<String> getUsersName(String userID) async {
    String fullName = "";
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      final currentUserCollection = await firestore.collection("user_data").doc(userID).get();

      Map<String, dynamic>? userData = currentUserCollection.data();
      fullName = "${userData?['first_name']} ${userData?['last_name']}";
      return fullName;
    } catch(e) {
      print("Error getting users name: $e");
    }
    return "";
  }
}
