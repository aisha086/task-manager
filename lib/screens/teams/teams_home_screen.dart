import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../models/team.dart';
import 'create_team_screen.dart';
import 'teams_details_screen.dart';

class TeamsListScreen extends StatelessWidget {
  TeamsListScreen({super.key});

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    // Get the current user's ID
    final String userId = _auth.currentUser?.uid ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Teams'),
        centerTitle: true,
        elevation: 4,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('teams')
            .where('members', arrayContains: userId) // Filter teams for this user
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error loading teams'));
          }

          final teams = snapshot.data?.docs ?? [];

          if (teams.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/no_teams.png',
                  height: 200,
                ),
                const SizedBox(height: 20),
                const Text(
                  'You are not part of any teams',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateTeamScreen(),
                      ),
                    );
                  },
                  child: const Text('Create a Team'),
                )
              ],
            );
          }

          return ListView.builder(
            itemCount: teams.length,
            itemBuilder: (context, index) {
              final team = teams[index];
              final teamData = Team.fromMap(team.id, team.data() as Map<String, dynamic>);

              // Custom Card with visuals
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: CircleAvatar(
                    backgroundColor: Colors.blueAccent,
                    child: Text(
                      teamData.name[0].toUpperCase(),
                      style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  title: Text(
                    teamData.name,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Created At: ${teamData.creationDate.toString().split(' ')[0]}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, color: Colors.blue),
                  onTap: () {
                    // Navigate to Team Details Screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TeamDetailsScreen(team: teamData),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the Add Team Screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateTeamScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
