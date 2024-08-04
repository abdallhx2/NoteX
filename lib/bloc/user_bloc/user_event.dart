import 'package:equatable/equatable.dart';
import 'package:notex/models/user.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

class LoadUserEvent extends UserEvent {}


class UpdateUserEvent extends UserEvent {
  final UserModels user;

  const UpdateUserEvent({required this.user});

  @override
  List<Object> get props => [user];
}


class LoginEvent extends UserEvent {
  final String email;
  final String password;

  LoginEvent({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class LogoutEvent extends UserEvent {}

class RegisterEvent extends UserEvent {
  final String phoneNumber;
  final String name;
  final String email;
  final String password;

  RegisterEvent(this.phoneNumber, this.name,
      {required this.email, required this.password});

  @override
  List<Object?> get props => [name, phoneNumber, email, password];
}

class GetUserNameEvent extends UserEvent {
  final String userId;

  GetUserNameEvent({required this.userId});
}
