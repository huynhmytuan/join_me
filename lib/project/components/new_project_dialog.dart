import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:join_me/config/theme.dart';
import 'package:join_me/data/dummy_data.dart' as dummy_data;
import 'package:join_me/data/models/models.dart';
import 'package:join_me/utilities/constant.dart';
import 'package:join_me/widgets/widgets.dart';

class NewProjectDialog extends StatefulWidget {
  const NewProjectDialog({Key? key}) : super(key: key);

  @override
  State<NewProjectDialog> createState() => NewProjectDialogState();
}

class NewProjectDialogState extends State<NewProjectDialog> {
  List<AppUser> _members = [];
  final _formKey = GlobalKey<FormState>();
  bool _isBUttonActive = false;

  @override
  void initState() {
    super.initState();
  }

  void _showMembersEditDialog() {
    showDialog<List<AppUser>>(
      context: context,
      builder: (context) => AddUserDialog(
        initialUserList: _members,
        withoutCurrentUser: true,
      ),
    ).then((selectedUser) {
      if (selectedUser == null) {
        return;
      }
      setState(() {
        _members = selectedUser;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: kBorderRadiusShape,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  autofocus: true,
                  style: CustomTextStyle.heading3(context),
                  decoration: const InputDecoration(
                    hintText: 'Project Name',
                    border: InputBorder.none,
                  ),
                  textInputAction: TextInputAction.next,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      WidgetsBinding.instance!.addPostFrameCallback((_) {
                        setState(() {
                          _isBUttonActive = false;
                        });
                      });
                    } else {
                      WidgetsBinding.instance!.addPostFrameCallback((_) {
                        setState(() {
                          _isBUttonActive = true;
                        });
                      });
                    }
                  },
                ),
                const Divider(),
                TextFormField(
                  style: CustomTextStyle.bodyMedium(context),
                  decoration: const InputDecoration(
                    hintText: 'Description',
                    border: InputBorder.none,
                  ),
                  maxLines: null,
                  textInputAction: TextInputAction.newline,
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: GestureDetector(
                    onTap: _showMembersEditDialog,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Icon(
                          Ionicons.people_outline,
                          color: kTextColorGrey,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        if (_members.isEmpty)
                          Text(
                            'No Member Added',
                            style: CustomTextStyle.bodyMedium(context).copyWith(
                              color: kTextColorGrey,
                            ),
                          )
                        else
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Members',
                                style:
                                    CustomTextStyle.subText(context).copyWith(
                                  color: kTextColorGrey,
                                ),
                              ),
                              StackImage(
                                imageUrlList:
                                    _members.map((e) => e.photoUrl).toList(),
                                totalCount: _members.length,
                                imageSize: 24,
                              ),
                            ],
                          ),
                        const SizedBox(
                          width: 5,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: kDefaultPadding,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    style: ButtonStyle(
                      textStyle: MaterialStateTextStyle.resolveWith(
                        (states) {
                          if (states.contains(MaterialState.disabled)) {
                            return CustomTextStyle.bodyLarge(context);
                          }
                          return CustomTextStyle.bodyLarge(context);
                        },
                      ),
                    ),
                    onPressed: _isBUttonActive ? () {} : null,
                    child: const Text(
                      'Create',
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
