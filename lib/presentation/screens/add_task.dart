// ignore_for_file: prefer_const_constructors

// External Packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

// Core Packages
import 'package:flutter/material.dart';

// App Files
import 'package:my_todo_app/bloc/task/task_cubit.dart';
import 'package:my_todo_app/presentation/widgets/mytextfield.dart';
import 'package:my_todo_app/data/models/task_model.dart';
import 'package:my_todo_app/data/repositories/firestore_cloud.dart';
import 'package:my_todo_app/presentation/widgets/mybutton.dart';

// Global variables
int _selectedReminder = 5;
int _selectedColor = 2;

class AddTaskScreen extends StatefulWidget {
  final TaskModel? task;
  AddTaskScreen({Key? key, this.task}) : super(key: key);

  static String routeName = "Add Task Screen";

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  bool get isEdit => widget.task != null;
  // controllers
  late TextEditingController _titleController;
  late TextEditingController _noteController;
  late TextEditingController _dateController;
  late TextEditingController _startTimeController;
  late TextEditingController _endTimeController;
  late TextEditingController _reminderController;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final User? _user = FirebaseAuth.instance.currentUser;

  // variables
  DateTime? currnetDilogDate;
  DateTime? selectedDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  // Lists
  List<DropdownMenuItem<int>> menuItems = const [
    DropdownMenuItem(
        child: Text(
          "5 Min Earlier",
        ),
        value: 5),
    DropdownMenuItem(
        child: Text(
          "10 Min Earlier",
        ),
        value: 10),
    DropdownMenuItem(
        child: Text(
          "15 Min Earlier",
        ),
        value: 15),
    DropdownMenuItem(
        child: Text(
          "20 Min Earlier",
        ),
        value: 20),
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _noteController = TextEditingController();
    _dateController = TextEditingController();
    _startTimeController = TextEditingController();
    _endTimeController = TextEditingController();
    _reminderController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _noteController.dispose();
    _dateController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    _reminderController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("rebuild add task screen");
    var taskCubit = TaskCubit.get(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Add Task",
          style: Theme.of(context).textTheme.headline1,
        ),
        centerTitle: true,
        elevation: 0.0,
        leading: IconButton(
          onPressed: () {
            _selectedReminder = 5;
            _selectedColor = 2;
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          /// try use this line
          // heightFactor: 3,
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(
              top: 10.0,
              left: 20.0,
              right: 20.0,
              bottom: 20.0,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisSize: MainAxisSize.min,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _BuildTitleText(
                    title: "Title",
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  MyTextfield(
                    hint: "Enter Title",
                    icon: Icons.abc,
                    showPrefixIcon: false,
                    validator: (title) {
                      if (title != null && title.length < 2) {
                        return "Enter The Title";
                      }
                      return null;
                    },
                    controller: _titleController,
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  _BuildTitleText(title: "Note"),
                  SizedBox(
                    height: 1.h,
                  ),
                  MyTextfield(
                    hint: "Enter Note",
                    icon: Icons.abc,
                    showPrefixIcon: false,
                    maxlenght: 40,
                    validator: (_) {
                      return null;
                    },
                    controller: _noteController,
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  _BuildTitleText(title: "Date"),
                  SizedBox(
                    height: 1.h,
                  ),
                  MyTextfield(
                    hint:
                        DateFormat("dd-MM-yyyy").format(taskCubit.selectedDate),
                    icon: Icons.calendar_month_outlined,
                    suffixIcon: Icons.calendar_month_outlined,
                    showSuffixIcon: true,
                    showPrefixIcon: false,
                    readonly: true,
                    validator: (_) {
                      return null;
                    },
                    ontap: () => _buildShowDatePicker(context, taskCubit),
                    controller: _dateController,
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Row(
                    children: [
                      BuildTimeColumn(
                        title: "Start Time",
                        controller: _startTimeController,
                      ),
                      SizedBox(
                        width: 3.w,
                      ),
                      BuildTimeColumn(
                        title: "End Time",
                        controller: _endTimeController,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  _BuildTitleText(title: "Reminder"),
                  SizedBox(
                    height: 1.h,
                  ),
                  _BuildDropdownButtonFormField(menuItems: menuItems),
                  SizedBox(
                    height: 2.h,
                  ),
                  _BuildTitleText(title: "title"),
                  SizedBox(
                    height: 1.h,
                  ),
                  Row(
                    children: [
                      BuildColorsRow(),
                      Spacer(),
                      MyButton(
                          color: Colors.deepPurple,
                          width: 40.w,
                          title: widget.task==null? "Create Task":"Update Task",
                          onPress: () => _addTask(taskCubit)),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helpers Methods

  void _addTask(TaskCubit taskCubit) {
    if (_formKey.currentState!.validate()) {
      print("it is valide");
      print("date controller ${_dateController.text}");
      var newTask = TaskModel(
        title: _titleController.text,
        note: _noteController.text,
        date: _dateController.text == ""
            ? DateFormat("dd-MM-yyyy").format(taskCubit.selectedDate)
            : _dateController.text,
        startTime: _startTimeController.text,
        endTime: _endTimeController.text,
        reminder: _selectedReminder,
        colorIndex: _selectedColor,
        id: "",
      );

      var _firestore = FirestoreCloud();
      isEdit ? _firestore.updateTask(
        user: _user,
        docId: widget.task!.id,
        title: _titleController.text,
        note: _noteController.text,
        date: _dateController.text == ""
            ? DateFormat("dd-MM-yyyy").format(taskCubit.selectedDate)
            : _dateController.text,
        startTime: _startTimeController.text,
        endTime: _endTimeController.text,
        reminder: _selectedReminder,
        colorIndex: _selectedColor,
      )

      :_firestore.addTask(user: _user ,task: newTask).then((_) {
        _selectedReminder = 5;
        _selectedColor = 2;
        Navigator.pop(context);
      }).catchError((onError) {
        print("the error is : $onError");
      });
    }
  }

  void _buildShowDatePicker(BuildContext context, TaskCubit taskCubit) async {
    selectedDate = await showDatePicker(
      context: context,
      initialDate: currnetDilogDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2200),
      currentDate: DateTime.now(),
    );
    currnetDilogDate = selectedDate;
    _dateController.text =
        DateFormat("dd-MM-yyyy").format(selectedDate ?? taskCubit.selectedDate);
  }
}

/// Builders Widgets

// state less widgets

class _BuildTitleText extends StatelessWidget {
  const _BuildTitleText({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.headline1!.copyWith(fontSize: 12.sp),
    );
  }
}

class BuildTimeColumn extends StatelessWidget {
  BuildTimeColumn({
    Key? key,
    required this.title,
    required this.controller,
  }) : super(key: key);

  final TextEditingController controller;
  final String title;

  TimeOfDay? selectedTime;

  @override
  Widget build(context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _BuildTitleText(title: title),
          SizedBox(height: 1.h),
          MyTextfield(
            hint: DateFormat("hh:mm aa").format(DateTime.now()),
            icon: Icons.watch,
            suffixIcon: Icons.watch,
            readonly: true,
            showPrefixIcon: false,
            showSuffixIcon: true,
            validator: (_) {
              return null;
            },
            controller: controller,
            ontap: () async {
              selectedTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              controller.text = DateFormat("hh:mm aa").format(DateTime(
                0,
                0,
                0,
                selectedTime!.hour,
                selectedTime!.minute,
              ));
            },
          )
        ],
      ),
    );
  }
}

// state ful widgets

class BuildColorsRow extends StatefulWidget {
  const BuildColorsRow({
    Key? key,
  }) : super(key: key);

  @override
  State<BuildColorsRow> createState() => _BuildColorsRowState();
}

class _BuildColorsRowState extends State<BuildColorsRow> {
  List colors = [
    Colors.red,
    Colors.amber,
    Colors.cyanAccent,
  ];
  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(3, (index) {
        return Padding(
          padding: EdgeInsets.only(right: 1.0.h),
          child: InkWell(
            child: CircleAvatar(
              backgroundColor: colors[index],
              child: index == _selectedColor
                  ? Icon(
                      Icons.done,
                      color: Colors.white,
                    )
                  : null,
            ),
            onTap: () {
              setState(() {
                _selectedColor = index;
              });
            },
          ),
        );
      }),
    );
  }
}

class _BuildDropdownButtonFormField extends StatefulWidget {
  _BuildDropdownButtonFormField({
    Key? key,
    required this.menuItems,
  }) : super(key: key);

  final List<DropdownMenuItem<int>> menuItems;

  @override
  State<_BuildDropdownButtonFormField> createState() =>
      _BuildDropdownButtonFormFieldState();
}

class _BuildDropdownButtonFormFieldState
    extends State<_BuildDropdownButtonFormField> {
  @override
  Widget build(BuildContext context) {
    print("rebuild DropdownButtonFormField ");
    print("the select value is $_selectedReminder");
    return DropdownButtonFormField<int>(
        value: _selectedReminder,
        items: widget.menuItems,
        style: Theme.of(context)
            .textTheme
            .headline1!
            .copyWith(fontSize: 14.sp, color: Colors.deepPurple),
        icon: Icon(Icons.arrow_drop_down_circle_outlined),
        decoration: InputDecoration(
          fillColor: Colors.grey.shade200,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: Colors.grey.shade200,
              width: 0,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
        ),
        onChanged: (int? value) {
          setState(() {
            _selectedReminder = value!;
          });
        });
  }
}
