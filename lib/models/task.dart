import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Task {
  String name;
  String description;
  String priority; // High, Medium, Low
  DateTime dueDate;
  List? labels;
  List? assignedTeamMembers;
  String? teamId;
  String taskId;
  int taskIntId;
  bool isCompleted;

  Task({
    required this.name,
    required this.description,
    required this.priority,
    required this.dueDate,
    this.labels,
    this.assignedTeamMembers,
    this.teamId,
    required this.taskId,
    required this.isCompleted,
    required this.taskIntId
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'priority': priority,
      'dueDate': dueDate,
      'labels': labels,
      'assignedTeamMembers': assignedTeamMembers,
      'teamId': teamId,
      'userId': FirebaseAuth.instance.currentUser!.uid,
      'isCompleted': isCompleted,
      'taskIntId': DateTime.now().millisecondsSinceEpoch ~/ 1000
    };
  }

  factory Task.fromMap(String docId, Map<String, dynamic> map) {

    Timestamp timestamp =  map['dueDate'];

    return Task(
      name: map['name'] as String,
      description: map['description'] as String,
      priority: map['priority'] as String,
      dueDate: timestamp.toDate(),
      labels: map['labels'] as List?,
      assignedTeamMembers: map['assignedTeamMembers'] as List?,
      taskId: docId,
      teamId: map['teamId'] as String?,
      isCompleted: map['isCompleted'] as bool,
      taskIntId: map['taskIntId'] as int
    );
  }
}
