import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class showEvent{
  void showCustomSnackbar(BuildContext context, String message, {bool isError = false}) {
    final snackBar = SnackBar(
      content: Text(message, style: TextStyle(color: Colors.white)),
      backgroundColor: isError ? Colors.red : Colors.green,
      behavior: SnackBarBehavior.floating,
      duration: Duration(seconds: 2),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Không cho phép tắt dialog khi bấm ngoài
      builder: (context) {
        return const Dialog(
          backgroundColor: Colors.transparent,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

}