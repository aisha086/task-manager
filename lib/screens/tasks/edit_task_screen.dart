import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/widgets/tasks/custom_text_field.dart';
import '../../databases/task_service.dart';
import '../../models/task.dart';

class EditTaskScreen extends StatefulWidget {
  const EditTaskScreen({super.key, required this.task});

  final Task task;

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final TaskService taskService = Get.find<TaskService>();

  final TextEditingController _taskNameController = TextEditingController();

  final TextEditingController _taskDescriptionController = TextEditingController();

  final TextEditingController _dueDateController = TextEditingController();

  final TextEditingController _labelController = TextEditingController();

  // Default priority
  late String _priority;

  DateTime? _dueDate;

  // List to store task labels/tags
  List<String> _labels = [];

  @override
  void initState() {
    _taskNameController.text = widget.task.name;
    _taskDescriptionController.text = widget.task.description;
    _dueDateController.text = DateFormat('yyyy-MM-dd').format(widget.task.dueDate);
    _priority = widget.task.priority;
    _labels = widget.task.labels!=null? widget.task.labels!.cast<String>() :[];
    _dueDate = widget.task.dueDate;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Task")),
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
                onPressed: () async =>_editTask(),
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

  // Function to add a task
  _editTask() async {
    if (_taskNameController.text.isEmpty ||
        _taskDescriptionController.text.isEmpty ||
        _dueDate == null) {
      Get.snackbar("Error", "Please fill all the fields");
      return;
    }

    print(_priority);

    Task newTask = Task(
        name: _taskNameController.text,
        description: _taskDescriptionController.text,
        priority: _priority,
        dueDate: _dueDate!,
        labels: _labels, //TODO ADD FUNCTIONALITY FOR LABELS
        assignedTeamMembers: null, //TODO ADD FUNCTIONALITY FOR TEAM MEMBERS
        taskId: '',
        isCompleted: false,
        teamId: null);

    await taskService.updateTask(widget.task.taskId,newTask);
    Get.back(); // Go back to the previous screen
  }

  //labels field
  labelField(){
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
}
