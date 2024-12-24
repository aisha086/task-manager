import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/databases/team_service.dart';
import 'package:task_manager/screens/teams/edit_team_screen.dart';
import '../../models/team.dart';

class TeamDetailsScreen extends StatefulWidget {
  final Team team;

  const TeamDetailsScreen({super.key, required this.team});

  @override
  State<TeamDetailsScreen> createState() => _TeamDetailsScreenState();
}

class _TeamDetailsScreenState extends State<TeamDetailsScreen> {
  TeamService teamService = Get.find();

  @override
  Widget build(BuildContext context) {
    final members = widget.team.teamMembers;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.team.name,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Team Name: ${widget.team.name}',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Colors.indigo,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Members:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 10),
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
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return const Center(
                          child: Text('Error loading user.'),
                        );
                      }

                      final user = snapshot.data!;
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        elevation: 4.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.indigo,
                            child: Text(
                              user['name']?.substring(0, 1).toUpperCase() ?? '?',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          title: Text(
                            user['name'] ?? 'Unknown',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(user['email'] ?? 'Unknown Email'),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    backgroundColor: Colors.indigo,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: const Icon(Icons.edit, color: Colors.white),
                  label: const Text("Edit",style: TextStyle(
                      fontSize: 11,color: Colors.black
                  ),),
                  onPressed: () {
                    Get.to(() => EditTeamScreen(team: widget.team));
                  },
                ),
                if (widget.team.createdBy ==
                    FirebaseAuth.instance.currentUser!.uid)
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: const Icon(Icons.delete, color: Colors.white),
                    label: const Text("Delete",style: TextStyle(
                        fontSize: 11,color: Colors.black
                    ),),
                    onPressed: () => _showConfirmationDialog(
                      context,
                      title: "Delete Team",
                      content: "Are you sure you want to delete this team?",
                      onConfirm: () => teamService.deleteTeam(widget.team.teamId),
                    ),
                  ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        final emailController = TextEditingController();

                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          title: const Text('Add Member'),
                          content: TextField(
                            controller: emailController,
                            decoration: const InputDecoration(
                              labelText: 'Member Email',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text(
                                'Cancel',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.indigo,
                              ),
                              onPressed: () {
                                teamService.addMember(
                                    emailController.text.trim(),
                                    widget.team.teamId);
                                Navigator.pop(context);
                              },
                              child: const Text('Add'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Text('Add Member',style: TextStyle(
                    fontSize: 11,color: Colors.black
                  ),),
                ),
              ],
            ),
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            "Cancel",
            style: TextStyle(color: Colors.red),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigo,
          ),
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
