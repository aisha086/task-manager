import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/databases/team_service.dart';
import 'package:task_manager/models/team.dart';
import 'package:task_manager/screens/teams/teams_details_screen.dart';

import '../../screens/tasks/task_detail_screens.dart';

class TeamTile extends StatelessWidget {
  final Team team;

  TeamTile({
    super.key,
    required this.team,
  });

  final TeamService teamService = Get.find();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(() => TeamDetailsScreen(
            team: team,
          )),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5.0),
        decoration: BoxDecoration(
            color: Colors.amber.shade600.withOpacity(0.5),
            borderRadius: BorderRadius.circular(10)),
        child: ListTile(
          title: Text(
            team.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Row(
            children: [
              const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                "${team.creationDate}",
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if(team.createdBy == FirebaseAuth.instance.currentUser!.uid)
                IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _showConfirmationDialog(
                  context,
                  title: "Delete Team",
                  content: "Are you sure you want to delete this team?",
                  onConfirm: () => teamService.deleteTeam(team.teamId),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Reusable confirmation dialog
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
}
