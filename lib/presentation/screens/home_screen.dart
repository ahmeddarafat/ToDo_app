// ignore_for_file: prefer_const_constructors

//external packages
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:my_todo_app/presentation/screens/signup_screen.dart';
import 'package:sizer/sizer.dart';
import 'package:firebase_auth/firebase_auth.dart';

// core packages
import 'dart:async';
import 'package:flutter/material.dart';

// app files
import 'package:my_todo_app/bloc/connectivity/connectivity_cubit.dart';
import 'package:my_todo_app/bloc/task/task_cubit.dart';
import 'package:my_todo_app/data/models/task_model.dart';
import 'package:my_todo_app/data/repositories/firestore_cloud.dart';
import 'package:my_todo_app/presentation/screens/add_task.dart';
import 'package:my_todo_app/presentation/screens/welcome_screen_clone.dart';
import 'package:my_todo_app/presentation/widgets/mytextfield.dart';
import 'package:my_todo_app/presentation/widgets/task_container.dart';
import 'package:my_todo_app/Shared/constants/assets_path.dart';
import 'package:my_todo_app/presentation/widgets/mybutton.dart';
import '../../bloc/auth/authentication_cubit.dart';

// Globle variables
List profilesPhoto = [
  MyAssets.profileIcon1,
  MyAssets.profileIcon2,
  MyAssets.profileIcon3,
  MyAssets.profileIcon4,
];

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  static String routeName = 'Home Screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late TextEditingController _nameController;
  late Stream snapshots;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _firestore = FirestoreCloud();
  static final User? _user = FirebaseAuth.instance.currentUser;
  static String username = _user!.isAnonymous ? 'Anonymous' : 'User';
  String displayName = _user!.displayName ?? username;

 

  List colors = [
    Colors.red,
    Colors.orange,
    Colors.blue,
  ];

  @override
  void initState() {
    super.initState();


    _nameController = TextEditingController(
      text: displayName,
    );
  }

  @override
  void dispose() {
    super.dispose();

    _nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // cubits
    var authCubit = AuthenticationCubit.get(context);
    var connectivityCubit = ConnectivityCubit.get(context);
    var taskCubit = TaskCubit.get(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              Row(
                children: [
                  SizedBox(
                    height: 8.h,
                    child: BlocBuilder<TaskCubit, TaskState>(
                      buildWhen: ((previous, current) {
                        if (current is ChangeProfilePhoto) return true;
                        return false;
                      }),
                      builder: (context, state) {
                        print("the photo is rebuilt");
                        return Image.asset(
                          profilesPhoto[taskCubit.selectedIndex],
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    width: 3.w,
                  ),
                  BlocBuilder<TaskCubit, TaskState>(
                    buildWhen: (previous, current) {
                      if (current is ChangeDisplayName) return true;
                      return false;
                    },
                    builder: (_, state) {
                      print("the displayName is rebuilt");
                      return Text(
                        "Hello ${taskCubit.displayName ?? displayName}",
                        style: Theme.of(context)
                            .textTheme
                            .headline1
                            ?.copyWith(fontSize: 12.sp),
                      );
                    },
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () {
                      _myBottomsheet(context, taskCubit);
                    },
                    icon: Icon(Icons.settings),
                  ),
                ],
              ),
              SizedBox(
                height: 4.h,
              ),
              Row(
                children: <Widget>[
                  BlocBuilder<TaskCubit, TaskState>(
                    buildWhen: (previous, current) {
                      if (current is ChangeDayText) return true;
                      return false;
                    },
                    builder: (context, state) {
                      // print("the date is rebuilt");
                      return Text(
                        DateFormat("MMMM, dd").format(taskCubit.selectedDate),
                        style: TextStyle(
                            fontSize: 12.sp, fontWeight: FontWeight.bold),
                      );
                    },
                  ),
                  Spacer(),
                  MyButton(
                    color: Colors.deepPurple,
                    width: 30.w,
                    title: "Add Task",
                    onPress: () {
                      Navigator.pushNamed(context, AddTaskScreen.routeName);
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 4.h,
              ),
              SizedBox(
                height: 15.h,
                child: _BuildDatePicker(
                  cubit: taskCubit,
                ),
              ),
              SizedBox(
                height: 4.h,
              ),

              /// some ugly code
              /// remember to maintance it by
              /// deep understanding about steams
              Expanded(
                child: StreamBuilder(
                    stream: _firestore.getTask(user:_user ),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<TaskModel>> snapshot) {
                      if (snapshot.hasError) {
                        return _noTasks();
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: Colors.deepPurple,
                          ),
                        );
                      }
                      if (snapshot.hasData) {
                        return BlocBuilder<TaskCubit, TaskState>(
                            buildWhen: ((previous, current) {
                          if (current is ChangeDayText) return true;
                          return false;
                        }), builder: (context, state) {
                          print(snapshot.data);
                          List<TaskModel> tasks = [];
                          tasks.addAll(snapshot.data!.where((doc) {
                            return doc.date ==
                                DateFormat("dd-MM-yyyy")
                                    .format(taskCubit.selectedDate);
                          }));
                          if (tasks.isNotEmpty) {
                            return ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              itemCount: tasks.length,
                              itemBuilder: (BuildContext context, int index) {
                                var task = tasks[index];
                                Widget _taskContainer = TaskContainer(
                                  user: _user,
                                  id: task.id,
                                  color: colors[task.colorIndex],
                                  title: task.title,
                                  starttime: task.startTime,
                                  endtime: task.endTime,
                                  note: task.note,
                                );
                                return InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        AddTaskScreen.routeName,
                                        arguments: task,
                                      );
                                    },
                                    child: _taskContainer);
                              },
                            );
                          }
                          return _noTasks();
                        });
                      }
                      return _noTasks();
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }

  // helpers methods

  Future<dynamic> _myBottomsheet(BuildContext context, TaskCubit taskCubit) {
    var isAnonymous = FirebaseAuth.instance.currentUser!.isAnonymous;
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        )),
        builder: ((context) {
          return Padding(
            padding: const EdgeInsets.all(30),
            child: SingleChildScrollView(

                /// need understanding
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List<Widget>.generate(4, (index) {
                          return InkWell(
                            onTap: (() {
                              taskCubit.changeProfilePhoto(index);
                            }),
                            child: Padding(
                              padding: EdgeInsets.only(right: 3.w),
                              child: SizedBox(
                                height: 7.h,
                                child: Image.asset(profilesPhoto[index]),
                              ),
                            ),
                          );
                        }),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      MyTextfield(
                        hint: "Enter Your Name",
                        icon: Icons.person,
                        validator: (name) {
                          if (name == null || name.length < 2) {
                            return "enter you name";
                          }
                          return null;
                        },
                        controller: _nameController,
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      MyButton(
                          color: Colors.green,
                          width: double.infinity,
                          title: "Update Profile",
                          onPress: () {
                            if (_formKey.currentState!.validate()) {
                              taskCubit.changeDisplayName(_nameController.text);
                              Navigator.pop(context);
                            }
                          }),
                      SizedBox(
                        height: 2.h,
                      ),
                      MyButton(
                          color: !isAnonymous ? Colors.red : Colors.deepPurple,
                          width: double.infinity,
                          title: !isAnonymous ? "Log Out" : "Ready To Sign UP",
                          onPress: () {
                            if (!isAnonymous) {
                              GoogleSignIn().signOut();
                              FirebaseAuth.instance.signOut();
                              Navigator.pushReplacementNamed(
                                  context, WelcomeScreen.routeName);
                            } else {
                              Navigator.pushReplacementNamed(
                                  context, SignUpScreen.routeName);
                            }
                          }),
                    ],
                  ),
                )),
          );
        }));
  }

  Expanded _noTasks() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 30.h, child: Image.asset(MyAssets.clipboard)),
          SizedBox(
            height: 3.h,
          ),
          Text(
            "There are No Tasks",
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// builders widgets

class _BuildDatePicker extends StatelessWidget {
  const _BuildDatePicker({
    Key? key,
    required this.cubit,
  }) : super(key: key);

  final TaskCubit cubit;

  @override
  Widget build(BuildContext context) {
    return DatePicker(
      DateTime.now(),
      width: 20.w,
      selectionColor: Colors.deepPurple,
      initialSelectedDate: DateTime.now(),
      dateTextStyle:
          Theme.of(context).textTheme.headline1!.copyWith(fontSize: 18.sp),
      dayTextStyle: Theme.of(context).textTheme.subtitle1!.copyWith(
            fontSize: 10.sp,
          ),
      monthTextStyle:
          Theme.of(context).textTheme.subtitle1!.copyWith(fontSize: 10.sp),
      onDateChange: (newDate) {
        cubit.changeSelectedDate(newDate);
      },
    );
  }
}
