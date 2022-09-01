// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:my_todo_app/Shared/constants/assets_path.dart';
import 'package:my_todo_app/Shared/styles/colors.dart';
import 'package:my_todo_app/bloc/auth/authentication_cubit.dart';
import 'package:my_todo_app/bloc/connectivity/connectivity_cubit.dart';
import 'package:my_todo_app/presentation/screens/home_screen.dart';
import 'package:my_todo_app/presentation/screens/signup_screen.dart';
import 'package:my_todo_app/presentation/widgets/my_snack_bar.dart';
import 'package:my_todo_app/presentation/widgets/mybutton.dart';
import 'package:my_todo_app/presentation/widgets/mytextfield.dart';
import 'package:sizer/sizer.dart';
import 'package:validators/validators.dart' as validators;

import '../widgets/myindicator.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  static String routeName = 'Login Screen';

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var authCubit = AuthenticationCubit.get(context);
    var connectivityCubit = ConnectivityCubit.get(context);
    return Scaffold(
      backgroundColor: Appcolors.white,
      appBar: AppBar(
        backgroundColor: Appcolors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Appcolors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: BlocConsumer<AuthenticationCubit, AuthenticationState>(
        listener: (context, state) {
          if (state is AuthenticationErrorState) {
            MySnackBar.error(
                message: state.error, color: Colors.red, context: context);
          } else if (state is AuthenticationSuccessState) {
            Navigator.pushReplacementNamed(context, HomeScreen.routeName);
          } else if (state is AuthenticationLoadingState) {
            authCubit.changingSpinnerMethod();
          } if ( state is! AuthenticationLoadingState){
            if(authCubit.showingSpinner = true){
            authCubit.changingSpinnerMethod();
            }
          }

        },
        builder: (context, state) {
          // print("the whole widgets rebuild again but with circle above");
          if (state is! AuthenticationSuccessState) {
            // print("the whole widgets rebuild again but with circle above");
            return ModalProgressHUD(
              inAsyncCall: authCubit.showingSpinner,
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(40),
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Welcome !',
                            style: Theme.of(context).textTheme.headline1,
                          ),
                          SizedBox(height: 2.h),
                          Text('Sign In To Continue !',
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  ?.copyWith(letterSpacing: 3)),
                          SizedBox(height: 6.h),

                          // the Email Address  Text Field
                          MyTextfield(
                            hint: 'Email Address',
                            icon: Icons.email,
                            validator: (String? value) {
                              return !validators.isEmail(value!)
                                  ? 'Enter a valid email'
                                  : null;
                            },
                            controller: _emailController,
                            keyboardtype: TextInputType.emailAddress,
                          ),
                          SizedBox(height: 4.h),

                          // the password Text field   "incomplete widget"
                          //    - the obscure pass
                          MyTextfield(
                            hint: 'Password',
                            icon: Icons.password,
                            validator: (String? value) {
                              return value!.length < 6
                                  ? 'Enter min. 6 characters'
                                  : null;
                            },
                            controller: _passwordController,
                            keyboardtype: TextInputType.visiblePassword,
                          ),
                          SizedBox(height: 4.h),

                          /// The Login button
                          MyButton(
                            color: Appcolors.buttonColor,
                            width: 90.w,
                            title: "Login",
                            onPress: () async {
                              if (connectivityCubit.state
                                  is ConnectivityOnlineState) {
                                await _authenticateWithEmailAndPass(
                                    context, authCubit);
                              } else {
                                String message =
                                    'Please Check Your Internet Connection';
                                MySnackBar.error(
                                    message: message,
                                    color: Colors.red,
                                    context: context);
                              }
                            },
                          ),
                          SizedBox(height: 2.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Don't have an Account ?",
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    ?.copyWith(
                                      fontSize: 11.sp,
                                    ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.pushReplacementNamed(
                                      context, SignUpScreen.routeName);
                                },
                                child: Text(
                                  "Sign Up",
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      ?.copyWith(
                                        color: Appcolors.deepPurple,
                                        fontSize: 11.sp,
                                      ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 4.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _MyDivider(),
                              SizedBox(width: 15),
                              Text(
                                'Or',
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    ?.copyWith(
                                        color: Appcolors.deepPurple,
                                        fontSize: 9.sp),
                              ),
                              SizedBox(width: 15),
                              _MyDivider(),
                            ],
                          ),
                          SizedBox(height: 4.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              /// google icon
                              /// under testing
                              InkWell(
                                onTap: () async {
                                  if (connectivityCubit.state
                                      is ConnectivityOnlineState) {
                                    await _authenticateWithGoogleAccount(
                                        context, authCubit);
                                  } else {
                                    String message =
                                        'Please Check Your Internet Connection';
                                    MySnackBar.error(
                                        message: message,
                                        color: Colors.red,
                                        context: context);
                                  }
                                },
                                child: Image.asset(
                                  MyAssets.googleIcon,
                                ),
                              ),
                              SizedBox(width: 30.w),
                              /// facebook icon
                              /// there is an error need to debug
                              InkWell(
                                onTap: () {
                                  /// the code is in sign up screen
                                },
                                child: Image.asset(MyAssets.facebookIcon),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
            // ignore: unnecessary_type_check
          }
          return Text("error");
        },
      ),
    );
  }

  Future<void> _authenticateWithEmailAndPass(
      context, AuthenticationCubit cubit) async {
    if (_formKey.currentState!.validate()) {
      cubit.login(
          email: _emailController.text, password: _passwordController.text);
    }
  }

  Future<void> _authenticateWithGoogleAccount(
      context, AuthenticationCubit cubit) async {
      cubit.googleSignIn();
  }
}

class _MyDivider extends StatelessWidget {
  const _MyDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      height: 0.8,
      width: 30.w,
    );
  }
}
