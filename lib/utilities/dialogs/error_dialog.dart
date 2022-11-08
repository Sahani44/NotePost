import 'package:flutter/material.dart';
import 'package:note_post/utilities/dialogs/generic_dialog.dart';

Future<void> showErrorDialog(BuildContext context, String text) {
  return showGenericDialog<void>(
    context: context, 
    title: 'An error occured', 
    content: text, 
    optionsBuilder: () => {
      'OK': null,
    }
  );
}