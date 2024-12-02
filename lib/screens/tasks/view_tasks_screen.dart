import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../databases/task_service.dart';
import '../../models/task.dart';
import '../../widgets/tasks/task_tile.dart';

class ViewTaskListScreen extends StatefulWidget {
  const ViewTaskListScreen({super.key});

  @override
  State<ViewTaskListScreen> createState() => _ViewTaskListScreenState();
}

class _ViewTaskListScreenState extends State<ViewTaskListScreen> {
  final TaskService taskService = Get.find();

  final RxList<Task> filteredTasks = RxList<Task>();
  // For dynamic filtering
  final RxString activeFilter = 'all'.obs;
  // 'all', 'pending', or 'completed'
  final RxString sortBy = ''.obs;
  // 'dueDate' or 'priority'

  @override
  void initState() {
    // Watch for changes to activeFilter and sortBy
    ever(activeFilter, (_) => updateTasks());
    ever(sortBy, (_) => updateTasks());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Initial state for filteredTasks
    filteredTasks.assignAll(taskService.tasks);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Task List"),
        actions: [
          // Sort dropdown in AppBar
          Obx(() {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: DropdownButton<String>(
                value: sortBy.value.isEmpty ? null : sortBy.value,
                hint: const Text("Sort By"),
                items: const [
                  DropdownMenuItem(value: 'dueDate', child: Text("Due Date")),
                  DropdownMenuItem(value: 'priority', child: Text("Priority")),
                ],
                onChanged: (value) {
                  sortBy.value = value ?? '';
                },
              ),
            );
          }),
        ],
      ),
      body: Obx(() {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                spacing: 8.0,
                children: [
                  _buildFilterChip("All", "all"),
                  _buildFilterChip("Pending", "pending"),
                  _buildFilterChip("Completed", "completed"),
                ],
              ),
            ),
            Expanded(
                child: (taskService.tasks.isEmpty)
                    ? const Center(child: Text("No tasks available."))
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: ListView.builder(
                          itemCount: filteredTasks.length,
                          itemBuilder: (context, index) {
                            final task = filteredTasks[index];
                            return TaskTile(
                                task: task); // Reusing TaskTile widget
                          },
                        ),
                      )),
          ],
        );
      }),
    );
  }

  // Update the filtered tasks whenever activeFilter changes
  updateTasks() {
    List<Task> tasks = taskService.tasks;

    // Apply filter
    if (activeFilter.value == 'pending') {
      tasks = tasks.where((task) => !task.isCompleted).toList();
    } else if (activeFilter.value == 'completed') {
      tasks = tasks.where((task) => task.isCompleted).toList();
    }

    // Apply sorting
    if (sortBy.value == 'dueDate') {
      tasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    } else if (sortBy.value == 'priority') {
      const priorityOrder = {'High': 1, 'Medium': 2, 'Low': 3};
      tasks.sort((a, b) {

        //The function returns 1, which tells the sorting algorithm to move a after b (put completed tasks later).
        if (a.isCompleted && !b.isCompleted) return 1;

        //The function returns -1, which tells the sorting algorithm to move a before b (put pending tasks earlier).
        if (!a.isCompleted && b.isCompleted) return -1;

        // Sort by priority for pending tasks
        return priorityOrder[a.priority]!.compareTo(priorityOrder[b.priority]!);
      });
    }

    filteredTasks.assignAll(tasks);
  }

  Widget _buildFilterChip(String label, String value) {
    return Obx(() {
      return FilterChip(
        label: Text(label),
        selected: activeFilter.value == value,
        onSelected: (selected) {
          if (selected) {
            activeFilter.value = value;
          }
        },
      );
    });
  }
}
