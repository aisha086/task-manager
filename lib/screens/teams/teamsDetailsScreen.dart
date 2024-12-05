import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TeamDetailsScreen extends StatefulWidget {
  final String teamId;

  TeamDetailsScreen({required this.teamId});

  @override
  _TeamDetailsScreenState createState() => _TeamDetailsScreenState();
}

class _TeamDetailsScreenState extends State<TeamDetailsScreen> {
  late DocumentSnapshot teamData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTeamData();
  }

  Future<void> _fetchTeamData() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('teams')
          .doc(widget.teamId)
          .get();

      setState(() {
        teamData = doc;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching team details: $e');
    }
  }

  Future<void> _addMember(String email) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No user found with this email.')),
        );
        return;
      }

      final userId = querySnapshot.docs.first.id;

      await FirebaseFirestore.instance
          .collection('teams')
          .doc(widget.teamId)
          .update({
        'members': FieldValue.arrayUnion([userId]),
      });

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({
        'teams': FieldValue.arrayUnion([widget.teamId]),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Member added successfully.')),
      );

      _fetchTeamData(); // Refresh data
    } catch (e) {
      print('Error adding member: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('Team Details')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final members = teamData['members'] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(teamData['name']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Team Name: ${teamData['name']}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 16),
            Text('Members:', style: TextStyle(fontSize: 18)),
            Expanded(
              child: ListView.builder(
                itemCount: members.length,
                itemBuilder: (context, index) {
                  final userId = members[index];

                  return FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('users')
                        .doc(userId)
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return ListTile(title: Text('Loading...'));
                      }

                      if (snapshot.hasError) {
                        return ListTile(title: Text('Error loading user.'));
                      }

                      final user = snapshot.data!;
                      return ListTile(
                        title: Text(user['name'] ?? 'Unknown'),
                        subtitle: Text(user['email'] ?? 'Unknown Email'),
                      );
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Show dialog to add a new member
                showDialog(
                  context: context,
                  builder: (context) {
                    final emailController = TextEditingController();

                    return AlertDialog(
                      title: Text('Add Member'),
                      content: TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: 'Member Email',
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _addMember(emailController.text.trim());
                            Navigator.pop(context);
                          },
                          child: Text('Add'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('Add Member'),
            ),
          ],
        ),
      ),
    );
  }
}
