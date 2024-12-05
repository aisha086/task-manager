import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/screens/teams/teamsDetailsScreen.dart';

import 'mainteams_screen.dart'; // Import the Add Team screen

class TeamsListScreen extends StatelessWidget {
  final String userId; // Pass the current user's ID

  TeamsListScreen({required this.userId});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Teams'),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('teams')
            .where('members', arrayContains: userId)
            .snapshots(),
        builder: (context, snapshot) {
          print('Snapshot Connection State: ${snapshot.connectionState}');
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          print('User ID passed to TeamsListScreen: $userId');

          if (snapshot.hasError) {

            print('Error: ${snapshot.error}');
            return Center(child: Text('Error loading teams'));
          }

          final teams = snapshot.data?.docs ?? [];
          print('Teams found: ${teams.length}'); // Log the number of teams
          if (snapshot.hasData) {
            print('Teams Data: ${snapshot.data!.docs}');
          } else {
            print('Snapshot has no data.');
          }
          if (teams.isEmpty) {
            return Center(child: Text('You are not part of any team.'));
          }

          return ListView.builder(
            itemCount: teams.length,
            itemBuilder: (context, index) {
              final team = teams[index];
              print('Team Name: ${team['name']}'); // Log team names
              return ListTile(
                title: Text(team['name']),
                subtitle: Text('Team ID: ${team.id}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TeamDetailsScreen(teamId: team.id),
                    ),
                  );
                },
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
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor, // Optional: use theme color
      ),
    );
  }
}
