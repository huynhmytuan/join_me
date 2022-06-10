import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:join_me/data/models/models.dart';
import 'package:join_me/data/repositories/repositories.dart';

part 'search_user_state.dart';

class SearchUserCubit extends Cubit<SearchUserState> {
  SearchUserCubit({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(SearchUserState.initial());

  final UserRepository _userRepository;

  void clearResults() {
    emit(state.copyWith(results: []));
  }

  Future<Iterable<AppUser?>> searchUsers(String searchString) async {
    final results = await _userRepository.searchUsers(searchString);
    emit(state.copyWith(results: results));
    return results;
  }
}
