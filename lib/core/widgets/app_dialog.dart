import 'package:flutter/material.dart';

Future<void> showAppDialog({
  required BuildContext context,
  required String title,
  required String message,
}) {
  return showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("حسناً"),
          ),
        ],
      );
    },
  );
}