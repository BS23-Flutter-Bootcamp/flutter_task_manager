import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_task_manager/model/entities/task_entity.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> upsertTask(TaskEntity task, String email) async {
    final docRef = _firestore
        .collection('users')
        .doc(email)
        .collection('tasks')
        .doc(task.id.toString());
    await docRef.set(task.toFirestore());
  }

  Future<List<TaskEntity>> getTasks(String email) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(email)
          .collection('tasks')
          .get();
      return snapshot.docs
          .map((doc) => TaskEntity.fromFirestore(doc.data()))
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print('Firestore Error: $e');
      }
      rethrow;
    }
  }

  Future<TaskEntity?> getTask(int id, String email) async {
    try {
      final doc = await _firestore
          .collection('users')
          .doc(email)
          .collection('tasks')
          .doc(id.toString())
          .get();
      if (doc.exists) return TaskEntity.fromFirestore(doc.data()!);
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Firestore Error: $e');
      }
      rethrow;
    }
  }

  Future<void> deleteTask(int id, String email) async {
    try {
      await _firestore
          .collection('users')
          .doc(email)
          .collection('tasks')
          .doc(id.toString())
          .delete();
    } catch (e) {
      if (kDebugMode) {
        print('Firestore Error: $e');
      }
      rethrow;
    }
  }
}