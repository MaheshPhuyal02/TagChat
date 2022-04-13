import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Dialogs{

  static showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          const CircularProgressIndicator(),
          Container(
              margin: const EdgeInsets.only(left: 7), child: const Text("Loading...")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  static showAlertDialog(BuildContext context, String title, mess) {
    // set up the button
    // mess = mess.toString().lastIndexOf("]");
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        try {
          Navigator.pop(context);
        }catch(e){

        }
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(mess),
      actions: [
        okButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

}