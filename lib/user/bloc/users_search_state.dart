part of 'users_search_bloc.dart';

abstract class UsersSearchState extends Equatable {
  const UsersSearchState();

  @override
  List<Object> get props => [];
}

class UserInitial extends UsersSearchState {}

class UserSearching extends UsersSearchState {}

class UserSearchResult extends UsersSearchState {
  const UserSearchResult(this.searchResults);

  final List<AppUser> searchResults;

  @override
  List<Object> get props => [searchResults];
}

class UsersLoading extends UsersSearchState {}

class UsersLoadSuccess extends UsersSearchState {
  const UsersLoadSuccess(this.users);

  final List<AppUser> users;

  @override
  List<Object> get props => [users];
}
