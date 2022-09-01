import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:my_todo_app/Shared/constants/constant_variables.dart';

part 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(const ChangeCurrentIndexState(index: 0));

  int curruntindext = 0;


  void skipindex() {
    curruntindext = onboardinglist.length - 1;
    emit(ChangeCurrentIndexState(
      index: curruntindext,
    ));
  }

  void changeindex({int? index}) {
    curruntindext = index ?? ++curruntindext;
    emit(ChangeCurrentIndexState(
      index: curruntindext,
    ));
  }

  void removefromindex() {
    curruntindext--;
    emit(ChangeCurrentIndexState(
      index: curruntindext,
    ));
  }
}
