import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:my_todo_app/data/repositories/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit() : super(AuthenticationInitial());

  static AuthenticationCubit get(BuildContext context) =>
      BlocProvider.of(context);

  bool showingSpinner = false;

  void changingSpinnerMethod() {
    showingSpinner = !showingSpinner;

    /// making an error
    // emit(AuthenticationLoadingState());
  }

  bool showPassowrd = false;
  void showPassMehtod() {
    showPassowrd = !showPassowrd;
    emit(ShowingPassword());
  }

  final FirebaseAuthRepo firebaseAuthRepo = FirebaseAuthRepo();

  void login({required String email, required String password}) {
    emit(AuthenticationLoadingState());
    firebaseAuthRepo.login(email: email, password: password).then((_) {
      final user = FirebaseAuth.instance.currentUser;
      user!.displayName == '' ? user.updateDisplayName('User') : null;
      emit(AuthenticationSuccessState());
    }).catchError((error) {
      emit(AuthenticationErrorState(error.toString()));
      emit(UnAuthenticationState());
    });
  }

  void register(
      {required String fullName,
      required String email,
      required String password}) {
    emit(AuthenticationLoadingState());
    firebaseAuthRepo
        .register(fullname: fullName, email: email, password: password)
        .then((_) {
      emit(AuthenticationSuccessState());
    }).catchError((error) {
      emit(AuthenticationErrorState(error.toString()));

      ///  need understanding
      emit(UnAuthenticationState());
    });
  }

  void signout() async {
    await firebaseAuthRepo.logout();
    emit(UnAuthenticationState());
  }

  void signInAnonymously() async {
    emit(AuthenticationLoadingState());
    await firebaseAuthRepo.signInAnonymously().then((value) {
      emit(AuthenticationSuccessState());
    });
  }

  void googleSignIn() {
    emit(AuthenticationLoadingState());
    firebaseAuthRepo.googleSignIn().then((_) {
      emit(AuthenticationSuccessState());
    }).catchError((error) {
      String normalError =
          "Exception: 'package:firebase_auth_platform_interface/src/providers/google_auth.dart': Failed assertion: line 43 pos 12: 'accessToken != null || idToken != null': At least one of ID token and access token is required";
      if (error.toString() == normalError) {
        emit(AuthenticationErrorState("You didn't login with google accounts"));
      } else {
        emit(AuthenticationErrorState(error.toString()));
      }

      /// need understadning
      emit(UnAuthenticationState());
    });
  }

  void facebookSignIn() {
    emit(AuthenticationLoadingState());
    firebaseAuthRepo.facebookSignIn().then((_) {
      emit(AuthenticationSuccessState());
    }).catchError((error) {
      emit(AuthenticationErrorState(error.toString()));

      /// need understanding
      emit(UnAuthenticationState());
    });
  }
}
