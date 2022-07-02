import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:join_me/data/models/attachment.dart';
import 'package:join_me/generated/locale_keys.g.dart';
import 'package:join_me/task/bloc/task_attachment_bloc.dart';
import 'package:join_me/utilities/constant.dart';
import 'package:join_me/widgets/bottom_sheet/selection_bottom_sheet.dart';
import 'package:mime/mime.dart';

class AttachmentItem extends StatelessWidget {
  const AttachmentItem(this.attachment, {Key? key}) : super(key: key);
  final Attachment attachment;
  bool isImage(String path) {
    final mimeType = lookupMimeType(path);
    return mimeType!.startsWith('image/');
  }

  void _showOptionMenu(BuildContext ctx) {
    showModalBottomSheet<dynamic>(
      useRootNavigator: true,
      barrierColor: Colors.black.withOpacity(0.5),
      isScrollControlled: true,
      context: ctx,
      shape: const RoundedRectangleBorder(
        // <-- for border radius
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(kDefaultRadius),
          topRight: Radius.circular(kDefaultRadius),
        ),
      ),
      builder: (context) {
        return SelectionBottomSheet(
          title: LocaleKeys.projectViewType_title.tr(),
          listSelections: [
            SelectionRow(
              onTap: () {
                AutoRouter.of(context).pop();
                ctx
                    .read<TaskAttachmentBloc>()
                    .add(DeleteAttachment(attachment));
              },
              color: Theme.of(context).errorColor,
              title: LocaleKeys.button_delete.tr(),
              iconData: Ionicons.trash_bin_outline,
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints:
          const BoxConstraints(minWidth: 80, maxWidth: 230, maxHeight: 120),
      margin: const EdgeInsets.all(5),
      decoration: isImage(attachment.fileName)
          ? null
          : BoxDecoration(
              border: Border.all(color: kTextColorGrey),
              borderRadius: BorderRadius.circular(kDefaultRadius),
            ),
      child: isImage(attachment.fileName)
          ? GestureDetector(
              onLongPress: () => _showOptionMenu(context),
              onTap: () {
                context
                    .read<TaskAttachmentBloc>()
                    .add(DownloadAttachments(attachment));
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(kDefaultRadius),
                child: Image.network(
                  attachment.downloadLink,
                ),
              ),
            )
          : ListTile(
              dense: true,
              minLeadingWidth: 40,
              shape: kBorderRadiusShape,
              visualDensity: VisualDensity.compact,
              onLongPress: () => _showOptionMenu(context),
              onTap: () {
                context
                    .read<TaskAttachmentBloc>()
                    .add(DownloadAttachments(attachment));
              },
              leading: Icon(
                _getIcon(attachment),
                size: 32,
              ),
              title: Text(
                attachment.fileName,
                style: const TextStyle(fontSize: 14),
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text('${attachment.fileExt} - ${attachment.size}'),
            ),
    );
  }

  IconData _getIcon(Attachment attachment) {
    switch (attachment.fileExt) {
      case '.zip':
        return Icons.folder_zip_outlined;
      case '.pdf':
        return Icons.picture_as_pdf_outlined;
      case 'doc':
        return Ionicons.document;
      default:
        return Icons.file_present_outlined;
    }
  }
}
