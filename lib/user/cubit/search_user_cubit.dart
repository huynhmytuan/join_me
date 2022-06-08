import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:join_me/data/models/models.dart';
import 'package:join_me/data/repositories/repositories.dart';

part 'search_user_state.dart';

class SearchUserCubit extends Cubit<SearchUserState> {
  SearchUserCubit({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(SearchUserInitial());

  final UserRepository _userRepository;

  Future<Iterable<AppUser?>> searchUsers(String searchString) {
    return _userRepository.searchUsers(searchString);
  }
}
