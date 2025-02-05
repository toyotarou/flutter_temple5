import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
Future<void> caution_dialog(
    {required BuildContext context, String? title, required String content}) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.black.withOpacity(0.3),
        title: (title != null)
            ? Text(
                title,
                style: const TextStyle(color: Colors.white),
              )
            : null,
        content: Text(
          content,
          style: const TextStyle(color: Colors.white),
        ),
      );
    },
  );
}
