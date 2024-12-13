import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/databases/team_service.dart';
import 'package:task_manager/screens/teams/edit_team_screen.dart';

import '../../models/team.dart';

class TeamDetailsScreen extends StatefulWidget {
  // final String teamId;
  final Team team;

  const TeamDetailsScreen({super.key, required this.team});

  @override
  State<TeamDetailsScreen> createState() => _TeamDetailsScreenState();
}

class _TeamDetailsScreenState extends State<TeamDetailsScreen> {
  // late var teamData;
  // bool isLoading = true;
  TeamService teamService = Get.find();

  @override
  void initState() {
    super.initState();
    // _fetchTeamData();
  }

  // Future<void> _fetchTeamData() async {
  //   try {
  //     final doc = await FirebaseFirestore.instance
  //         .collection('teams')
  //         .doc(widget.teamId)
  //         .get();
  //
  //     teamData = teamService.teams.where((a)=>widget.teamId == a.teamId);
  //
  //     setState(() {
  //       teamData = doc;
  //       isLoading = false;
  //     });
  //   } catch (e) {
  //     print('Error fetching team details: $e');
  //   }
  // }


  @override
  Widget build(BuildContext context) {
    // if (isLoading) {
    //   return Scaffold(
    //     appBar: AppBar(title: const Text('Team Details')),
    //     body: const Center(child: CircularProgressIndicator()),
    //   );
    // }

    final members = widget.team.teamMembers;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.team.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Team Name: ${widget.team.name}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            const Text('Members:', style: TextStyle(fontSize: 18)),
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
                        return const ListTile(title: Text('Loading...'));
                      }

                      if (snapshot.hasError) {
                        return const ListTile(title: Text('Error loading user.'));
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
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.edit),
                  label: const Text("Edit"),
                  onPressed: () {
                    Get.to(() => EditTeamScreen(team: widget.team,));
                  },
                ),
                if(widget.team.createdBy == FirebaseAuth.instance.currentUser!.uid)
                ElevatedButton.icon(
                  icon: const Icon(Icons.delete),
                  label: const Text("Delete"),
                  onPressed: () => _showConfirmationDialog(
                    context,
                    title: "Delete Team",
                    content: "Are you sure you want to delete this team?",
                    onConfirm: () => teamService.deleteTeam(widget.team.teamId),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Show dialog to add a new member
                    showDialog(
                      context: context,
                      builder: (context) {
                        final emailController = TextEditingController();

                        return AlertDialog(
                          title: const Text('Add Member'),
                          content: TextField(
                            controller: emailController,
                            decoration: const InputDecoration(
                              labelText: 'Member Email',
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                teamService.addMember(emailController.text.trim(),widget.team.teamId);
                                Navigator.pop(context);
                              },
                              child: const Text('Add'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Text('Add Member'),
                ),
              ],
            ),
            // ElevatedButton(
            //   onPressed: () {
            //     // Show dialog to add a new member
            //     showDialog(
            //       context: context,
            //       builder: (context) {
            //         final emailController = TextEditingController();
            //
            //         return AlertDialog(
            //           title: const Text('Add Member'),
            //           content: TextField(
            //             controller: emailController,
            //             decoration: const InputDecoration(
            //               labelText: 'Member Email',
            //             ),
            //           ),
            //           actions: [
            //             TextButton(
            //               onPressed: () => Navigator.pop(context),
            //               child: const Text('Cancel'),
            //             ),
            //             ElevatedButton(
            //               onPressed: () {
            //                 teamService.addMember(emailController.text.trim(),widget.team.teamId);
            //                 Navigator.pop(context);
            //               },
            //               child: const Text('Add'),
            //             ),
            //           ],
            //         );
            //       },
            //     );
            //   },
            //   child: const Text('Add Member'),
            // ),
          ],
        ),
      ),
    );
  }
}

void _showConfirmationDialog(
    BuildContext context, {
      required String title,
      required String content,
      required VoidCallback onConfirm,
    }) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            onConfirm();
          },
          child: const Text("Confirm"),
        ),
      ],
    ),
  );
}
