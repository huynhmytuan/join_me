part of 'users_search_bloc.dart';

abstract class UsersSearchEvent extends Equatable {
  const UsersSearchEvent();

  @override
  List<Object> get props => [];
}

class SearchUserByName extends UsersSearchEvent {
  const SearchUserByName({required this.searchString});

  final String searchString;

  @override
  List<Object> get props => [searchString];
}
