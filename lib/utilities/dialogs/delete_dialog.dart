import 'package:flutter/material.dart';
import 'package:note_post/utilities/dialogs/generic_dialog.dart';

Future<bool> showDeleteDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context, 
    title: 'Delete', 
    content: 'Do you want to delete this note ?', 
    optionsBuilder: () => {
      'Cancel' : false,
      'Yes' : true,
    } ,
  ).then((value) => value ?? false);
}  