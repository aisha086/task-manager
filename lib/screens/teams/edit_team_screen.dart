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
  final List _members = [];
  final TeamService _teamService = Get.find();
  final UserService userService = UserService();

  @override
  void initState()  {
    super.initState();
    _teamNameController.text = widget.team.name;
   getEmails();
  }

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
      _members.add(email);
    });

    _emailController.clear(); // Clear the input field
    showToast('Email added successfully');
  }

  void _removeMember(String email) {
    setState(() {
      _members.remove(email);
    });
  }

  void _updateTeam() async {

    UserService userService = UserService();

    List memberIds = await userService.getMemberIdsByEmails(_members);
    final updatedTeamName = _teamNameController.text.trim();
    Team newTeam = Team(teamId: widget.team.teamId, name: updatedTeamName, teamMembers: memberIds, creationDate: DateTime.now(), createdBy: '');
    await _teamService.updateTeam(widget.team.teamId, newTeam);
    Navigator.pop(context);
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
              decoration: const InputDecoration(
                labelText: 'Team Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Members:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: _members.length,
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
              ),
            ),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Add Member'),
                      content: TextField(
                        controller: _emailController,
                        decoration: const InputDecoration(labelText: 'Member Email'),
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
              },
              child: const Text('Add Member'),
            ),
          ],
        ),
      ),
    );
  }

  getEmails() async {
    final _memberEmails = await userService.getEmailsByIds(widget.team.teamMembers);

    setState(() {
      _members.addAll(_memberEmails);
    });
  }
}


