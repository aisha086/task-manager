import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_manager/widgets/toast.dart';

import '../models/task.dart';

class TaskService extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference taskCollection =
  FirebaseFirestore.instance.collection('tasks');

  // Observable list for tasks
  RxList<Task> tasks = <Task>[].obs;
  RxInt completed = 0.obs;
  RxInt pending = 0.obs;

  @override
  void onInit() {
    fetchTasks();
    super.onInit();
  }

  // Add a new task
  Future<String> addTask(Task task) async {
    try {
      DocumentReference docRef = await taskCollection.add(task.toMap());
      await fetchTasks();
      showToast("Success Task added!");
      return docRef.id;
    } on Exception catch (e) {
      showToast("Error Occurred $e");
      print(e);
      return "Error Occurred";
    }
// Return the generated task ID
  }

  // Fetch tasks for the current user (top 5, sorted by due date)
  Future<void> fetchTasks() async {
    try{
      print("fetching");
      String currentUserId = _auth.currentUser!.uid;
      print(currentUserId);
      QuerySnapshot snapshot = await taskCollection
          .where('userId', isEqualTo: currentUserId) // Fetch tasks by userId
          .get();

      tasks.assignAll(snapshot.docs.map((doc) {
        return Task.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList());

      tasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
      await calculatePendingAndCompletedTasks();
      print("fetched");
      print(tasks.length);
    }
    catch(e){
      print("fetch");
      print(e);
      showToast("An error occurred: $e");
    }
  }

  // Update task by ID
  Future<void> updateTask(String taskId, Task task) async {
    try {
      print("updating");
      await taskCollection.doc(taskId).update(task.toMap());
      await fetchTasks();
      showToast("Success: Task updated");
      print("updated");
    } on Exception catch (e) {
      print("An error occurred: $e");
      showToast("An error occurred: $e");
    }
  }

  // Delete task by ID
  Future<void> deleteTask(String taskId) async {
    try {
      await taskCollection.doc(taskId).delete();
      await fetchTasks();
      showToast("Success Task deleted");

    } on Exception catch (e) {
      showToast("An error occurred: $e");
    }
  }

  // Method to mark a task as completed
  Future<void> markTaskAsCompleted(String taskId) async {
    try {
      await taskCollection.doc(taskId).update({'isCompleted': true});
      await fetchTasks(); // Refresh the task list
      showToast("Task marked as completed!");
    } on Exception catch (e) {
      showToast("An error occurred: $e");
    }
  }


  // Method to calculate pending and completed tasks
  calculatePendingAndCompletedTasks() async {

    int completedCount = 0;
    int pendingCount = 0;

    for (var task in tasks) {
      if (task.isCompleted) {
        completedCount++;
      } else {
        pendingCount++;
      }
    }

    completed.value = completedCount;
    pending.value = pendingCount;

  }
}
