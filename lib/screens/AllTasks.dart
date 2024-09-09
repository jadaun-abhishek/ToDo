import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Controller/TaskController.dart';
import '../Model/Task.dart';
import '../Themes.dart';
import '../customWidgets/TaskTile.dart';
import 'AddTask.dart';

class AllTasks extends StatefulWidget {
  const AllTasks({super.key});

  @override
  State<AllTasks> createState() => _AllTasksState();
}

class _AllTasksState extends State<AllTasks> {
  final TaskController _taskController = Get.put(TaskController());
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.theme.scaffoldBackgroundColor,
        title: Text('All Task'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  filled: true,
                  fillColor: Get.isDarkMode ? tileDarkColor : Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Get.isDarkMode ? Colors.white : Colors.black,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.filter_list,
                      color: Get.isDarkMode ? Colors.white : Colors.black,
                    ),
                    onPressed: () {
                      _displayFilterSheet();
                    },
                  ),
                ),
                onChanged: (query) {
                  _searchTasks(query);
                },
              ),
            ),
          ),
          SizedBox(height: 20),
          _isSearching ? _displaySearchResults() : _showTasks(),
        ],
      ),
    );
  }

  // Show all tasks
  Widget _showTasks() {
    return Expanded(
      child: Obx(() {
        var tasksToShow = _taskController.taskList;
        if (tasksToShow.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(image: AssetImage('assets/images/emptyPage.png')),
                Text('What do you want to do today?'),
                SizedBox(height: 10),
                Text('Tap + to add your tasks',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          );
        }
        return ListView.builder(
          itemCount: tasksToShow.length,
          itemBuilder: (_, index) {
            Task task = tasksToShow[index];
            return AnimationConfiguration.staggeredList(
              position: index,
              child: SlideAnimation(
                child: FadeInAnimation(
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          _editTaskSheet(context, task);
                        },
                        child: Tasktile(task),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  // Edit/Update the task
  void _editTaskSheet(BuildContext context, Task task) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.only(top: 4),
        width: MediaQuery.of(context).size.width,
        height: task.isCompleted == 1
            ? MediaQuery.of(context).size.height * 0.36
            : MediaQuery.of(context).size.height * 0.36,
        color: Get.isDarkMode ? darkGreyClr : Colors.white,
        child: Column(
          children: [
            Container(
              height: 6,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300],
              ),
            ),
            Spacer(),
            task.isCompleted == 1
                ? _editTaskSheetButton(
                    label: 'Mark as Incomplete',
                    onTap: () {
                      _taskController.markTaskIncomplete(task.id!);
                      Get.back();
                    },
                    color: Colors.yellow[800]!,
                    context: context,
                  )
                : _editTaskSheetButton(
                    label: 'Mark as Completed',
                    onTap: () {
                      _taskController.markTaskCompleted(task.id!);
                      Get.back();
                    },
                    color: Colors.green,
                    context: context,
                  ),
            _editTaskSheetButton(
              label: 'Update Task',
              onTap: () {
                Get.to(() => AddTask(task: task));
              },
              color: primaryClr,
              context: context,
            ),
            _editTaskSheetButton(
              label: 'Delete Task',
              onTap: () {
                _taskController.delete(task);
                Get.back();
              },
              color: Colors.red,
              context: context,
            ),
            SizedBox(height: 20),
            _editTaskSheetButton(
              label: 'Close',
              onTap: () {
                Get.back();
              },
              color: Colors.red,
              isClose: true,
              context: context,
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Edit/Update task sheet button
  Widget _editTaskSheetButton({
    required String label,
    required Function() onTap,
    required Color color,
    bool isClose = false,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        height: 55,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: isClose
                ? (Get.isDarkMode ? Colors.grey[600]! : Colors.grey[300]!)
                : color,
          ),
          borderRadius: BorderRadius.circular(20),
          color: isClose ? Colors.transparent : color,
        ),
        child: Center(
          child: Text(
            label,
            style:
                isClose ? titleStyle : titleStyle.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }

  // Search tasks
  void _searchTasks(String query) {
    setState(() {
      _isSearching = query.isNotEmpty;
    });
    _taskController.searchQuery.value = query;
  }

  // Display searched result
  Widget _displaySearchResults() {
    return Expanded(
      child: Obx(() {
        List<Task> tasksToShow = _taskController.filteredTasks;

        if (tasksToShow.isEmpty) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/emptyPage.png'),
              const Text('No tasks found for your search.'),
              const SizedBox(height: 10),
              const Text('Try a different search term.',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          );
        }

        return ListView.builder(
          itemCount: tasksToShow.length,
          itemBuilder: (_, index) {
            Task task = tasksToShow[index];
            return AnimationConfiguration.staggeredList(
              position: index,
              child: SlideAnimation(
                child: FadeInAnimation(
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          _editTaskSheet(context, task);
                        },
                        child: Tasktile(task),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  // Show filter sheet for priority
  void _displayFilterSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Filter by Priority',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                SizedBox(height: 16.0),
                TextButton(
                  onPressed: () async {
                    _taskController.filterTasksByPriority('high');
                    // Setting the priority status sharedPreferences
                    final prefs = await SharedPreferences.getInstance();
                    prefs.setString("priorityUser", 'highFilter');
                    Get.back();
                  },
                  child: Text('High to Low'),
                ),
                TextButton(
                  onPressed: () async {
                    _taskController.filterTasksByPriority('low');
                    // Setting the priority status sharedPreferences
                    final prefs = await SharedPreferences.getInstance();
                    prefs.setString("priorityUser", 'lowFilter');
                    Get.back();
                  },
                  child: Text('Low to High'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
