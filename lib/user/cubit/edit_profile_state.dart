part of 'edit_profile_cubit.dart';

enum EditProfileStatus { initial, updating, success, failure }

class EditProfileState extends Equatable {
  const EditProfileState({
    required this.userData,
    required this.status,
    required this.bio,
    this.avatarPicture,
  });

  factory EditProfileState.initial({required AppUser user}) => EditProfileState(
        userData: user,
        status: EditProfileStatus.initial,
        bio: '',
      );

  final AppUser userData;
  final AssetEntity? avatarPicture;
  final String bio;
  final EditProfileStatus status;

  EditProfileState copyWith({
    AppUser? userData,
    AssetEntity? avatarPicture,
    String? bio,
    EditProfileStatus? status,
  }) {
    return EditProfileState(
      userData: userData ?? this.userData,
      avatarPicture: avatarPicture ?? this.avatarPicture,
      bio: bio ?? this.bio,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [userData, avatarPicture, bio, status];
}
