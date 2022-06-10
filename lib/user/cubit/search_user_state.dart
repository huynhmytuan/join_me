part of 'search_user_cubit.dart';

class SearchUserState extends Equatable {
  const SearchUserState(this.results);
  factory SearchUserState.initial() => const SearchUserState([]);
  final List<AppUser> results;
  SearchUserState copyWith({
    List<AppUser>? results,
  }) {
    return SearchUserState(
      results ?? this.results,
    );
  }

  @override
  List<Object?> get props => [results];
}
