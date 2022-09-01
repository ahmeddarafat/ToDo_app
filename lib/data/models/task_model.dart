
import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  final String id;
  final String title;
  final String note;
  final String date;
  final String startTime;
  final String endTime;
  final int reminder;
  final int colorIndex;

  TaskModel({
    required this.id,
    required this.title,
    required this.note,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.reminder,
    required this.colorIndex,
  });
 
 /// I use id arrgument to recieve doc.id of task to use it when deleting
  factory TaskModel.fromJson(Map<String, dynamic> json, String id) {
    return TaskModel(
        id: id,
        title: json["title"],
        note: json["note"],
        date: json["date"],
        startTime: json["startTime"],
        endTime: json["endTime"],
        reminder: json["reminder"],
        colorIndex: json["colorIndex"]);
  }

/// I use time to order tasks by time of server
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'note': note,
      'date': date,
      'startTime': startTime,
      'endTime': endTime,
      'reminder': reminder,
      'colorIndex': colorIndex,
      'time':FieldValue.serverTimestamp(),
    };
  }
}
