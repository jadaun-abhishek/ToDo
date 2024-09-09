import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo/Controller/TaskController.dart';
import 'package:todo/Model/Task.dart';
import 'package:todo/View/Constants/Themes.dart';
import 'package:get/get.dart';
import 'package:todo/View/customWidgets/Button.dart';

class AddTask extends StatefulWidget {
  // field to accept a task for editing
  final Task? task;

  const AddTask({super.key, this.task});

  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  // Controller for calling the TaskController method
  TaskController _taskController = Get.put(TaskController());

  // Set the current date/time
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _startTime = TimeOfDay.now();

  // Repeat the reminder option
  String _selectedRepeat = 'None';
  List<String> repeatList = [
    'None',
    'Daily',
  ];

  // Color priorities
  int _selectedColor = 0;
  Color highPriority = Colors.red[800]!;
  Color mediumPriority = Colors.orange[800]!;
  Color lowPriority = Colors.yellow[800]!;

  // Controllers for form fields
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Initialize fields if a task is provided for editing
    if (widget.task != null) {
      _titleController.text = widget.task!.title ?? '';
      _descriptionController.text = widget.task!.description ?? '';
      _dateController.text = widget.task!.date ?? '';
      _startTimeController.text = widget.task!.startTime ?? '';
      _selectedDate = DateFormat.yMd()
          .parse(widget.task!.date ?? DateFormat.yMd().format(DateTime.now()));
      _startTime = _parseTime(widget.task!.startTime ?? '');
      _selectedColor = widget.task!.priority ?? 0;
      _selectedRepeat = widget.task!.repeat ?? 'None';
    } else {
      // Set default values if no task is provided
      _dateController.text = DateFormat.yMMMd().format(_selectedDate);
      _startTimeController.text = _formatTimeOfDay(_startTime);
    }
  }

  TimeOfDay _parseTime(String timeString) {
    final time = DateFormat.jm().parse(timeString);
    return TimeOfDay(hour: time.hour, minute: time.minute);
  }

  // Widget to select the date and update value in textField
  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2050),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _dateController.text = DateFormat.yMMMd().format(_selectedDate);
      });
    }
  }

  // Select the start time
  Future<void> _selectStartTime(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _startTime,
    );

    if (pickedTime != null && pickedTime != _startTime) {
      setState(() {
        _startTime = pickedTime;
        _startTimeController.text = _formatTimeOfDay(_startTime);
      });
    }
  }

  // Function to format the time
  String _formatTimeOfDay(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat.jm().format(dt);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // access to the widget theme data associated with the current widget's location
        backgroundColor: context.theme.scaffoldBackgroundColor,
        title: Text(widget.task == null ? 'Add Task' : 'Edit Task'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Text('Title', style: titleStyle),
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  hintText: "Enter title here",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              Text('Description', style: titleStyle),
              TextField(
                controller: _descriptionController,
                maxLines: 3,
                maxLength: 100,
                decoration: const InputDecoration(
                  hintText: "Enter description here",
                  border: OutlineInputBorder(),
                ),
              ),
              Text('Date', style: titleStyle),
              TextField(
                controller: _dateController,
                readOnly: true,
                onTap: () => _selectDate(context),
                decoration: InputDecoration(
                  suffixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              Text('Start Time', style: titleStyle),
              TextField(
                controller: _startTimeController,
                readOnly: true,
                onTap: () => _selectStartTime(context),
                decoration: InputDecoration(
                  hintText: 'Select Start Time',
                  suffixIcon: Icon(Icons.access_time),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              Text('Repeat', style: titleStyle),
              DropdownButtonFormField<String>(
                value: _selectedRepeat,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedRepeat = newValue!;
                  });
                },
                items: repeatList.map((String repeatOption) {
                  return DropdownMenuItem<String>(
                    value: repeatOption,
                    child: Text(repeatOption),
                  );
                }).toList(),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              _priorityState(),
              SizedBox(
                height: 50,
              ),
              MyButton(
                label: widget.task == null ? 'Create Task' : 'Update Task',
                onTap: () {
                  _validateData();
                },
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _priorityState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Text('Priority', style: titleStyle),
        Wrap(
          children: List<Widget>.generate(3, (int index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedColor = index;
                  print(_selectedColor);
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: index == 0
                      ? lowPriority
                      : index == 1
                          ? mediumPriority
                          : highPriority,
                  child: _selectedColor == index
                      ? Icon(
                          Icons.done,
                          color: Colors.white,
                          size: 16,
                        )
                      : Container(),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  // Validate the user-entered data and pass to DB
  _validateData() {
    if (_titleController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty) {
      _saveTaskToDb();
    } else {
      Get.snackbar(
        "Required",
        "All fields are mandatory",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: pinkClr,
        icon: Icon(
          Icons.warning_amber_rounded,
          color: Colors.red,
        ),
      );
    }
  }

  // Send data to controller
  _saveTaskToDb() async {
    final task = Task(
      _titleController.text,
      _descriptionController.text,
      0,
      DateFormat.yMd().format(_selectedDate),
      _formatTimeOfDay(_startTime),
      _selectedColor,
      _selectedRepeat,
    );

    // To check task contains data
    if (widget.task == null) {
      // Add new task
      await _taskController.addTask(task);
      _taskController.getTasks();
    } else {
      // Update existing task
      task.id = widget.task!.id; // Ensure the ID is set
      await _taskController.updateTask(task);
      _taskController.getTasks();
    }

    Get.back();
  }
}
