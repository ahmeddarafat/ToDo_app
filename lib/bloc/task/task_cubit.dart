import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  TaskCubit() : super(TaskInitial());

  static TaskCubit get(BuildContext context) => BlocProvider.of(context);

  DateTime selectedDate = DateTime.now();

  void changeSelectedDate(DateTime dateTime) {
    selectedDate = dateTime;
    emit(ChangeDayText(dateTime));
  }

  String? displayName;

  void changeDisplayName(String name) {
    displayName = name;
    emit(ChangeDisplayName(name));
  }

  int selectedIndex = 0;

  void changeProfilePhoto(int index) {
    selectedIndex = index;
    emit(ChangeProfilePhoto(index));
  }
}
