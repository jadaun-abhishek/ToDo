import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/Controller/TaskController.dart';
import 'package:todo/Themes.dart';
import 'package:todo/customWidgets/TaskTile.dart';
import 'package:todo/screens/AddTask.dart';
import 'package:todo/screens/AllTasks.dart';
import 'package:todo/screens/CompletedTask.dart';
import 'package:todo/service/notificationService.dart';
import 'package:todo/service/themeService.dart';
import 'package:get/get.dart';
import '../Model/Task.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Themes themes = Themes();
  DateTime _selectedDate = DateTime.now();
  var notifyHelper;
  final TaskController _taskController = Get.put(TaskController());
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    // Setting the onboarding status
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("onboarding", true);

    // setting up notifications
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          _addTaskBar(),
          const SizedBox(height: 10),
          _allAndCompletedTasks(),
          _addDateBar(),
          const SizedBox(height: 20),
          _isSearching ? _displaySearchResults() : _showTasks(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.to(const AddTask());
        },
        backgroundColor: primaryClr,
        label: const Text("Add Task", style: TextStyle(color: Colors.white)),
        icon: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // App Bar design
  _appBar() {
    return AppBar(
      // to remove the back button
      automaticallyImplyLeading: false,
      backgroundColor: context.theme.scaffoldBackgroundColor,
      title: SizedBox(
        width: MediaQuery.of(context).size.width * 100, // Adjusted width
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
          ),
          onChanged: (query) {
            _searchTasks(query); // Update search state and query
          },
        ),
      ),
    );
  }

  // Add the Task
  _addTaskBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat.yMMMMd().format(DateTime.now()),
                style: subHeadingStyle,
              ),
              Text(
                'Today',
                style: headingStyle,
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              ThemeService().switchTheme();
              notifyHelper.displayNotification(
                title: "Theme changed",
                body: Get.isDarkMode
                    ? "Activated Light Theme"
                    : "Activated Dark Theme",
              );
            },
            child: Icon(
              Get.isDarkMode ? Icons.wb_sunny_outlined : Icons.nightlight_round,
              size: 30,
              color: Get.isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  // show all tasks and completed tasks
  _allAndCompletedTasks() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => {
              Get.to(() => const AllTasks()),
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.43,
              height: MediaQuery.of(context).size.height * 0.06,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[600],
              ),
              child: const Center(
                child: Text(
                  'All Tasks',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => {
              Get.to(() => const CompletedTask()),
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.43,
              height: MediaQuery.of(context).size.height * 0.06,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.green,
              ),
              child: const Center(
                child: Text(
                  'Completed',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  // Date Picker
  _addDateBar() {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 20),
      child: DatePicker(
        DateTime.now(),
        height: 100,
        width: 80,
        initialSelectedDate: DateTime.now(),
        selectionColor: primaryClr,
        selectedTextColor: Colors.white,
        monthTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
            fontSize: 12,
            color: Get.isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        dayTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
            fontSize: 12,
            color: Get.isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        dateTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w400,
            color: Colors.grey,
          ),
        ),
        onDateChange: (date) {
          setState(() {
            _selectedDate = date;
          });
        },
      ),
    );
  }

  // Show all tasks
  _showTasks() {
    return Expanded(
      child: Obx(() {
        if (_taskController.taskList.isEmpty) {
          return Center(
            child: Column(
              children: [
                Image.asset('assets/images/emptyPage.png'),
                const Text('What do you want to do today?'),
                const SizedBox(height: 10),
                const Text('Tap + to add your tasks',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: _taskController.taskList.length,
          itemBuilder: (_, index) {
            Task task = _taskController.taskList[index];
            if (task.repeat == 'Daily') {
              _showPushNotification(task);
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
            }

            _compareDates(task, _selectedDate);

            if (task.date == DateFormat.yMd().format(_selectedDate)) {
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
            } else {
              return Container();
            }
          },
        );
      }),
    );
  }

  _compareDates(Task task, DateTime selectedDate) {
    final DateFormat formatter = DateFormat('M/d/yyyy');

    String formattedTaskDate = task.date ?? '';
    String formattedSelectedDate = formatter.format(selectedDate);

    if (formattedTaskDate == formattedSelectedDate) {
      _showPushNotification(task);
    }
  }

  // Method to push scheduleNotifications
  _showPushNotification(Task task) {
    DateTime date = DateFormat.jm().parse(task.startTime.toString());
    var myTime = DateFormat('HH:mm').format(date);
    notifyHelper.scheduledNotification(
        int.parse(myTime.toString().split(':')[0]),
        int.parse(myTime.toString().split(':')[1]),
        task);
  }

  // Edit/Update the task
  _editTaskSheet(BuildContext context, Task task) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.only(top: 4),
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
            const Spacer(),
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
            const SizedBox(
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
            const SizedBox(
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
        margin: const EdgeInsets.symmetric(vertical: 4),
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

  // search tasks
  void _searchTasks(String query) {
    setState(() {
      _isSearching = query.isNotEmpty;
    });
    _taskController.searchQuery.value = query;
  }

  // Display searched result
  _displaySearchResults() {
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
            if (task.repeat == 'Daily') {
              _showPushNotification(task);
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
            }

            _compareDates(task, _selectedDate);

            if (task.date == DateFormat.yMd().format(_selectedDate)) {
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
            } else {
              return Container();
            }
          },
        );
      }),
    );
  }
}
