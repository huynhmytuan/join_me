import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:join_me/app/cubit/app_message_cubit.dart';

import 'package:join_me/data/models/app_user.dart';
import 'package:join_me/data/repositories/repositories.dart';

import 'package:photo_manager/photo_manager.dart';

part 'edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  EditProfileCubit({
    required AppUser user,
    required UserRepository userRepository,
    required AppMessageCubit appMessageCubit,
  })  : _userRepository = userRepository,
        _appMessageCubit = appMessageCubit,
        super(EditProfileState.initial(user: user));

  final UserRepository _userRepository;
  final AppMessageCubit _appMessageCubit;

  Future<void> changeUserAvatar(AssetEntity asset) async {
    emit(state.copyWith(avatarPicture: asset));
  }

  void onBioChange(String value) {
    emit(
      state.copyWith(
        avatarPicture: state.avatarPicture,
        bio: value,
      ),
    );
  }

  Future<void> saveChanges() async {
    emit(state.copyWith(status: EditProfileStatus.updating));
    try {
      if (state.avatarPicture != null) {
        await _userRepository.updateUserAvatar(
          imageEntity: state.avatarPicture!,
          user: state.userData,
        );
      }
      if (state.bio.isNotEmpty) {
        await _userRepository.updateUserBio(
          newBio: state.bio,
          user: state.userData,
        );
      }
      emit(
        state.copyWith(
          status: EditProfileStatus.success,
        ),
      );
      _appMessageCubit.showSuccessfulSnackBar(message: 'Update Success');
    } catch (e) {
      emit(state.copyWith(status: EditProfileStatus.failure));
    }
  }
}
