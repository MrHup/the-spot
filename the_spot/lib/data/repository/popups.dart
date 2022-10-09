import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:the_spot/config/theme_data.dart';
import 'package:fluttertoast/fluttertoast.dart';

void blockUser(BuildContext context) {
  showDialog(
      // The user CANNOT close this dialog  by pressing outsite it
      barrierDismissible: false,
      context: context,
      builder: (_) {
        return Dialog(
          backgroundColor: Theme.of(context).backgroundColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                CircularProgressIndicator(color: AppThemes.accentColor),
                SizedBox(
                  height: 15,
                ),
                Text('Loading...', style: AppThemes.text_description_white)
              ],
            ),
          ),
        );
      });
}

void showSimpleToast(String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: CupertinoColors.systemGrey,
      textColor: Colors.white,
      fontSize: 16.0);
}
