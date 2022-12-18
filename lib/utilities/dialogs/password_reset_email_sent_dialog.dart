import 'package:flutter/cupertino.dart';
import 'package:note_post/utilities/dialogs/generic_dialog.dart';

Future<void> showPasswordResetSentDialog(BuildContext context) {
  return showGenericDialog(
    context: context, 
    title: 'Password Reset', 
    content: 'Password reset link sent', 
    optionsBuilder: () => {
      'OK': null,
    },
  );
}