import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/databases/user_service.dart';
import 'package:task_manager/screens/tasks/edit_task_screen.dart';
import '../../models/task.dart';
import '../../databases/task_service.dart';

class TaskDetailScreen extends StatefulWidget {
  final Task task;

  const TaskDetailScreen({super.key, required this.task});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {

  final TaskService taskService = Get.find<TaskService>();
  final UserService userService = UserService();
  List<String> members = [];

  @override
  void initState() {
    getMembers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Description: ${widget.task.description}", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text("Priority: ${widget.task.priority}", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text(
              "Due Date: ${widget.task.dueDate.day}/${widget.task.dueDate.month}/${widget.task.dueDate.year}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            if (widget.task.labels != null && widget.task.labels!.isNotEmpty)
              Text("Labels: ${widget.task.labels!.join(', ')}", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            if (widget.task.assignedTeamMembers != null && widget.task.assignedTeamMembers!.isNotEmpty)
              Text("Assigned Team Members: ${members.join(', ')}",
                  style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.edit),
                  label: const Text("Edit"),
                  onPressed: () {
                    Get.to(() => EditTaskScreen(task: widget.task));
                  },
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.delete),
                  label: const Text("Delete"),
                  onPressed: () => _showConfirmationDialog(
                    context,
                    title: "Delete Task",
                    content: "Are you sure you want to delete this task?",
                    onConfirm: () => taskService.deleteTask(widget.task.taskId),
                  ),
                ),
                ElevatedButton.icon(
                  icon: Icon(
                    Icons.check_circle,
                    color: widget.task.isCompleted ? Colors.grey : Colors.green,
                  ),
                  label: const Text("Complete"),
                  onPressed: widget.task.isCompleted
                      ? null
                      : () => _showConfirmationDialog(
                    context,
                    title: "Mark as Complete",
                    content: "Do you want to mark this task as complete?",
                    onConfirm: () => taskService.markTaskAsCompleted(widget.task.taskId),
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

  getMembers() async {
    print("getting emails");
    List<String> membersList = [];
    if(widget.task.assignedTeamMembers != null) {
      membersList = await userService.getEmailsByIds(widget.task.assignedTeamMembers!);
    }
    setState(() {
      members = membersList;
      print(members);
    });
  }
}
