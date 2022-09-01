part of 'connectivity_cubit.dart';

@immutable
abstract class ConnectivityState{}

class ConnectivityInitial extends ConnectivityState {}

class ConnectivityOnlineState extends ConnectivityState {}

class ConnectivityOfflineState extends ConnectivityState {}
