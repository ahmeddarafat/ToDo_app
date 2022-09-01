// ignore_for_file: prefer_const_constructors

// extranl package
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_todo_app/presentation/screens/home_screen.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// core packge
import 'package:flutter/material.dart';

// app files
import 'package:my_todo_app/Shared/constants/app_routes.dart';
import 'package:my_todo_app/data/shared_prefs.dart';
import 'package:my_todo_app/Shared/styles/themes.dart';

import 'package:my_todo_app/bloc/onboarding/onboarding_cubit.dart';
import 'package:my_todo_app/bloc/task/task_cubit.dart';
import 'bloc/auth/authentication_cubit.dart';
import 'bloc/connectivity/connectivity_cubit.dart';
import 'bloc/my_bloc_observer.dart';

import 'package:my_todo_app/presentation/screens/onboarding_screen.dart';
import 'package:my_todo_app/presentation/widgets/myindicator.dart';
import 'package:my_todo_app/presentation/screens/welcome_screen_clone.dart';

/// need to complete and relate home page and add task page to firebase
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SharedPrefs.init();

  BlocOverrides.runZoned(
    () {
      runApp(MyApp());
      // Use blocs...
      // AuthenticationCubit();
      // ConnectivityCubit();
    },
    blocObserver: MyBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    return Sizer(
      // sizer widget : it used for taking the dimensions of screen & orientation
      builder: (BuildContext context, Orientation orientation,
          DeviceType deviceType) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<AuthenticationCubit>(
              create: (BuildContext context) => AuthenticationCubit(),
            ),
            BlocProvider<TaskCubit>(
              create: (BuildContext context) => TaskCubit(),
            ),
            BlocProvider<OnboardingCubit>(
              create: (BuildContext context) => OnboardingCubit(),
            ),
            BlocProvider<ConnectivityCubit>(
              /// note: lazy is false only here and it's not in AuthCubit , remember to understand
              lazy: false,
              create: (BuildContext context) =>
                  ConnectivityCubit()..initializeConnectivity(),
            ),
          ],
          child: MaterialApp(
            scaffoldMessengerKey: _scaffoldKey,
            title: 'To-Do',
            theme: MyTheme.lightTheme,
            darkTheme: MyTheme.darkTheme,
            themeMode: ThemeMode.light,
            home: StreamBuilder<User?>(
              /// this stream is always changing when changing in auth state
              /// like ( sign in , sign out , ...etc )
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                bool? seen = SharedPrefs.getBool(key: 'seen');
                if (snapshot.connectionState == ConnectionState.waiting) {
                  print('the snapshot is waiting');
                  return const MyCircularIndicator();
                }
                if (snapshot.hasData) {
                  print('the snapshot has data');
                  print(snapshot.data?.email);
                  return HomeScreen();
                }
                if (seen != null) {
                  return WelcomeScreen();
                }
                print("the snapshot doesn't have data or isn't waiting");
                return OnboardingScreen();
              },
            ),
            routes: appRoutes,
          ),
        );
      },
    );
  }
}
