import 'package:cloud_firestore/cloud_firestore.dart';

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
