part of 'user_bloc.dart';

enum UserInfoStatus { initial, loading, success, failure }

class UserState extends Equatable {
  const UserState({
    required this.user,
    required this.status,
  });
  factory UserState.initial() => const UserState(
        user: AppUser.empty,
        status: UserInfoStatus.initial,
      );
  final AppUser user;
  final UserInfoStatus status;

  UserState copyWith({
    AppUser? user,
    UserInfoStatus? status,
  }) {
    return UserState(
      user: user ?? this.user,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [user, status];
}
