import 'dart:io';
import 'dart:typed_data';

import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:join_me/app/bloc/app_bloc.dart';
import 'package:join_me/config/router/app_router.dart';
import 'package:join_me/config/theme.dart';
import 'package:join_me/data/models/models.dart';
import 'package:join_me/data/repositories/post_repository.dart';
import 'package:join_me/generated/locale_keys.g.dart';
import 'package:join_me/post/cubit/new_post_cubit.dart';

import 'package:join_me/utilities/constant.dart';
import 'package:join_me/utilities/extensions/string_ext.dart';
import 'package:join_me/widgets/dialog/add_project_invitation_dialog.dart';
import 'package:join_me/widgets/widgets.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:photo_manager/photo_manager.dart';

class NewPostPage extends StatelessWidget {
  const NewPostPage({Key? key}) : super(key: key);

  Future<bool> _onWillPop(BuildContext context) async {
    final newPostBlocState = context.read<NewPostCubit>().state;
    if (newPostBlocState.status == NewPostStatus.newPostUpload) {
      return true;
    }
    var isPop = false;
    if (newPostBlocState.content.isNotEmpty ||
        newPostBlocState.medias.isNotEmpty ||
        newPostBlocState.invitedProject.id.isNotEmpty) {
      await showDialog<bool>(
        context: context,
        builder: (context) => CustomAlertDialog(
          title: LocaleKeys.dialog_discardChanges_title.tr(),
          content: LocaleKeys.dialog_discardChanges_content.tr(),
          submitLabel: LocaleKeys.button_delete.tr(),
          submitButtonColor: Colors.red,
          onSubmit: () {
            AutoRouter.of(context).pop(true);
          },
          onCancel: () {
            AutoRouter.of(context).pop(false);
          },
        ),
      ).then((value) {
        if (value != null && value) {
          isPop = true;
        }
      });
    } else {
      isPop = true;
    }
    return isPop;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NewPostCubit(
        postRepository: context.read<PostRepository>(),
        author: context.read<AppBloc>().state.user,
      ),
      child: BlocBuilder<NewPostCubit, NewPostState>(
        builder: (context, state) {
          return WillPopScope(
            onWillPop: () async {
              final value = await _onWillPop(context);
              return value;
            },
            child: KeyboardDismisser(
              // ignore: prefer_const_literals_to_create_immutables
              gestures: [
                GestureType.onTap,
              ],
              child: Scaffold(
                backgroundColor: Theme.of(context).cardColor,
                appBar: AppBar(
                  centerTitle: true,
                  leading: const _CloseButton(),
                  title: Text(LocaleKeys.appBarTitle_createNewPost.tr()),
                  actions: const [_AddNewPostButton()],
                ),
                body: Container(
                  margin: const EdgeInsets.only(bottom: 40),
                  child: Scrollbar(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: const [
                          _UserInfo(),
                          _PostContentInput(),
                          _MediaPreview(),
                          _InvitationAdded(),
                        ],
                      ),
                    ),
                  ),
                ),
                floatingActionButton: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: const [
                      _AddMediaButton(),
                      SizedBox(
                        width: kDefaultPadding,
                      ),
                      _AddInvitationButton()
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CloseButton extends StatelessWidget {
  const _CloseButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        AutoRouter.of(context).pop();
      },
      icon: const Icon(Ionicons.close),
    );
  }
}

class _InvitationAdded extends StatelessWidget {
  const _InvitationAdded({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewPostCubit, NewPostState>(
      buildWhen: (previous, current) =>
          previous.invitedProject != current.invitedProject,
      builder: (context, state) {
        if (state.invitedProject.id.isNotEmpty) {
          return Container(
            margin: const EdgeInsets.only(top: kDefaultPadding),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(.5),
            ),
            child: ListTile(
              title: Text(
                LocaleKeys.post_invitationTo
                    .tr(args: ['"${state.invitedProject.name}"']),
              ),
              subtitle: Text(
                '${state.invitedProject.members.length.toString()} ${LocaleKeys.general_members.tr()}',
              ),
              trailing: GestureDetector(
                onTap: () => context.read<NewPostCubit>().removeInvitation(),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    shape: BoxShape.circle,
                    boxShadow: kDefaultBoxShadow,
                  ),
                  child: const Icon(
                    Icons.close,
                    size: 16,
                    color: kTextColorGrey,
                  ),
                ),
              ),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}

class _MediaPreview extends StatelessWidget {
  const _MediaPreview({
    Key? key,
  }) : super(key: key);
  void _onRemovePressed(AssetEntity media, BuildContext context) {
    context.read<NewPostCubit>().mediaRemove(media: media);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewPostCubit, NewPostState>(
      buildWhen: (previous, current) =>
          !listEquals(previous.medias, current.medias) ||
          previous.medias.length != current.medias.length,
      builder: (context, state) {
        if (state.medias.isNotEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 200,
                width: double.infinity,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: state.medias.length,
                  itemBuilder: (context, index) => FutureBuilder<Uint8List?>(
                    future: state.medias[index].thumbnailDataWithOption(
                      (Platform.isIOS)
                          ? ThumbnailOption.ios(
                              size: const ThumbnailSize.square(250),
                            )
                          : const ThumbnailOption(
                              size: ThumbnailSize.square(200),
                            ),
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Padding(
                          padding: const EdgeInsets.all(1),
                          child: Stack(
                            children: [
                              AspectRatio(
                                aspectRatio: 1,
                                child: Image.memory(
                                  snapshot.data!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: 5,
                                right: 5,
                                child: GestureDetector(
                                  onTap: () => _onRemovePressed(
                                    state.medias[index],
                                    context,
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: kIconColorGrey.withOpacity(.5),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Ionicons.close_circle_outline,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                  ),
                                ),
                              ),
                              if (state.medias[index].type == AssetType.video)
                                Positioned(
                                  bottom: 5,
                                  right: 5,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 3,
                                      horizontal: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(.5),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Text(
                                      ''.formatDuration(
                                        state.medias[index].duration,
                                      ),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      }
                      return AspectRatio(
                        aspectRatio: 1,
                        child: Container(
                          color: kIconColorGrey,
                        ),
                      );
                    },
                  ),
                ),
              ),
              Text(
                LocaleKeys.post_assetSelected.plural(state.medias.length),
                style: CustomTextStyle.heading4(context).copyWith(
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          );
        }
        return const SizedBox();
      },
    );
  }
}

class _UserInfo extends StatelessWidget {
  const _UserInfo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        return Row(
          children: [
            CircleAvatarWidget(imageUrl: state.user.photoUrl),
            const SizedBox(
              width: kDefaultPadding / 2,
            ),
            Text(
              state.user.name,
              style: CustomTextStyle.heading3(context),
            )
          ],
        );
      },
    );
  }
}

class _AddNewPostButton extends StatelessWidget {
  const _AddNewPostButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewPostCubit, NewPostState>(
      builder: (context, state) {
        return IconButton(
          key: UniqueKey(),
          color: Theme.of(context).primaryColor,
          onPressed: (state.content.isNotEmpty ||
                  state.medias.isNotEmpty ||
                  state.invitedProject.id.isNotEmpty)
              ? () {
                  context.read<NewPostCubit>().submitPost();
                  AutoRouter.of(context).pop();
                }
              : null,
          icon: const Icon(Ionicons.share_outline),
        );
      },
    );
  }
}

class _PostContentInput extends StatelessWidget {
  const _PostContentInput({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewPostCubit, NewPostState>(
      builder: (context, state) {
        return TextField(
          autofocus: true,
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.newline,
          maxLines: null,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(5),
            border: InputBorder.none,
            hintText: LocaleKeys.textField_whatOnYourMind.tr(),
          ),
          onChanged: (value) =>
              context.read<NewPostCubit>().contentChange(value),
        );
      },
    );
  }
}

class _AddMediaButton extends StatelessWidget {
  const _AddMediaButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewPostCubit, NewPostState>(
      builder: (context, state) {
        return RoundedButton(
          height: 35,
          minWidth: 80,
          child: Row(
            children: [
              const Icon(
                Ionicons.image,
                color: Colors.white,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                LocaleKeys.button_addAsset.tr(),
                style: CustomTextStyle.heading4(context).copyWith(
                  color: Colors.white,
                ),
              )
            ],
          ),
          onPressed: () {
            AutoRouter.of(context)
                .push(ImagesPickerRoute(initialMedias: state.medias))
                .then((selections) {
              if (selections != null) {
                context
                    .read<NewPostCubit>()
                    .postMediasChange(medias: selections as List<AssetEntity>);
              }
            });
          },
        );
      },
    );
  }
}

class _AddInvitationButton extends StatelessWidget {
  const _AddInvitationButton({
    Key? key,
  }) : super(key: key);
  void _showAddInvitationDialog(BuildContext context, NewPostCubit cubit) {
    showDialog<Project>(
      context: context,
      builder: (context) => const AddProjectInviteDialog(),
    ).then((project) {
      if (project == null) {
        return;
      }
      cubit.addInvitation(project: project);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewPostCubit, NewPostState>(
      builder: (context, state) {
        return RoundedButton(
          height: 35,
          minWidth: 80,
          color: kSecondaryBlue,
          child: Row(
            children: [
              Icon(
                state.invitedProject.id.isEmpty
                    ? Ionicons.person_add
                    : Ionicons.repeat_outline,
                color: Colors.white,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                state.invitedProject.id.isEmpty
                    ? LocaleKeys.button_addInvitation.tr()
                    : LocaleKeys.button_changeInvitation.tr(),
                style: CustomTextStyle.heading4(context).copyWith(
                  color: Colors.white,
                ),
              )
            ],
          ),
          onPressed: () => _showAddInvitationDialog(
            context,
            context.read<NewPostCubit>(),
          ),
        );
      },
    );
  }
}
