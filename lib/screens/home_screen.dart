import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/databases/task_service.dart';
import 'package:task_manager/databases/team_service.dart';
import 'package:task_manager/screens/settings.dart';
import 'package:task_manager/screens/tasks/add_task_screen.dart';
import 'package:task_manager/screens/tasks/view_tasks_screen.dart';
import 'package:task_manager/screens/chat/chat_screen_main.dart';
import 'package:task_manager/services/notification_service.dart';
import 'package:task_manager/widgets/dashboard/drawer.dart';

import '../services/firebase_auth_service.dart';
import '../widgets/authentication/navigationtoteamlist.dart';
import '../widgets/dashboard/action_buttons.dart';
import '../widgets/tasks/task_list.dart';
import '../widgets/tasks/task_progress.dart';


class DashboardPage extends StatefulWidget {
  DashboardPage({super.key}){
    Get.put(TaskService());
    Get.put(TeamService());
  }

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {

  @override
  void initState() {
    NotificationService().requestIOSPermissions();
    NotificationService().requestAndroidPermissions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Dashboard'),
        actions: [
          IconButton(
            onPressed: () => FirebaseAuthService().signOut(),
            icon: const Icon(Icons.logout_rounded),
          )
        ],
      ),
      drawer:  HomeScreenDrawer(),
      body: RefreshIndicator(
        onRefresh: () async {
          await Get.find<TaskService>().fetchTasks();
          await Get.find<TeamService>().fetchTeams();
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
