import 'package:flutter/material.dart';

import '../../models/task.dart';

class TaskTile extends StatelessWidget {
  final Task task;

  const TaskTile({
    super.key,
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: task.priority == 'High'
            ? Colors.red
            : task.priority == 'Medium'
            ? Colors.orange
            : Colors.green,
        child: Text(task.priority[0]),
      ),
      title: Text(task.name),
      subtitle: Text(task.description),
      trailing: Text(
        "${task.dueDate.day}/${task.dueDate.month}/${task.dueDate.year}",
        style: const TextStyle(color: Colors.grey),
      ),
    );
  }
}
