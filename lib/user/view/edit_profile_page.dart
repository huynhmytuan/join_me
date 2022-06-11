import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:join_me/app/cubit/app_message_cubit.dart';
import 'package:join_me/config/router/app_router.dart';
import 'package:join_me/config/theme.dart';
import 'package:join_me/data/repositories/repositories.dart';
import 'package:join_me/generated/locale_keys.g.dart';
import 'package:join_me/user/bloc/user_bloc.dart';
import 'package:join_me/user/cubit/edit_profile_cubit.dart';
import 'package:join_me/utilities/constant.dart';
import 'package:join_me/widgets/widgets.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:photo_manager/photo_manager.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({required this.userBloc, Key? key}) : super(key: key);
  final UserBloc userBloc;

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _bioEditController;
  @override
  void initState() {
    _bioEditController =
        TextEditingController(text: widget.userBloc.state.user.personalBio);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      bloc: widget.userBloc,
      builder: (context, state) {
        return BlocProvider(
          create: (context) => EditProfileCubit(
            user: state.user,
            userRepository: context.read<UserRepository>(),
            appMessageCubit: context.read<AppMessageCubit>(),
          ),
          child: KeyboardDismisser(
            child: Scaffold(
              appBar: _buildAppBar(context),
              body: _buildProfileView(state),
            ),
          ),
        );
      },
    );
  }

  SingleChildScrollView _buildProfileView(UserState state) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: kDefaultPadding,
          vertical: 40,
        ),
        child: Column(
          children: [
            const _UserPhoto(),
            const _UserName(),
            const SizedBox(
              height: 50,
            ),
            const _UserEmail(),
            _UserBiography(textEditingController: _bioEditController),
            const SizedBox(
              height: 50,
            ),
            const _SaveChangeButton(),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(LocaleKeys.appBarTitle_editProfile.tr()),
      centerTitle: true,
      leading: BlocBuilder<EditProfileCubit, EditProfileState>(
        builder: (context, state) {
          return RoundedIconButton(
            onTap: () {
              AutoRouter.of(context).pop();
            },
            backgroundColor: Theme.of(context).brightness == Brightness.light
                ? kIconColorGrey
                : Theme.of(context).cardColor,
            icon: const Icon(
              Ionicons.chevron_back,
              size: 24,
              color: Colors.white,
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _bioEditController.dispose();
    super.dispose();
  }
}

class _UserPhoto extends StatelessWidget {
  const _UserPhoto({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditProfileCubit, EditProfileState>(
      builder: (context, state) {
        return Column(
          children: [
            if (state.avatarPicture != null)
              FutureBuilder<File?>(
                future: state.avatarPicture!.file,
                builder: (context, snapshot) {
                  return Container(
                    width: 100,
                    height: 100,
                    padding: const EdgeInsets.all(1.5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        width: 2,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    child: snapshot.hasData
                        ? CircleAvatar(
                            backgroundImage: FileImage(
                              snapshot.data!,
                            ),
                          )
                        : const Center(child: Icon(Icons.local_dining)),
                  );
                },
              )
            else
              CircleAvatarWidget(
                imageUrl: state.userData.photoUrl,
                size: 100,
                border: Border.all(
                  width: 2,
                  color: Theme.of(context).primaryColor,
                ),
                padding: const EdgeInsets.all(1.5),
              ),
            TextButton(
              onPressed: () {
                AutoRouter.of(context)
                    .push(
                  ImagesPickerRoute(
                    limit: 1,
                    type: RequestType.image,
                  ),
                )
                    .then((medias) {
                  if (medias != null) {
                    final media = (medias as List<AssetEntity>).first;
                    context.read<EditProfileCubit>().changeUserAvatar(media);
                  }
                });
              },
              child: Text(LocaleKeys.button_changeAvatar.tr()),
            )
          ],
        );
      },
    );
  }
}

class _UserName extends StatelessWidget {
  const _UserName({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditProfileCubit, EditProfileState>(
      builder: (context, state) {
        return Center(
          child: Text(
            state.userData.name,
            style: CustomTextStyle.heading2(context),
          ),
        );
      },
    );
  }
}

class _UserEmail extends StatelessWidget {
  const _UserEmail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditProfileCubit, EditProfileState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LocaleKeys.general_email.tr(),
              style: CustomTextStyle.heading4(context),
            ),
            TextField(
              enabled: false,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: state.userData.email,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _UserBiography extends StatelessWidget {
  const _UserBiography({required this.textEditingController, Key? key})
      : super(key: key);
  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditProfileCubit, EditProfileState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LocaleKeys.general_biography.tr(),
              style: CustomTextStyle.heading4(context),
            ),
            TextField(
              controller: textEditingController,
              maxLines: null,
              onChanged: (value) =>
                  context.read<EditProfileCubit>().onBioChange(value),
              maxLength: 101,
              decoration: InputDecoration(
                hintMaxLines: 3,
                border: InputBorder.none,
                hintText: LocaleKeys.textField_biographyHint.tr(),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SaveChangeButton extends StatelessWidget {
  const _SaveChangeButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditProfileCubit, EditProfileState>(
      builder: (context, state) {
        if (state.status == EditProfileStatus.updating) {
          return const CircularProgressIndicator();
        }
        return RoundedButton(
          height: 30,
          onPressed: (state.bio.isEmpty && state.avatarPicture == null)
              ? null
              : () {
                  context.read<EditProfileCubit>().saveChanges();
                },
          child: Text(LocaleKeys.button_saveChanges.tr()),
        );
      },
    );
  }
}
