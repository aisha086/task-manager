import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Task {
  String name;
  String description;
  String priority; // High, Medium, Low
  DateTime dueDate;
  List labels;
  List assignedTeamMembers;
  String taskId;
  bool isCompleted;

  Task({
    required this.name,
    required this.description,
    required this.priority,
    required this.dueDate,
    required this.labels,
    required this.assignedTeamMembers,
    required this.taskId,
    required this.isCompleted
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'priority': priority,
      'dueDate': dueDate,
      'labels': labels,
      'assignedTeamMembers': assignedTeamMembers,
      'userId': FirebaseAuth.instance.currentUser!.uid,
      'isCompleted': isCompleted
    };
  }

  factory Task.fromMap(String docId, Map<String, dynamic> map) {

    Timestamp timestamp =  map['dueDate'];

    return Task(
      name: map['name'] as String,
      description: map['description'] as String,
      priority: map['priority'] as String,
      dueDate: timestamp.toDate(),
      labels: map['labels'] as List,
      assignedTeamMembers: map['assignedTeamMembers'] as List,
      taskId: docId,
      isCompleted: map['isCompleted'] as bool
    );
  }
}
