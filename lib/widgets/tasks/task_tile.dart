import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/databases/task_service.dart';

import '../../models/task.dart';
import '../../screens/tasks/task_detail_screens.dart';

class TaskTile extends StatelessWidget {
  final Task task;

  TaskTile({
    super.key,
    required this.task,
  });

  final TaskService taskService = Get.find();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(() => TaskDetailScreen(task: task)),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5.0),
        decoration: BoxDecoration(
          color: task.isCompleted
              ? Colors.lightGreen.shade600.withOpacity(0.5)
              : _getPriorityColor(task.priority),
          borderRadius: BorderRadius.circular(10)
        ),
        child: ListTile(
          title: Text(
            task.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              decoration: task.isCompleted ? TextDecoration.lineThrough : null,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(task.description),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    "${task.dueDate.day}/${task.dueDate.month}/${task.dueDate.year}",
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _showConfirmationDialog(
                  context,
                  title: "Delete Task",
                  content: "Are you sure you want to delete this task?",
                  onConfirm: () => taskService.deleteTask(task.taskId),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.check_circle,
                  color: task.isCompleted ? Colors.grey : Colors.green,
                ),
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
        ),
      ),
    );
  }

  // Helper to get the color based on priority
  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return Colors.red.shade300.withOpacity(0.5);
      case 'Medium':
        return Colors.orange.shade400.withOpacity(0.5);
      case 'Low':
        return Colors.yellow.shade300.withOpacity(0.5);
      default:
        return Colors.grey.shade200.withOpacity(0.5);
    }
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
