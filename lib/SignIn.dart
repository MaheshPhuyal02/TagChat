import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hotmessage/SignUpActivity.dart';

import 'main.dart';

class SignIn extends StatelessWidget {
  const SignIn({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SignInPage(title: 'Flutter Demo Home Page'),
    );
  }
}

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<SignInPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<SignInPage> {
  String emailValue = "";
  String passValue = "";

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark),
      child: Scaffold(
        body: Row(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(
                      height: 29,
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
                            "Login",
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
                        "Login",
                        style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 6, bottom: 20),
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        "Enter your email and password to login.",
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 19, color: Colors.black87),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(9),
                      child: Column(
                        children: [
                          TextField(
                              maxLines: 1,
                              keyboardType: TextInputType.emailAddress,
                              onChanged: (value) {
                                emailValue = value;
                              },
                              decoration: const InputDecoration(
                                contentPadding: const EdgeInsets.all(10),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.auto,
                                border: const OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(4)),
                                ),
                                labelText: 'Enter Email',
                              )),
                          const SizedBox(
                            height: 20,
                          ),
                          TextField(
                              maxLines: 1,
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: true,
                              onChanged: (value) {
                                passValue = value;
                              },
                              decoration: const InputDecoration(
                                contentPadding: const EdgeInsets.all(10),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.auto,
                                border: const OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(4)),
                                ),
                                labelText: 'Enter password',
                              )),
                          const SizedBox(
                            height: 12,
                          ),
                          Container(
                            padding: EdgeInsets.only(right: 4),
                            alignment: Alignment.centerRight,
                            width: double.infinity,
                            child: Text(
                              "Forget password?",
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 5, right: 5),
                            width: double.infinity,
                            height: 53,
                            decoration: const BoxDecoration(
                                color: Colors.blue,
                                borderRadius:
                                const BorderRadius.all(Radius.circular(4))),
                            child: TextButton(

                                  onPressed: () async {
                                    showLoaderDialog(context);
                                    try {
                                      User? user = (await FirebaseAuth.instance
                                          .signInWithEmailAndPassword(
                                        email: emailValue,
                                        password: passValue,
                                      ))
                                          .user;
                                      if (user != null) {
                                        Navigator.pop(context);
                                        Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                const MyApp()));
                                      } else {
                                        Navigator.pop(context);
                                      }
                                    } catch (e) {
                                      Navigator.pop(context);
                                      showAlertDialog(
                                          context, "Error Login", e.toString());
                                    }
                                 },

                                child: const Text(
                                  "Continue to login",
                                  style:
                                  TextStyle(color: Colors.white, fontSize: 19),
                                )),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 5, right: 5),
                            width: double.infinity,
                            height: 53,
                            decoration: const BoxDecoration(
                                border: Border.fromBorderSide(BorderSide(
                                    color: Colors.blue, style: BorderStyle.solid)),
                                borderRadius:
                                const BorderRadius.all(Radius.circular(4))),
                            child: TextButton(
                                onPressed: (){
                                  Navigator.push(context, MaterialPageRoute(builder:(context) => SignUpPage(title: '',)));
                                },
                                child: const Text(
                                  "Doesn't have an account?",
                                  style:
                                  TextStyle(color: Colors.blue, fontSize: 19),
                                )),
                          ),

                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context, String title, mess) {
    // set up the button
    // mess = mess.toString().lastIndexOf("]");
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        try {
          Navigator.pop(context);
        } catch (e) {}
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

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          const CircularProgressIndicator(),
          Container(
              margin: const EdgeInsets.only(left: 7),
              child: const Text("Loading...")),
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
}
