import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hotmessage/Dialogs.dart';

class ForgotPassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: ForgotPage(
        title: '',
      ),
    );
  }
}

class ForgotPage extends StatefulWidget {
  const ForgotPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<ForgotPage> createState() => ForgotPageState();
}

class ForgotPageState extends State<ForgotPage> {
  String email = "";

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(children: [
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(9.0),
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.arrow_back_ios,
                    size: 20,
                  ),
                ),
                Expanded(
                    child: Text(
                      "Forgot Password",
                      style: TextStyle(fontSize: 19),
                      textAlign: TextAlign.center,
                    ))
              ],
            ),
          ),
          SizedBox(
            height: 19,
          ),
          Container(
            margin: EdgeInsets.only(left: 6, bottom: 2),
            alignment: Alignment.centerLeft,
            child: const Text(
              "Forgot Password",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 6, bottom: 20),
            alignment: Alignment.centerLeft,
            child: const Text(
              "Enter your email to reset your password.",
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 19, color: Colors.black87),
            ),
          ),
          Container(
              padding: const EdgeInsets.all(9),
              child: TextField(
                  maxLines: 1,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    email = value;
                  },
                  decoration: const InputDecoration(
                    contentPadding: const EdgeInsets.all(10),
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    border: const OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                    ),
                    labelText: 'Enter Email',
                  ))),
          const SizedBox(
            height: 20,
          ),
          Container(
            margin: EdgeInsets.only(left: 5, right: 5),
            width: double.infinity,
            height: 53,
            decoration: const BoxDecoration(
                color: Colors.blue,
                borderRadius: const BorderRadius.all(Radius.circular(4))),
            child: TextButton(
              onPressed: () async {
                Dialogs.showLoaderDialog(context);

                if (email.isNotEmpty) {
                  // FirebaseAuth.instance.sendSignInLinkToEmail(
                  // email: email, actionCodeSettings: null)
                  //     .catchError((onError) => print('Error sending email verification $onError'))
                  //     .then((value) => print('Successfully sent email verification'));
                  FirebaseAuth.instance.sendPasswordResetEmail(email: email)
                      .catchError((onError) =>
                  {
                  Navigator.pop(context),
                    Dialogs.showAlertDialog(context, "Failed",
                        onError.toString())
                  })
                      .then((value) => { //Navigator.pop(context);
                  Navigator.pop(context),
                  Dialogs.showAlertDialog(context, "Done", "Reset password email send successfully.")});

              } else {
                  Navigator.pop(context);
                Dialogs.showAlertDialog(context, "Error", "Please enter email.");
                }
              },
              child: Text("Send Reset link", style: TextStyle(
                  color: Colors.white,
                  fontSize: 19
              ),),
            ),
          )
        ]));
  }
}
