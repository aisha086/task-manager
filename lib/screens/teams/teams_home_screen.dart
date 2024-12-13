import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/databases/team_service.dart';
import 'package:task_manager/screens/teams/teams_details_screen.dart';
import 'package:task_manager/widgets/teams/team_tile.dart';

import 'create_team_screen.dart'; // Import the Add Team screen

class TeamsListScreen extends StatelessWidget {

  TeamsListScreen({super.key });

  TeamService teamService = Get.find();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Teams'),
      ),

      body: teamService.teams.isEmpty?
          const Center(child: Text("You are not part of any teams"),)
      :ListView.builder(
        itemCount: teamService.teams.length,
        itemBuilder: (context, index) {
          final team = teamService.teams[index];
          // print('Team Name: ${team['name']}'); // Log team names
          return TeamTile(team: team);
        },
      ),
      // StreamBuilder<QuerySnapshot>(
      //   stream: FirebaseFirestore.instance
      //       .collection('teams')
      //       .where('members', arrayContains: userId)
      //       .snapshots(),
      //   builder: (context, snapshot) {
      //     print('Snapshot Connection State: ${snapshot.connectionState}');
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return const Center(child: CircularProgressIndicator());
      //     }
      //     print('User ID passed to TeamsListScreen: $userId');
      //
      //     if (snapshot.hasError) {
      //
      //       print('Error: ${snapshot.error}');
      //       return const Center(child: Text('Error loading teams'));
      //     }
      //
      //     final teams = snapshot.data?.docs ?? [];
      //     print('Teams found: ${teams.length}'); // Log the number of teams
      //     if (snapshot.hasData) {
      //       print('Teams Data: ${snapshot.data!.docs}');
      //     } else {
      //       print('Snapshot has no data.');
      //     }
      //     if (teams.isEmpty) {
      //       return const Center(child: Text('You are not part of any team.'));
      //     }
      //
      //     return ListView.builder(
      //       itemCount: teams.length,
      //       itemBuilder: (context, index) {
      //         final team = teams[index];
      //         print('Team Name: ${team['name']}'); // Log team names
      //         return ListTile(
      //           title: Text(team['name']),
      //           subtitle: Text('Team ID: ${team.id}'),
      //           onTap: () {
      //             Navigator.push(
      //               context,
      //               MaterialPageRoute(
      //                 builder: (context) => TeamDetailsScreen(teamId: team.id),
      //               ),
      //             );
      //           },
      //         );
      //       },
      //     );
      //   },
      // ),

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
        backgroundColor: Theme.of(context).primaryColor, // Optional: use theme color
      ),
    );
  }
}
