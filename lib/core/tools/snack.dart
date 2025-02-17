import 'package:flutter/material.dart';
import 'package:owling/core/design.dart';

void showSnackMessage(BuildContext context, String message, {Color? color}) {
  color ??= DesignColors.fore();

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Expanded(
        child: Center(
          child: Text(
            message,
            style: TextStyle(color: color, fontSize: 16),
          ),
        ),
      ),
      duration: Duration(milliseconds: 700),
      backgroundColor: Colors.black,
    ),
  );
}

void showSnackMessageInfo(BuildContext context, String message) {
  showSnackMessage(context, message);
}

void showSnackMessageError(BuildContext context, String message) {
  showSnackMessage(context, message, color: Colors.red);
}
