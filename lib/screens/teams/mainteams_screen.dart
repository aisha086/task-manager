import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateTeamScreen extends StatefulWidget {
  @override
  _CreateTeamScreenState createState() => _CreateTeamScreenState();
}

class _CreateTeamScreenState extends State<CreateTeamScreen> {
  final _teamNameController = TextEditingController();
  final _emailController = TextEditingController();
  List<String> _memberEmails = [];  // List to store email addresses
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Team')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _teamNameController,
              decoration: InputDecoration(labelText: 'Team Name'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Add Member by Email'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addMemberEmail,
              child: Text('Add Member'),
            ),
            SizedBox(height: 16),
            Text('Members:'),
            Expanded(
              child: ListView.builder(
                itemCount: _memberEmails.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_memberEmails[index]),
                    trailing: IconButton(
                      icon: Icon(Icons.remove_circle),
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
            SizedBox(height: 16),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _createTeam,
              child: Text('Create Team'),
            ),
          ],
        ),
      ),
    );
  }

  // Add the email to the list of team members
  void _addMemberEmail() {
    final email = _emailController.text.trim();
    if (email.isNotEmpty) {
      setState(() {
        _memberEmails.add(email);
      });
      _emailController.clear();  // Clear the input field
    }
  }

  // Handle team creation
  Future<void> _createTeam() async {
    final teamName = _teamNameController.text.trim();
    if (teamName.isEmpty || _memberEmails.isEmpty) {
      // Show an error if the team name or member list is empty
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please provide a team name and add at least one member'),
      ));
      return;
    }

    setState(() {
      _isLoading = true;  // Show loading indicator
    });

    try {
      // Get the current user's ID
      final userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId == null) {
        // Show error if user is not logged in
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('User not logged in'),
        ));
        return;
      }

      // 1. Create a new team in Firestore
      final teamRef = await FirebaseFirestore.instance.collection('teams').add({
        'name': teamName,
        'members': [_memberEmails],
        'createdBy': userId,  // Store the creator's userId
        'createdAt': FieldValue.serverTimestamp(),
      });

      // 2. Update the user document with the new team ID (corrected)
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'teams': FieldValue.arrayUnion([teamRef.id]),  // Add the teamId to the user's teams array
      });

      // Optionally, navigate back or show a success message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Team created successfully'),
      ));

      // Clear inputs after team creation
      setState(() {
        _memberEmails.clear();
        _teamNameController.clear();
      });
    } catch (e) {
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error creating team: $e'),
      ));
    } finally {
      setState(() {
        _isLoading = false;  // Hide loading indicator
      });
    }
  }


}
