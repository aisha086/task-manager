import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/widgets/tasks/task_tile.dart';

import '../../models/task.dart';

class TaskListWidget extends StatelessWidget {
  final List<Task> tasks;

  const TaskListWidget({
    super.key,
    required this.tasks,
  });

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return Obx(
       () {
        return SizedBox(
          height: size.height/2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Top 5 Tasks',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return TaskTile(task: task);
                  },
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}
