import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/models/team.dart';

import '../../databases/team_service.dart';
import '../../databases/user_service.dart';
import '../../widgets/toast.dart';

class EditTeamScreen extends StatefulWidget {
  final Team team;

  const EditTeamScreen({
    super.key,
    required this.team,
  });

  @override
  State<EditTeamScreen> createState() => _EditTeamScreenState();
}

class _EditTeamScreenState extends State<EditTeamScreen> {
  final TextEditingController _teamNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final List<String> _members = [];
  final TeamService _teamService = Get.find();
  final UserService userService = UserService();

  @override
  void initState() {
    super.initState();
    _teamNameController.text = widget.team.name;
    _fetchEmails();
  }

  void _addMemberEmail() {
    final email = _emailController.text.trim();

    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

    if (email.isEmpty) {
      showToast('Email cannot be empty');
      return;
    }

    if (!emailRegex.hasMatch(email)) {
      showToast('Please enter a valid email address');
      return;
    }

    if (_members.contains(email)) {
      showToast('Email is already in the team');
      return;
    }

    setState(() {
      _members.add(email);
    });

    _emailController.clear();
    showToast('Email added successfully');
  }

  void _removeMember(String email) {
    setState(() {
      _members.remove(email);
    });
    showToast('Member removed successfully');
  }

  void _updateTeam() async {
    final memberIds = await userService.getMemberIdsByEmails(_members);
    final updatedTeamName = _teamNameController.text.trim();
    final newTeam = Team(
      teamId: widget.team.teamId,
      name: updatedTeamName,
      teamMembers: memberIds,
      creationDate: DateTime.now(),
      createdBy: widget.team.createdBy,
    );
    await _teamService.updateTeam(widget.team.teamId, newTeam);
    Navigator.pop(context);
  }

  Future<void> _fetchEmails() async {
    final memberEmails = await userService.getEmailsByIds(widget.team.teamMembers);
    setState(() {
      _members.addAll(memberEmails);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Team'),
        actions: [
          IconButton(
            onPressed: _updateTeam,
            icon: const Icon(Icons.check),
            tooltip: 'Save Changes',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _teamNameController,
              decoration: InputDecoration(
                labelText: 'Team Name',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Members:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: _members.isNotEmpty
                  ? ListView.separated(
                itemCount: _members.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final email = _members[index];
                  return ListTile(
                    title: Text(email),
                    trailing: IconButton(
                      icon: const Icon(Icons.remove_circle, color: Colors.red),
                      onPressed: () => _removeMember(email),
                    ),
                  );
                },
              )
                  : const Center(
                child: Text(
                  'No members added yet',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                onPressed: () => _showAddMemberDialog(context),
                icon: const Icon(Icons.person_add),
                label: const Text('Add Member'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddMemberDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Member'),
          content: TextField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Member Email',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _addMemberEmail();
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
