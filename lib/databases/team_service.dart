import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/team.dart';

class TeamService extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference teamCollection =
  FirebaseFirestore.instance.collection('teams');

  // Observable list for teams
  RxList<Team> teams = <Team>[].obs;

  @override
  void onInit() {
    fetchTeams();
    super.onInit();
  }

  // Add a new team
  Future<String> addTeam(Team team) async {
    DocumentReference docRef = await teamCollection.add(team.toMap());
    return docRef.id; // Return the generated team ID
  }

  // Fetch teams for the current user (teams where the user is a member)
  Future<void> fetchTeams() async {
    String currentUserId = _auth.currentUser!.uid;
    QuerySnapshot snapshot = await teamCollection
        .where('teamMembers', arrayContains: currentUserId) // Fetch teams with user in members list
        .get();

    teams.assignAll(snapshot.docs.map((doc) {
      return Team.fromMap(doc.id, doc.data() as Map<String, dynamic>);
    }).toList());
  }

  // Update team by ID
  Future<void> updateTeam(String teamId, Team team) async {
    await teamCollection.doc(teamId).update(team.toMap());
  }

  // Delete team by ID
  Future<void> deleteTeam(String teamId) async {
    await teamCollection.doc(teamId).delete();
  }
}
