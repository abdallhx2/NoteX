import 'package:equatable/equatable.dart';
import 'package:notex/models/user.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

class LoadUserEvent extends UserEvent {}

class AddUserEvent extends UserEvent {
  final UserModels user;

  const AddUserEvent({required this.user});

  @override
  List<Object> get props => [user];
}

class UpdateUserEvent extends UserEvent {
  final UserModels user;

  const UpdateUserEvent({required this.user});

  @override
  List<Object> get props => [user];
}

class DeleteUserEvent extends UserEvent {
  final String id;

  const DeleteUserEvent({required this.id});

  @override
  List<Object> get props => [id];
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
  final String email;
  final String password;

  RegisterEvent({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}