import 'package:get/get.dart';
import 'package:todo/DbHelper/DbHelper.dart';

import '../Model/Task.dart';

// Getx to show the changes in the current running state without restarting the app
class TaskController extends GetxController {
  @override
  void onReady() {
    getTasks();
    super.onReady();
  }

  // List of all tasks variable observable (whenever data changes UI will be updated - obs)
  var taskList = <Task>[].obs;

  // RxString automatically updates the UI, when data is changed.
  RxString searchQuery = ''.obs;

  // Filter the query
  List<Task> get filteredTasks {
    if (searchQuery.value.isEmpty) {
      return taskList;
    } else {
      return taskList.where((task) {
        final query = searchQuery.value.toLowerCase();
        final title = task.title?.toLowerCase() ?? '';
        final description = task.description?.toLowerCase() ?? '';
        return title.contains(query) || description.contains(query);
      }).toList();
    }
  }

  // Insert the task
  Future<int> addTask(Task? task) async {
    final result = await DbHelper.insert(task);
    getTasks();
    return result;
  }

  // Get all the tasks
  void getTasks() async {
    List<Map<String, dynamic>> tasks = await DbHelper.query();
    taskList.assignAll(tasks.map((data) => Task.fromJson(data)).toList());
  }

  // Delete the task
  Future<void> delete(Task task) async {
    await DbHelper.delete(task);
    getTasks(); // Refresh task list after deleting a task
  }

  // Update task status to complete
  void markTaskCompleted(int id) async {
    await DbHelper.updateTaskStatus(id);
    getTasks();
  }

  // Update task status to incomplete
  void markTaskIncomplete(int id) async {
    await DbHelper.updateTaskStatusIncomplete(id);
    getTasks();
  }

  // Update the tasks
  Future<void> updateTask(Task task) async {
    await DbHelper.update(task);
    getTasks(); // Refresh task list after updating a task
  }

  // Method to filter tasks based on priority
  void filterTasksByPriority(String priorityString) {
    List<Task> highPriorityTasks =
        taskList.where((task) => task.priority == 2).toList();
    List<Task> mediumPriorityTasks =
        taskList.where((task) => task.priority == 1).toList();
    List<Task> lowPriorityTasks =
        taskList.where((task) => task.priority == 0).toList();

    if (priorityString == 'high') {
      // Concatenate the lists in descending order of priority
      taskList.value =
          highPriorityTasks + mediumPriorityTasks + lowPriorityTasks;
    } else if (priorityString == 'low') {
      // Concatenate the lists in ascending order of priority
      taskList.value =
          lowPriorityTasks + mediumPriorityTasks + highPriorityTasks;
    }
  }
}
