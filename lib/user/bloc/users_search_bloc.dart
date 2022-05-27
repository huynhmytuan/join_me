import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:join_me/data/models/app_user.dart';
import 'package:join_me/data/repositories/user_repository.dart';

part 'users_search_event.dart';
part 'users_search_state.dart';

class UsersSearchBloc extends Bloc<UsersSearchEvent, UsersSearchState> {
  UsersSearchBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(UserInitial()) {
    on<SearchUserByName>(_onSearchUser);
  }

  final UserRepository _userRepository;

  Future<void> _onSearchUser(
    SearchUserByName event,
    Emitter<UsersSearchState> emit,
  ) async {
    emit(UserSearching());
    final results = await _userRepository.searchUsers(event.searchString);
    emit(UserSearchResult(results));
  }
}
