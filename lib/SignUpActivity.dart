import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hotmessage/ChatListModel.dart';
import 'package:hotmessage/EditProfile.dart';
import 'package:hotmessage/FirebaseManager.dart';
import 'package:hotmessage/SignIn.dart';

import 'main.dart';

class SignUpActivity extends StatelessWidget {
  const SignUpActivity({Key? key}) : super(key: key);

// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SignUpPage(title: 'Flutter Demo Home Page'),
    );
  }
}

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<SignUpPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<SignUpPage> {
  String tagErrorValue = "";
  String emailValue = "";
  String passValue = "";
  String nameValue = "";
  late bool isTagAvailable = false;
  late String tagValue = "";
  late TextField tag;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark),
        child: Scaffold(
            backgroundColor: Colors.white,
            body: Row(children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const SizedBox(
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
                            const Expanded(
                                child: const Text(
                              "Create account",
                              style: TextStyle(fontSize: 19),
                              textAlign: TextAlign.center,
                            ))
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 19,
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 6, bottom: 2),
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          "Create account",
                          style: TextStyle(
                              fontSize: 28, fontWeight: FontWeight.w600),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 6, bottom: 20),
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          "Remember Email and tag cannot be changed. Once you verified.",
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
                                  contentPadding: EdgeInsets.all(10),
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)),
                                  ),
                                  labelText: "Enter Email",
                                )),
                            const SizedBox(
                              height: 20,
                            ),
                            TextField(
                                maxLines: 1,
                                keyboardType: TextInputType.name,
                                onChanged: (value) {
                                  nameValue = value;
                                },
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.all(10),
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)),
                                  ),
                                  labelText: "User Name",
                                )),
                            const SizedBox(
                              height: 20,
                            ),
                            TextField(
                                maxLines: 1,
                                keyboardType: TextInputType.name,
                                onChanged: (value) {
                                  tagValue = value;
                                  //Do something with the user input.
                                },
                                decoration: const InputDecoration(
                                  prefix: Text("@"),
                                  contentPadding: const EdgeInsets.all(10),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.auto,
                                  border: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                        const Radius.circular(4)),
                                  ),
                                  labelText: 'Tag',
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
                              height: 35,
                            ),
                            Container(
                              width: double.infinity,
                              height: 53,
                              decoration: const BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(4))),
                              child: TextButton(
                                  onPressed: () async {
                                    showLoaderDialog(context);
                                    //  bool iss = FirebaseManager().checkTag(tagValue);
                                    //    print(iss);
                                    try {
                                      var t = [];
                                      // print(tagValue);
                                      bool isSubmitted = false;
                                      FirebaseFirestore.instance
                                          .collection("tags")
                                          .where("tag", isEqualTo: tagValue)
                                          .snapshots()
                                          .forEach((element) async {
                                        if (element.docs.isEmpty) {
                                          // Navigator.pop(context);
                                          //  if (t.isEmpty) {
                                          isSubmitted = true;
                                          FirebaseAuth auth =
                                              FirebaseAuth.instance;
                                          try {
                                            User? user = (await auth
                                                    .createUserWithEmailAndPassword(
                                              email: emailValue,
                                              password: passValue,
                                            ))
                                                .user;

                                            if (user != null) {
                                              FirebaseFirestore firestore =
                                                  FirebaseFirestore.instance;
                                              await firestore
                                                  .collection("users")
                                                  .doc(user.uid)
                                                  .set({
                                                "email": emailValue,
                                                "name": nameValue,
                                                "tag": tagValue,
                                                "image": "",
                                                "bio": "",
                                                "userid": user.uid,
                                              });
                                              //   Navigator.pop(context);
                                              List<String> s = <String>[];
                                              s.add(tagValue);
                                              await FirebaseFirestore.instance
                                                  .collection('tags')
                                                  .doc(FirebaseFirestore
                                                      .instance
                                                      .collection("tags")
                                                      .doc()
                                                      .id)
                                                  .set({
                                                "tag": tagValue,
                                                "id": FirebaseAuth
                                                    .instance.currentUser?.uid,
                                              });
                                                Navigator.pop(context);
                                                Navigator.of(context)
                                                    .pushAndRemoveUntil(
                                                  MaterialPageRoute(
                                                      builder: (builder) =>
                                                          EditProfilePage(
                                                              title: "")),
                                                  (route) => false,
                                                );

                                            } else {
                                              isSubmitted = false;
                                              Navigator.pop(context);
                                              showAlertDialog(context, "Failed",
                                                  "Failed to create account.");
                                            }
                                          } catch (e) {
                                            isSubmitted = false;
                                            Navigator.pop(context);
                                            showAlertDialog(
                                                context, "Error", e.toString());
                                          }
                                        } else {
                                          if (!isSubmitted) {
                                            Navigator.pop(context);
                                            showAlertDialog(
                                                context,
                                                "Tag Invalid",
                                                "Tag is not available.");
                                          }
                                        }
                                      });
                                      // print(has);

                                    } catch (e) {}
                                  },
                                  child: const Text(
                                    "Signup to continue",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 19),
                                  )),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 5, right: 5),
                        width: double.infinity,
                        height: 53,
                        decoration: const BoxDecoration(
                            border: Border.fromBorderSide(BorderSide(
                                color: Colors.blue, style: BorderStyle.solid)),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(4))),
                        child: TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const SignInPage(
                                            title: '',
                                          )));
                            },
                            child: const Text(
                              "Already have an account?",
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 19),
                            )),
                      ),
                      const SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                ),
              ),
            ])));
  }

  showAlertDialog(BuildContext context, String title, mess) {
    // set up the button
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.pop(context);
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
