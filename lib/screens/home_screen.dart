import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/databases/task_service.dart';
import 'package:task_manager/screens/settings.dart';
import 'package:task_manager/screens/tasks/add_task_screen.dart';
import 'package:task_manager/screens/tasks/view_tasks_screen.dart';
import 'package:task_manager/screens/chat/chat_screen_main.dart';

import '../services/firebase_auth_service.dart';
import '../widgets/authentication/navigationtoteamlist.dart';
import '../widgets/dashboard/action_buttons.dart';
import '../widgets/tasks/task_list.dart';
import '../widgets/tasks/task_progress.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const DashboardPage(), // Home Dashboard
    const Placeholder(), // Placeholder for Teams (handled in onTap)
    ChatScreen(teamId: 'O2F2gzy1Ia3RXcaQeIVl'), // Chat Page
    const SettingsPage(), // Settings Page
  ];



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
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 1) {
            // Handle Teams navigation separately
            navigateToTeamsListScreen(context);
          } else {
            // Change the index for other tabs
            setState(() {
              _currentIndex = index;
            });
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Teams',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
      ),
    );
  }
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
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
    );
  }
}
