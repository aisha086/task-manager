import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:task_manager/databases/task_service.dart';

class TaskProgressWidget extends StatefulWidget {


  const TaskProgressWidget({
    super.key,
  });

  @override
  State<TaskProgressWidget> createState() => _TaskProgressWidgetState();
}

class _TaskProgressWidgetState extends State<TaskProgressWidget> {
  TaskService taskService = Get.find();

  @override
  Widget build(BuildContext context) {
    double progress = taskService.completed.value / (taskService.pending.value + taskService.completed.value);
    int total = (taskService.pending.value + taskService.completed.value);
    Size size = MediaQuery.of(context).size;
    return Obx(
      () {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'Task Progress',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(width: 10),
            CircularPercentIndicator(
              radius: size.width/5,
              lineWidth: 12.0,
              percent: total == 0 ? 0 : progress,
              center: Text(
                '${taskService.completed.value}/$total',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.green,
                ),
              ),
              progressColor: Colors.green,
              backgroundColor: Colors.grey[300]!,
            ),
          ],
        );
      }
    );
  }
}
