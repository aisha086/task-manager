import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/widgets/tasks/custom_text_field.dart';
import 'package:task_manager/widgets/toast.dart';
import '../../databases/task_service.dart';
import '../../databases/team_service.dart';
import '../../databases/user_service.dart';
import '../../models/task.dart';
import '../../models/team.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TaskService taskService = Get.find<TaskService>();
  final TeamService teamService =
      Get.find<TeamService>(); // Initialize TeamService
  final UserService userService = UserService();

  final TextEditingController _taskNameController = TextEditingController();

  final TextEditingController _taskDescriptionController =
      TextEditingController();

  final TextEditingController _dueDateController = TextEditingController();
  final TextEditingController _dueTimeController = TextEditingController();

  final TextEditingController _labelController = TextEditingController();

  // Default priority
  String _priority = 'Medium';

  DateTime? _dueDate;

  // List to store task labels/tags
  List<String> _labels = [];

  Team? _selectedTeam;
  String? _selectedMember;
  List<String> _assignedMembers = [];
  List<String> members = [];

  @override
  void initState() {
    // getMembers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Task")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Task Name
              CustomTextField(
                  label: 'Task Name', controller: _taskNameController),
              const SizedBox(height: 16),

              // Task Description
              CustomTextField(
                  label: 'Description', controller: _taskDescriptionController),
              const SizedBox(height: 16),

              // Priority Selection
              DropdownButtonFormField<String>(
                value: _priority,
                onChanged: (value) {
                  _priority = value!;
                },
                decoration: const InputDecoration(
                  labelText: 'Priority',
                  border: OutlineInputBorder(),
                ),
                items: ['High', 'Medium', 'Low']
                    .map((item) => DropdownMenuItem(
                          value: item,
                          child: Text(item),
                        ))
                    .toList(),
              ),

              const SizedBox(height: 16),

              // Due Date Selection
              CustomTextField(
                label: "Due Date",
                controller: _dueDateController,
                readOnly: true,
                onTap: _selectDate,
              ),
              const SizedBox(height: 16),

              CustomTextField(
                label: "Task Time",
                controller: _dueTimeController,
                readOnly: true,
                onTap: _selectTime,
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<Team>(
                value: _selectedTeam,
                onChanged: (value) {
                  setState(() {
                    _selectedTeam = value;
                    _selectedMember =
                        null; // Reset selected member when team changes
                    getMembers();
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Team',
                  border: OutlineInputBorder(),
                ),
                items: [
                  const DropdownMenuItem(
                      value: null, child: Text("Select Team")),
                  ...teamService.teams.map((team) => DropdownMenuItem(
                        value: team,
                        child: Text(team.name),
                      )),
                ],
              ),
              const SizedBox(height: 16),

              // Assigned Member Dropdown (Enabled if Team is selected)
              if (_selectedTeam != null)
                DropdownButtonFormField<String>(
                  value: _selectedMember,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedMember = value;
                        if (!_assignedMembers.contains(_selectedMember)) {
                          _assignedMembers.add(value); // Add selected member
                        } else {
                          showToast("Already added");
                        }
                      });
                    }
                  },
                  decoration: const InputDecoration(
                    labelText: 'Assign Member',
                    border: OutlineInputBorder(),
                  ),
                  items: members
                      .map((member) => DropdownMenuItem(
                            value: member,
                            child: Text(member),
                          ))
                      .toList(),
                ),
              const SizedBox(height: 16),

              // Display Assigned Members with option to remove
              if (_assignedMembers.isNotEmpty) ...[
                const Text(
                  "Assigned Members",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
                ),
                const SizedBox(height: 8),
                Column(
                  children: _assignedMembers.map((member) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(member),
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            setState(() {
                              _assignedMembers.remove(member); // Remove member
                            });
                          },
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ],

              const SizedBox(height: 16),

              // Labels Section
              const Text(
                "Labels",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
              ),
              const SizedBox(height: 8),
              labelField(),
              const SizedBox(height: 8),

              // Display Labels
              Wrap(
                spacing: 8.0,
                children: _labels
                    .map(
                      (label) => Chip(
                        label: Text(label),
                        deleteIcon: const Icon(Icons.close),
                        onDeleted: () => _removeLabel(label),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 16),

              // Save Button
              ElevatedButton(
                onPressed: _addTask,
                child: const Text("Save Task"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to pick the due date
  _selectDate() async {
    DateTime? selectedDate = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (selectedDate != null) {
      setState(() {
        _dueDate = selectedDate;
        _dueDateController.text = DateFormat('yyyy-MM-dd').format(_dueDate!);
      });
    }
  }

  _selectTime() async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: Get.context!,
      initialTime: TimeOfDay.fromDateTime(_dueDate ?? DateTime.now()),
    );

    if (selectedTime != null) {
      setState(() {
        // Combine the existing date with the selected time
        _dueDate = DateTime(
          _dueDate?.year ?? DateTime.now().year,
          _dueDate?.month ?? DateTime.now().month,
          _dueDate?.day ?? DateTime.now().day,
          selectedTime.hour,
          selectedTime.minute,
        );

        // Update the controller with formatted DateTime
        _dueTimeController.text = DateFormat('hh:mm a').format(_dueDate!);
      });
    }
  }


  // Function to add a task
  _addTask() async {
    if (_taskNameController.text.isEmpty ||
        _taskDescriptionController.text.isEmpty ||
        _dueDate == null) {
      Get.snackbar("Error", "Please fill all the fields");
      return;
    }

    List memberIds = [];

    if(_assignedMembers.isNotEmpty){
      memberIds = await userService.getMemberIdsByEmails(_assignedMembers);
    }

    Task newTask = Task(
        name: _taskNameController.text,
        description: _taskDescriptionController.text,
        priority: _priority,
        dueDate: _dueDate!,
        labels: _labels,
        assignedTeamMembers: memberIds,
        taskId: '',
        isCompleted: false,
        teamId: _selectedTeam?.teamId,
      taskIntId: 0
    );

    await taskService.addTask(newTask);
    Get.back(); // Go back to the previous screen
  }

  //labels field
  labelField() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _labelController,
            decoration: const InputDecoration(
              hintText: "Enter label",
              border: OutlineInputBorder(),
            ),
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: _addLabel,
          child: const Text("Add"),
        ),
      ],
    );
  }

  // Function to add a label
  _addLabel() {
    if (_labelController.text.isNotEmpty) {
      setState(() {
        _labels.add(_labelController.text.trim());
        _labelController.clear();
      });
    }
  }

  // Function to remove a label
  _removeLabel(String label) {
    setState(() {
      _labels.remove(label);
    });
  }

  getMembers() async {
    List<String> membersList =
        await userService.getEmailsByIds(_selectedTeam!.teamMembers);
    setState(() {
      members = membersList;
    });
  }
}
