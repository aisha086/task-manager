import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../databases/task_service.dart';
import '../../widgets/tasks/task_tile.dart';

class ViewTaskListScreen extends StatelessWidget {
  final TaskService taskService = Get.find();

  ViewTaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Task List")),
      body: Obx(() {
        if (taskService.tasks.isEmpty) {
          return const Center(child: Text("No tasks available."));
        }

        return ListView.builder(
          itemCount: taskService.tasks.length,
          itemBuilder: (context, index) {
            final task = taskService.tasks[index];
            return TaskTile(task: task); // Reusing TaskTile widget
          },
        );
      }),
    );
  }
}
