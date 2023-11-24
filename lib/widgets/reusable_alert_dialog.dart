import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_clean_solid/extension/quicksand_text_style.dart';
import 'package:todo_clean_solid/shared_export.dart';

// Assuming quickSandTextStyle is a custom text style you've defined elsewhere
// and MyFontWeight is an enum or class with predefined font weights.

class ReusableAlertDialog extends StatelessWidget {
  final String title;
  final String content;
  final String confirmButtonText;
  final String cancelButtonText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  const ReusableAlertDialog({
    Key? key,
    required this.title,
    required this.content,
    this.confirmButtonText = 'OK',
    this.cancelButtonText = 'Cancel',
    this.onConfirm,
    this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        TextButton(
          child: Text(
            cancelButtonText,
            style: appTextStyle.getQuicksand(MyFontWeight.semiBold),
          ),
          onPressed: () {
            if (onCancel != null) {
              onCancel!();
            } else {
              context.pop();
            }
          },
        ),
        TextButton(
          child: Text(
            confirmButtonText,
            style: appTextStyle.getQuicksand(MyFontWeight.regular).copyWith(color: Colors.red),
          ),
          onPressed: () {
            if (onConfirm != null) {
              onConfirm!();
            } else {
              context.pop();
            }
          },
        ),
      ],
    );
  }

  static void show(
    BuildContext context, {
    required String title,
    required String content,
    String confirmButtonText = 'OK',
    String cancelButtonText = 'Cancel',
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) => ReusableAlertDialog(
        title: title,
        content: content,
        confirmButtonText: confirmButtonText,
        cancelButtonText: cancelButtonText,
        onConfirm: onConfirm,
        onCancel: onCancel,
      ),
    );
  }
}
