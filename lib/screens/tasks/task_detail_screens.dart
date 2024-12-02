import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/screens/tasks/edit_task_screen.dart';
import '../../models/task.dart';
import '../../databases/task_service.dart';

class TaskDetailScreen extends StatelessWidget {
  final Task task;

  const TaskDetailScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final TaskService taskService = Get.find<TaskService>();

    return Scaffold(
      appBar: AppBar(
        title: Text(task.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Description: ${task.description}", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text("Priority: ${task.priority}", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text(
              "Due Date: ${task.dueDate.day}/${task.dueDate.month}/${task.dueDate.year}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            if (task.labels != null && task.labels!.isNotEmpty)
              Text("Labels: ${task.labels!.join(', ')}", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            if (task.assignedTeamMembers != null && task.assignedTeamMembers!.isNotEmpty)
              Text("Team Members: ${task.assignedTeamMembers!.join(', ')}",
                  style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.edit),
                  label: const Text("Edit"),
                  onPressed: () {
                    Get.to(() => EditTaskScreen(task: task));
                  },
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.delete),
                  label: const Text("Delete"),
                  onPressed: () => _showConfirmationDialog(
                    context,
                    title: "Delete Task",
                    content: "Are you sure you want to delete this task?",
                    onConfirm: () => taskService.deleteTask(task.taskId),
                  ),
                ),
                ElevatedButton.icon(
                  icon: Icon(
                    Icons.check_circle,
                    color: task.isCompleted ? Colors.grey : Colors.green,
                  ),
                  label: const Text("Complete"),
                  onPressed: task.isCompleted
                      ? null
                      : () => _showConfirmationDialog(
                    context,
                    title: "Mark as Complete",
                    content: "Do you want to mark this task as complete?",
                    onConfirm: () => taskService.markTaskAsCompleted(task.taskId),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
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
}
