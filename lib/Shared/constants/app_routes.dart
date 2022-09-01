import 'package:flutter/material.dart';


import 'package:my_todo_app/presentation/screens/add_task.dart';
import 'package:my_todo_app/presentation/screens/home_screen.dart';
import 'package:my_todo_app/presentation/screens/login_screen.dart';
import 'package:my_todo_app/presentation/screens/signup_screen.dart';
import 'package:my_todo_app/presentation/screens/welcome_screen_clone.dart';

Map<String, WidgetBuilder> appRoutes = {
  WelcomeScreen.routeName: (BuildContext context) => WelcomeScreen(),
  LoginScreen.routeName: (BuildContext context) => LoginScreen(),
  HomeScreen.routeName: (BuildContext context) => HomeScreen(),
  SignUpScreen.routeName: (BuildContext context) => SignUpScreen(),
  AddTaskScreen.routeName: (BuildContext context) => AddTaskScreen(),
};
