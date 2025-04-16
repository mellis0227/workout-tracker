import 'package:cloud_firestore/cloud_firestore.dart';


class ScheduleModel {
  final DateTime? scheduledTime;
  final String? currentPlaylistName;

  const ScheduleModel({required this.currentPlaylistName, required this.scheduledTime});


}