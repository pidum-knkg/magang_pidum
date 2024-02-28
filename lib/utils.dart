import 'package:flutter/material.dart';

void gotoPage(Widget page, BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => page,
    ),
  );
}

void showToast(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(msg),
    ),
  );
}
