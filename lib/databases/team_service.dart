import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_manager/widgets/toast.dart';

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
    showToast("Team Created Successfully");
    fetchTeams();
    return docRef.id; // Return the generated team ID
  }
  Future<void> sendTeamInvitation(String teamName, String inviteeEmail, String teamId, String inviterId) async {
    final invitationDoc = FirebaseFirestore.instance.collection('invitations').doc();

    await invitationDoc.set({
      'invitationId': invitationDoc.id,
      'teamID': teamId,
      'teamName': teamName,
      'invitorID': inviterId,
      'inviteeEmail': inviteeEmail,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
    });

    // Optionally, integrate an email service to notify the user.
    print('Invitation sent to $inviteeEmail');
  }
  Future<void> acceptTeamInvitation(String invitationId, String teamId, String userId) async {
    final invitationDoc = FirebaseFirestore.instance.collection('invitations').doc(invitationId);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      // Update invitation status
      transaction.update(invitationDoc, {'status': 'accepted'});

      // Add user to team
      final teamDoc = FirebaseFirestore.instance.collection('teams').doc(teamId);
      transaction.update(teamDoc, {
        'members': FieldValue.arrayUnion([userId]),
      });

      // Update user teams
      final userDoc = FirebaseFirestore.instance.collection('users').doc(userId);
      transaction.update(userDoc, {
        'teams': FieldValue.arrayUnion([teamId]),
      });
    });
  }
  Future<void> rejectTeamInvitation(String invitationId) async {
    await FirebaseFirestore.instance.collection('invitations').doc(invitationId).update({'status': 'rejected'});
    print('Invitation rejected');
  }

  // Fetch teams for the current user (teams where the user is a member)
  Future<void> fetchTeams() async {
    String currentUserId = _auth.currentUser!.uid;
    QuerySnapshot snapshot = await teamCollection
        .where('members', arrayContains: currentUserId) // Fetch teams with user in members list
        .get();

    teams.assignAll(snapshot.docs.map((doc) {
      return Team.fromMap(doc.id, doc.data() as Map<String, dynamic>);
    }).toList());
    print(teams.length);
  }

  // Update team by ID
  Future<void> updateTeam(String teamId, Team team) async {
    await teamCollection.doc(teamId).update(team.toMap());
    teams.where((t) => t.teamId == teamId).first.updateTeam(team.name, team.teamMembers);
    showToast("Team Edited Successfully");
    fetchTeams();
  }

  // Delete team by ID
  Future<void> deleteTeam(String teamId) async {
    try {
      await teamCollection.doc(teamId).delete();
      teams.removeWhere((t) => t.teamId == teamId);
      showToast("Deleted Successfully");
    } on Exception catch (e) {
      showToast("Error occurred");
    }
  }

  Future<void> createTeam(String teamName, List<String> memberEmails) async {
    final firestore = FirebaseFirestore.instance;

    // Reference to the 'teams' collection in Firestore
    final teamDoc = firestore.collection('teams').doc();

    // List to store member IDs (userIds) and a map for detailed member data
    List<String> members = [];
    List<Map<String, dynamic>> memberDetails = [];

    for (var email in memberEmails) {
      try {
        // Fetch user IDs based on the member emails
        final querySnapshot = await firestore
            .collection('users')
            .where('email', isEqualTo: email)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          // Add userId to the members list
          final userId = querySnapshot.docs.first.id;

          // Add user details for further reference
          members.add(userId);
          memberDetails.add({
            'userId': userId,
            'email': email,
            'name': querySnapshot.docs.first.data()['name'], // Optional: if 'name' exists
          });
        } else {
          print('No user found with email: $email');
        }
      } catch (e) {
        print('Error fetching user for email $email: $e');
      }
    }

    if (members.isEmpty) {
      print('No valid members found. Aborting team creation.');
      return;
    }

    // Set the team data in Firestore
    try {
      await teamDoc.set({
        'name': teamName,
        'members': members, // Save the list of userIds
        'memberDetails': memberDetails, // Optionally save detailed member info
        'tasks': [], // Initially empty
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Update the 'teams' field of each user to reflect team membership
      for (var memberId in members) {
        await firestore
            .collection('users')
            .doc(memberId)
            .update({
          'teams': FieldValue.arrayUnion([teamDoc.id]), // Add team ID to user's teams
        });
      }

      print('Team created successfully with members.');
    } catch (e) {
      print('Error creating team: $e');
    }
  }

  Future<void> addMember(String email,String teamId) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isEmpty) {
        showToast('No user found with this email.');
        return;
      }

      final userId = querySnapshot.docs.first.id;

      await FirebaseFirestore.instance
          .collection('teams')
          .doc(teamId)
          .update({
        'members': FieldValue.arrayUnion([userId]),
      });

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({
        'teams': FieldValue.arrayUnion([teamId]),
      });
      showToast('Member added successfully.');

      fetchTeams(); // Refresh data
    } catch (e) {
      print('Error adding member: $e');
    }
  }

}
