import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:task_manager/databases/team_service.dart';
import 'package:task_manager/databases/user_service.dart';
import 'package:task_manager/models/team.dart';
import 'package:task_manager/widgets/toast.dart';

import '../../services/notification_service.dart';

class CreateTeamScreen extends StatefulWidget {
  const CreateTeamScreen({super.key});

  @override
  State<CreateTeamScreen> createState() => _CreateTeamScreenState();
}

class _CreateTeamScreenState extends State<CreateTeamScreen> {
  final _teamNameController = TextEditingController();
  final _emailController = TextEditingController();
  final NotificationService _notificationService = NotificationService();
  final List<String> _memberEmails = [];  // List to store email addresses
  bool _isLoading = false;
  TeamService teamService = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Team')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _teamNameController,
              decoration: const InputDecoration(labelText: 'Team Name'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Add Member by Email'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addMemberEmail,
              child: const Text('Add Member'),
            ),
            const SizedBox(height: 16),
            const Text('Members:'),
            Expanded(
              child: ListView.builder(
                itemCount: _memberEmails.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_memberEmails[index]),
                    trailing: IconButton(
                      icon: const Icon(Icons.remove_circle),
                      onPressed: () {
                        setState(() {
                          _memberEmails.removeAt(index);
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: addTeam,
              child: const Text('Create Team'),
            ),
          ],
        ),
      ),
    );
  }

  // Add the email to the list of team members
  void _addMemberEmail() {
    final email = _emailController.text.trim();

    // Regular expression for email validation
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

    if (email.isEmpty) {
      showToast('Email cannot be empty');
      return;
    }

    if (!emailRegex.hasMatch(email)) {
      showToast('Please enter a valid email address');
      return;
    }

    setState(() {
      _memberEmails.add(email);
    });

    _emailController.clear(); // Clear the input field
    showToast('Email added successfully');
  }


  Future<void> addTeam() async {
    if (_teamNameController.text.isEmpty || _memberEmails.isEmpty) {
      showToast('Please provide a team name and add at least one member');
      return;
    }
    UserService userService = UserService();

    try {
      setState(() => _isLoading = true);

      // Step 1: Create the team in Firestore
      String currentUserId = FirebaseAuth.instance.currentUser!.uid;
      List memberIds = await userService.getMemberIdsByEmails(_memberEmails);

      DocumentReference teamRef =
      await FirebaseFirestore.instance.collection('teams').add({
        'name': _teamNameController.text.trim(),
        'members': [], // No members until they accept the request
        'createdBy': currentUserId,
        'creationDate': FieldValue.serverTimestamp(),
      });

      String teamId = teamRef.id;

      // Step 2: Send notifications to members
      for (var email in _memberEmails) {
        await _notificationService.sendJoinRequest(
          senderId: currentUserId,
          receiverEmail: email,
          teamId: teamId,
          teamName: _teamNameController.text.trim(),
        );
      }

      showToast('Team created. Members have been notified.');
      Navigator.pop(context);
    } catch (e) {
      showToast('Error creating team: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }
  // Handle team creation
  // Future<void> _createTeam() async {
  //   final teamName = _teamNameController.text.trim();
  //   if (teamName.isEmpty || _memberEmails.isEmpty) {
  //     // Show an error if the team name or member list is empty
  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //       content: Text('Please provide a team name and add at least one member'),
  //     ));
  //     return;
  //   }
  //
  //   setState(() {
  //     _isLoading = true;  // Show loading indicator
  //   });
  //
  //   try {
  //     // Get the current user's ID
  //     final userId = FirebaseAuth.instance.currentUser?.uid;
  //
  //     if (userId == null) {
  //       // Show error if user is not logged in
  //       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //         content: Text('User not logged in'),
  //       ));
  //       return;
  //     }
  //
  //     // 1. Create a new team in Firestore
  //     final teamRef = await FirebaseFirestore.instance.collection('teams').add({
  //       'name': teamName,
  //       'members': [_memberEmails],
  //       'createdBy': userId,  // Store the creator's userId
  //       'createdAt': FieldValue.serverTimestamp(),
  //     });
  //
  //     // 2. Update the user document with the new team ID (corrected)
  //     await FirebaseFirestore.instance.collection('users').doc(userId).update({
  //       'teams': FieldValue.arrayUnion([teamRef.id]),  // Add the teamId to the user's teams array
  //     });
  //
  //     // Optionally, navigate back or show a success message
  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //       content: Text('Team created successfully'),
  //     ));
  //
  //     // Clear inputs after team creation
  //     setState(() {
  //       _memberEmails.clear();
  //       _teamNameController.clear();
  //     });
  //   } catch (e) {
  //     // Handle errors
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       content: Text('Error creating team: $e'),
  //     ));
  //   } finally {
  //     setState(() {
  //       _isLoading = false;  // Hide loading indicator
  //     });
  //   }
  // }


}
