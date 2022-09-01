// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:my_todo_app/presentation/screens/login_screen.dart';
import 'package:sizer/sizer.dart';

import 'package:validators/validators.dart' as validators;
import '../../Shared/constants/assets_path.dart';
import '../../Shared/styles/colors.dart';
import '../../bloc/auth/authentication_cubit.dart';
import '../../bloc/connectivity/connectivity_cubit.dart';
import '../widgets/my_snack_bar.dart';
import '../widgets/mybutton.dart';
import '../widgets/mytextfield.dart';
import 'home_screen.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({Key? key}) : super(key: key);

  static String routeName = 'Sign Up Screen';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late final TextEditingController _fullNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _fullNameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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
          icon: const Icon(
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
          }
          if (state is! AuthenticationLoadingState) {
            if (authCubit.showingSpinner = true) {
              authCubit.changingSpinnerMethod();
            }
          }
        },
        builder: (context, state) {
          if (state is! AuthenticationSuccessState) {
            return ModalProgressHUD(
              inAsyncCall: authCubit.showingSpinner,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(40),
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Heey !',
                            style: Theme.of(context).textTheme.headline1,
                          ),
                          SizedBox(height: 2.h),
                          Text('Create a New Account!',
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  ?.copyWith(letterSpacing: 3)),
                          SizedBox(height: 6.h),

                          // the Full Name Text Field
                          MyTextfield(
                            hint: 'User Name',
                            icon: Icons.person,
                            validator: (String? value) {
                              return value == "" ? 'Enter your name' : null;
                            },
                            controller: _fullNameController,
                            keyboardtype: TextInputType.name,
                          ),
                          SizedBox(height: 4.h),
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

                          /// The Login Widget
                          MyButton(
                            color: Appcolors.buttonColor,
                            width: 90.w,
                            title: "Sign Up",
                            onPress: () async {
                              if (connectivityCubit.state
                                  is ConnectivityOnlineState) {
                                await _createUserWithEmailAndPassword(
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
                                "I already have an account?",
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
                                      context, LoginScreen.routeName);
                                },
                                child: Text(
                                  "Login",
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
                              const _MyDivider(),
                              const SizedBox(width: 15),
                              Text(
                                'Or',
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    ?.copyWith(
                                        color: Appcolors.deepPurple,
                                        fontSize: 9.sp),
                              ),
                              const SizedBox(width: 15),
                              _MyDivider(),
                            ],
                          ),
                          SizedBox(height: 4.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              // google sign up
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
                              // facebook sign up
                              InkWell(
                                /// set up is done , start with the code
                                /// there is an error need to debug
                                onTap: () async {
                                  // if (connectivityCubit.state
                                  //     is ConnectivityOnlineState) {
                                  //   await _authenticateWithFacebookAccount(
                                  //       context, authCubit);
                                  // } else {
                                  //   String message =
                                  //       'Please Check Your Internet Connection';
                                  //   MySnackBar.error(
                                  //       message: message,
                                  //       color: Colors.red,
                                  //       context: context);
                                  // }
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

  Future<void> _createUserWithEmailAndPassword(
      context, AuthenticationCubit cubit) async {
    if (_formKey.currentState!.validate()) {
      cubit.register(
          email: _emailController.text,
          password: _passwordController.text,
          fullName: _fullNameController.text);
    }
  }

  Future<void> _authenticateWithGoogleAccount(
      context, AuthenticationCubit cubit) async {
    cubit.googleSignIn();
  }

  // Future<void> _authenticateWithFacebookAccount(
  //     context, AuthenticationCubit cubit) async {
  //   cubit.facebookSignIn();
  // }
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
