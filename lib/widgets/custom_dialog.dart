import 'package:flutter/material.dart';
import 'package:todo_clean_solid/extension/quicksand_text_style.dart';
import 'package:todo_clean_solid/shared_export.dart';

void showReusableAlertDialog({
  required BuildContext context,
  required String title,
  required String content,
  String confirmButtonText = 'OK',
  String cancelButtonText = 'NO',
  VoidCallback? onConfirm,
  VoidCallback? onCancel,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            child: Text(
              cancelButtonText,
              style: quickSandTextStyle.getQuicksand(MyFontWeight.semiBold),
            ),
            onPressed: () {
              onCancel?.call();
            },
          ),
          TextButton(
            child: Text(
              confirmButtonText,
              style: quickSandTextStyle.getQuicksand(MyFontWeight.regular).copyWith(color: Colors.red),
            ),
            onPressed: () {
              onConfirm?.call();
            },
          ),
        ],
      );
    },
  );
}
