import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/widgets/tasks/custom_text_field.dart';
import '../../databases/task_service.dart';
import '../../models/task.dart';


class AddTaskScreen extends StatefulWidget {

  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TaskService taskService = Get.find<TaskService>();

  final TextEditingController _taskNameController = TextEditingController();

  final TextEditingController _taskDescriptionController = TextEditingController();

  final TextEditingController _dueDateController = TextEditingController();

  // Default priority
  String _priority = 'Medium';

  DateTime? _dueDate;

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
                  label: 'Task Name',
                  controller: _taskNameController),
              const SizedBox(height: 16),
        
              // Task Description
              CustomTextField(
                  label: 'Description',
                  controller: _taskDescriptionController),
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
                    .map((priority) => DropdownMenuItem(
                  value: priority,
                  child: Text(priority),
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

  // Function to add a task
  _addTask() async {
    if (_taskNameController.text.isEmpty || _taskDescriptionController.text.isEmpty || _dueDate == null) {
      Get.snackbar("Error", "Please fill all the fields");
      return;
    }

    Task newTask = Task(
      name: _taskNameController.text,
      description: _taskDescriptionController.text,
      priority: _priority,
      dueDate: _dueDate!,// Use current user ID
      labels: ['urgent'], //TODO ADD FUNCTIONALITY FOR LABELS
      assignedTeamMembers: [], //TODO ADD FUNCTIONALITY FOR TEAM MEMBERS
      taskId: '',
      isCompleted: false,
    );

    String taskId = await taskService.addTask(newTask);
    Get.snackbar("Success", "Task added with ID: $taskId");
    Get.back(); // Go back to the previous screen
  }
}
