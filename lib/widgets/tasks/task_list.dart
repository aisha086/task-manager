import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/databases/task_service.dart';
import 'package:task_manager/services/notification_service.dart';
import 'package:task_manager/widgets/tasks/task_tile.dart';

import '../../models/task.dart';


class TaskListWidget extends StatelessWidget {

  TaskListWidget({
    super.key,
  });

  final TaskService taskService = Get.find();
  // final NotificationService notifyHelper = NotificationService();

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
                  itemCount: taskService.tasks.length < 5 ? taskService.tasks.length : 5,
                  itemBuilder: (context, index) {
                    final task = taskService.tasks[index];
                    // callScheduledNotification(task);
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

  // callScheduledNotification(Task task) {
  //   DateTime date = task.dueDate;
  //   DateTime notifTime = DateTime(date.year,date.month,date.day,date.hour,date.minute,0,0,0);
  //   //subtracting how many minutes early should the user be notified
  //   if (notifTime.isBefore(DateTime.now())) {
  //     print(notifTime);
  //     print(DateTime.now());
  //     print("not scheduled");
  //     return;
  //   } else {
  //     notifyHelper.scheduleNotification(task, notifTime);
  //   }
  // }
}
