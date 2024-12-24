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
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.teal.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.teal.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Description:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal)),
                    Text(widget.task.description, style: const TextStyle(fontSize: 16,color: Colors.black)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              buildInfoCard(
                title: "Priority",
                content: widget.task.priority,
                icon: Icons.flag,
                color: Colors.orange,
              ),
              buildInfoCard(
                title: "Due Date",
                content: "${widget.task.dueDate.day}/${widget.task.dueDate.month}/${widget.task.dueDate.year}",
                icon: Icons.calendar_today,
                color: Colors.blue,
              ),
              if (widget.task.labels != null && widget.task.labels!.isNotEmpty)
                buildInfoCard(
                  title: "Labels",
                  content: widget.task.labels!.join(', '),
                  icon: Icons.label,
                  color: Colors.purple,
                ),
              if (widget.task.assignedTeamMembers != null && widget.task.assignedTeamMembers!.isNotEmpty)
                buildInfoCard(
                  title: "Assigned Team Members",
                  content: members.join(', '),
                  icon: Icons.group,
                  color: Colors.green,
                ),
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
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
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
      ),
    );
  }

  Widget buildInfoCard({required String title, required String content, required IconData icon, required Color color}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
                Text(content, style: const TextStyle(fontSize: 14)),
              ],
            ),
          ),
        ],
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
    List<String> membersList = [];
    if (widget.task.assignedTeamMembers != null) {
      membersList = await userService.getEmailsByIds(widget.task.assignedTeamMembers!);
    }
    setState(() {
      members = membersList;
    });
  }
}
