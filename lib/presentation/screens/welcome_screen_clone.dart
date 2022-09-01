// ignore_for_file: prefer_const_constructors

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_todo_app/Shared/constants/assets_path.dart';
import 'package:my_todo_app/bloc/auth/authentication_cubit.dart';
import 'package:my_todo_app/bloc/connectivity/connectivity_cubit.dart';
import 'package:my_todo_app/presentation/screens/home_screen.dart';
import 'package:my_todo_app/presentation/screens/login_screen.dart';
import 'package:my_todo_app/presentation/screens/signup_screen.dart';
import 'package:my_todo_app/presentation/widgets/mybutton.dart';

import 'package:sizer/sizer.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  static String routeName = "Welcome Screen";

  @override
  Widget build(BuildContext context) {
    var connectCubit = ConnectivityCubit.get(context);
    var authCubit = AuthenticationCubit.get(context);
    return BlocConsumer<AuthenticationCubit, AuthenticationState>(
      listener: (context, state) {
        if (state is AuthenticationSuccessState) {
          Navigator.pushReplacementNamed(context, HomeScreen.routeName);
        }
      },
      builder: (context, state) {
        if (state is! AuthenticationSuccessState) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      BounceInDown(
                        duration: const Duration(milliseconds: 1500),
                        child: Image.asset(
                          MyAssets.welcomeSketch,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(
                        height: 4.h,
                      ),
                      Text('Hello!',
                          style: Theme.of(context)
                              .textTheme
                              .headline1
                              ?.copyWith(letterSpacing: 3)),
                      SizedBox(
                        height: 2.h,
                      ),
                      Text(
                        'Welcome to the best Task manager baby !',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.subtitle1?.copyWith(
                              letterSpacing: 3,
                              fontSize: 10.sp,
                              wordSpacing: 2,
                            ),
                      ),
                      SizedBox(height: 2.h),

                      /// the login button
                      MyButton(
                        width: 90.w,
                        title: "Login",
                        color: Colors.deepPurple,
                        onPress: () {
                          Navigator.pushNamed(context, LoginScreen.routeName);
                        },
                      ),
                      SizedBox(height: 2.h),

                      /// the Sign Up Button  "incomplete widget "
                      MyButton(
                        width: 80.w,
                        title: "Sign Up",
                        color: Colors.deepPurple,
                        onPress: () {
                          Navigator.pushNamed(context, SignUpScreen.routeName);
                        },
                      ),
                      SizedBox(height: 2.h),

                      /// the Register Later Button "incomplete widget"
                      /// because sign in anonymously is incomplete
                      /// maybe complete it when provide custom provider in firebase Auth
                      /// Or store tasks in local database
                      /* _MyOutLineButton(
                          title: 'Register Later',
                          onPress: () {
                            if (connectCubit.state is ConnectivityOnlineState) {
                              authCubit.signInAnonymously();
                            } else {
                              MySnackBar.error(
                                  message:
                                      'Please Check Your Internet Conection',
                                  color: Colors.red,
                                  context: context);
                            }
                          }) */
                    ],
                  ),
                ),
              ),
            ),
          );
        }
        return Text('error');
      },
    );
  }
}

/// the Register Later Widget
class _MyOutLineButton extends StatelessWidget {
  const _MyOutLineButton({Key? key, required this.title, required this.onPress})
      : super(key: key);

  final String title;
  final Function()? onPress;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80.w,
      padding: EdgeInsets.symmetric(vertical: 0.1.h),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.deepPurple, width: 2),
        borderRadius: BorderRadius.circular(200),
      ),
      child: MaterialButton(
        onPressed: onPress,
        child: Text(
          title,
          style: Theme.of(context)
              .textTheme
              .headline1
              ?.copyWith(fontSize: 11.sp, color: Colors.deepPurple),
        ),
      ),
    );
  }
}
