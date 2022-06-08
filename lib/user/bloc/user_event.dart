part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

class LoadUser extends UserEvent {
  const LoadUser(this.userId);

  final String userId;

  @override
  List<Object?> get props => [userId];
}

class UpdateUser extends UserEvent {
  const UpdateUser(this.user);

  final AppUser user;

  @override
  List<Object?> get props => [user];
}
