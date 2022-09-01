part of 'task_cubit.dart';

abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object> get props => [];
}

class TaskInitial extends TaskState {}

class ChangeDayText extends TaskState {
  const ChangeDayText(this.newdate);
  final DateTime newdate;

   @override
  List<Object> get props => [newdate];
}

class ChangeDisplayName extends TaskState {
  const ChangeDisplayName(this.dispalyName);
  final String dispalyName;

   @override
  List<Object> get props => [dispalyName];
}

class ChangeProfilePhoto extends TaskState {
  const ChangeProfilePhoto(this.index);
  final int index;

   @override
  List<Object> get props => [index];
}
