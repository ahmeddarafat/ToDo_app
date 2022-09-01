import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_todo_app/data/models/task_model.dart';

class FirestoreCloud {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addTask({required TaskModel task, required User? user}) async {
    if (user != null) {
      try {
        var _taskCollection =
            _firestore.collection('users').doc(user.uid).collection('tasks');
        await _taskCollection.add(task.toJson());
      } catch (error) {
        rethrow;
      }
    }
    print("the add task isn't done! because user is null");
  }

  Stream<List<TaskModel>>? getTask({required User? user}) {
    if (user != null) {
      try {
        return _firestore
            .collection('users')
            .doc(user.uid)
            .collection('tasks')
            .orderBy('time')
            .snapshots(includeMetadataChanges: true)
            .map((snapshot) => snapshot.docs
                .map((doc) => TaskModel.fromJson(doc.data(), doc.id))
                .toList());
      } catch (error) {
        print("the error is $error");
        rethrow;
      }
    }
    print("the get task isn't done! because user is null");
    return null;
  }

  void deleteTask({required String docId, required User? user}) async {
    if (user != null) {
      var _taskCollection =
          _firestore.collection('users').doc(user.uid).collection('tasks');
      await _taskCollection.doc(docId).delete();
    }
    print("the delete task isn't done! because user is null");
  }

  void updateTask({
    required String docId,
    required User? user,
    title,
    note,
    date,
    startTime,
    endTime,
    reminder,
    colorIndex,
  }) async {
    if (user != null) {
      var _taskCollection =
          _firestore.collection('user').doc(user.uid).collection('tasks');
      await _taskCollection.doc(docId).update({
        'title': title,
        'note': note,
        'date': date,
        'starttime': startTime,
        'endtime': endTime,
        'reminder': reminder,
        'colorindex': colorIndex,
      });
    }
    print("the add task isn't done! because user is null");
  }
}
