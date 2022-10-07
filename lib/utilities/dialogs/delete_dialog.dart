import 'package:flutter/material.dart';
import 'package:notes/extensions/extensions.dart';
import 'package:notes/utilities/dialogs/dialog.dart';

Future<bool> showDeleteDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: context.loc.delete,
    content: context.loc.delete_note_prompt,
    optionsBuilder: () => {
      context.loc.cancel: false,
      context.loc.yes: true,
    },
  ).then(
    (value) => value ?? false,
  );
}
