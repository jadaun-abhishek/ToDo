import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'package:todo/Controller/TaskController.dart';
import 'package:todo/Model/Task.dart';
import 'package:todo/View/Constants/Themes.dart';
import 'package:todo/View/customWidgets/TaskTile.dart';
import 'AddTask.dart';

class CompletedTask extends StatefulWidget {
  const CompletedTask({super.key});

  @override
  State<CompletedTask> createState() => _CompletedTaskState();
}

class _CompletedTaskState extends State<CompletedTask> {
  TaskController _taskController = Get.put(TaskController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // access to the widget theme data associated with the current widget's location
          backgroundColor: context.theme.scaffoldBackgroundColor,
          title: Text('Completed Task'),
        ),
        body: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            _showTasks(),
          ],
        ));
  }

  // Show all tasks
  _showTasks() {
    return Expanded(
      child: Obx(() {
        // Filter completed tasks
        var completedTasks = _taskController.taskList
            .where((task) => task.isCompleted == 1)
            .toList();

        if (completedTasks.isEmpty) {
          // Handle case where task list is null or empty
          return Center(
            child: Column(
              children: [
                Image(
                  image: AssetImage('assets/images/emptyPage.png'),
                ),
                Text('What do you want to do today?'),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Tap + to add your tasks',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: completedTasks.length,
          itemBuilder: (_, index) {
            Task task = completedTasks[index];
            print(task.isCompleted);
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
  _editTaskSheet(BuildContext context, Task task) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.only(top: 4),
        width: MediaQuery.of(context).size.width * 100,
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
                Get.to(
                  () => AddTask(task: task),
                ); // Navigate to AddTask page with task data
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
            SizedBox(
              height: 20,
            ),
            _editTaskSheetButton(
              label: 'Close',
              onTap: () {
                Get.back();
              },
              color: Colors.red,
              isClose: true,
              context: context,
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  // Edit/Update task sheet button
  _editTaskSheetButton(
      {required String label,
      required Function() onTap,
      required Color color,
      bool isClose = false,
      required BuildContext context}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        height: 55,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: isClose == true
                ? Get.isDarkMode
                    ? Colors.grey[600]!
                    : Colors.grey[300]!
                : color,
          ),
          borderRadius: BorderRadius.circular(20),
          color: isClose == true ? Colors.transparent : color,
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
}
