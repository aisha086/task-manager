import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/databases/task_service.dart';
import 'package:task_manager/screens/tasks/add_task_screen.dart';
import 'package:task_manager/screens/tasks/view_tasks_screen.dart';

import '../services/firebase_auth_service.dart';
import '../widgets/dashboard/action_buttons.dart';
import '../widgets/tasks/task_list.dart';
import '../widgets/tasks/task_progress.dart';

class HomePage extends StatefulWidget {

  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  TaskService taskService = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Dashboard'),
        actions: [
          IconButton(
              onPressed: () => FirebaseAuthService().signOut(),
              icon: const Icon(Icons.logout_rounded))
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Get.find<TaskService>().fetchTasks();
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TaskProgressWidget(),
              const SizedBox(height: 20),
              TaskListWidget(),
              const SizedBox(height: 20),
              ActionButtonsWidget(
                onViewFullList: () {
                  Get.to(() => ViewTaskListScreen());
                },
                onAddNewTask: () {
                 Get.to(() => const AddTaskScreen());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
