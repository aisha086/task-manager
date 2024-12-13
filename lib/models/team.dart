import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Team {
  String teamId;
  String name;
  List teamMembers; // List of user IDs
  DateTime creationDate;
  String createdBy;

  Team({
    required this.teamId,
    required this.name,
    required this.teamMembers,
    required this.creationDate,
    required this.createdBy
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'members': teamMembers,
      'creationDate': Timestamp.now(),
      'createdBy': FirebaseAuth.instance.currentUser!.uid
    };
  }

  factory Team.fromMap(String docId, Map<String, dynamic> map) {
    Timestamp timestamp =  map['creationDate'];

    return Team(
      teamId: docId,
      name: map['name'] as String,
      teamMembers: map['members'],
      creationDate: timestamp.toDate(),
      createdBy: map['createdBy']
    );
  }

  updateTeam(String newName, List members){
    teamMembers = members;
    name = newName;

  }
}
