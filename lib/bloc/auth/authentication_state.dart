part of 'authentication_cubit.dart';

@immutable
abstract class AuthenticationState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationLoadingState extends AuthenticationState {}

class AuthenticationSuccessState extends AuthenticationState {}

class AuthenticationErrorState extends AuthenticationState {
  final String error;

  AuthenticationErrorState(this.error);

  @override
  List<Object?> get props => [error];
}

class UnAuthenticationState extends AuthenticationState {}

class UpdateProfileLoadingState extends AuthenticationState {}

class UpdateProfileSuccessState extends AuthenticationState {}

class UpdateProfileErrorState extends AuthenticationState {}

class ShowingPassword extends AuthenticationState {}
