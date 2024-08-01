import 'package:equatable/equatable.dart';
import 'package:notex/models/user.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final UserModels user;

  const UserLoaded({required this.user});

  @override
  List<Object> get props => [user];
}

class UserError extends UserState {
  final String message;

  const UserError({required this.message});

  @override
  List<Object> get props => [message];
}


class UserLoggedIn extends UserState {
  final String userId;
  UserLoggedIn({required this.userId});

  List<Object> get props => [userId];

}

class UserLoggedOut extends UserState {}

class UserRegistered extends UserState {
  final UserModels user;

  UserRegistered({required this.user});

  @override
  List<Object> get props => [user];
}

class UserNotRegistered extends UserState {
  final String message;

  UserNotRegistered({required this.message});

  @override
  List<Object> get props => [message];
}