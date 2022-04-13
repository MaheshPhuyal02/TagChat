import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hotmessage/ChatListModel.dart';
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
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
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
    tag = TextField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        onChanged: (value) {
          tagValue = value;
          //Do something with the user input.
        },
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(10),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                isTagAvailable = FirebaseManager().checkTag(tagValue);
                //isTagAvailable = true;
                //  print(tagValue);
              });
            },
            icon: const Icon(Icons.refresh),
          ),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          labelText: 'Tag',
        ));
    return Scaffold(
        appBar: AppBar(
            title: const SizedBox(
          width: double.infinity,
          child: Text(
            'Create Account',
            textAlign: TextAlign.center,
            style: TextStyle(),
          ),
        )),
        body: Row(children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    height: 80,
                    alignment: Alignment.center,
                    child: const Text(
                      "Welcome",
                      style:
                          TextStyle(fontSize: 34, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Container(
                    height: 120,
                    alignment: Alignment.center,
                    child: const Text(
                      "Remember Email and tag cannot be changed. Once you verified.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 21,
                      ),
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
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              border: const OutlineInputBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8)),
                              ),
                              labelText: 'Enter Email',
                            )),
                        const SizedBox(
                          height: 20,
                        ),
                        TextField(
                            maxLines: 1,
                            onChanged: (value) {
                              nameValue = value;
                            },
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              contentPadding: const EdgeInsets.all(10),
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              border: const OutlineInputBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8)),
                              ),
                              labelText: 'Enter UserName',
                            )),
                        const SizedBox(
                          height: 20,
                        ),
                        TextField(
                            maxLines: 1,
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (value) {
                              tagValue = value;
                              //Do something with the user input.
                            },
                            decoration: const InputDecoration(
                              prefix: Text("@"),
                              contentPadding: const EdgeInsets.all(10),
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              border: OutlineInputBorder(
                                borderRadius:
                                    const BorderRadius.all(const Radius.circular(8)),
                              ),
                              labelText: 'Tag',
                            )),
                        const SizedBox(
                          height: 12,
                        ),
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
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              border: const OutlineInputBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8)),
                              ),
                              labelText: 'Enter password',
                            )),
                        const SizedBox(
                          height: 30,
                        ),
                        Container(
                          width: 380,
                          height: 38,
                          decoration: const BoxDecoration(
                              color: Colors.blue,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20))),
                          child: TextButton(
                              onPressed: () async {
                                showLoaderDialog(context);
                                //  bool iss = FirebaseManager().checkTag(tagValue);
                                //    print(iss);
                                try {
                                  var t = [];
                                FirebaseFirestore.instance.collection("tags")
                                  .where("tag", isEqualTo: tagValue)
                                  .snapshots().forEach((element) {
                                    element.docs.forEach((element) {
                                      t.add( element.get("tag"));
                                    });
                                });

                                  // first add the data to the Offset object
                                    if (!t.contains(tagValue)) {
                                      FirebaseAuth auth = FirebaseAuth.instance;
                                      try {
                                        User? user = (await auth
                                            .createUserWithEmailAndPassword(
                                          email: emailValue,
                                          password: passValue,
                                        )).user;

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
                                          Navigator.pop(context);
                                          List<String> s = <String>[];
                                          s.add(tagValue);
                                          await FirebaseFirestore.instance
                                              .collection('tags')
                                              .doc(FirebaseFirestore.instance
                                              .collection("tags")
                                              .doc()
                                              .id)
                                              .set({
                                            "tag": tagValue,
                                            "id": FirebaseAuth.instance
                                                .currentUser?.uid,
                                          });
                                          List<ChatListModel> chats = <
                                              ChatListModel>[];

                                          try {
                                            Navigator.of(context)
                                                .pushReplacement(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const MyApp()));
                                          } catch (e) {}
                                        } else {
                                          Navigator.pop(context);
                                          showAlertDialog(context, "Failed",
                                              "Failed to create account.");
                                        }
                                      } catch (e) {
                                        Navigator.pop(context);
                                        showAlertDialog(
                                            context, "Error", e.toString());
                                      }
                                    } else {
                                      Navigator.pop(context);
                                      showAlertDialog(context, "Tag Invalid",
                                          "Tag is not available.");
                                    }

                                  // print(has);

                                }catch(e){

                                }
                              },
                              child: const Text(
                                "Continue", 
                                style: TextStyle(color: Colors.white),
                              )),
                        ),
                      ],
                    ),
                  ),
                   Text.rich(
                    TextSpan(
                      text: 'Already have an account? ',
                      children: [
                        TextSpan(
                        recognizer: TapGestureRecognizer()..onTap = (){
                          Navigator.of(context)
                              .pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) =>
                                  const SignInPage(title: "")));
                        },
                            text: 'Click here to sign in.',
                            style: const TextStyle(
                              color: Colors.red,
                              decoration: TextDecoration.underline,
                            )),
                        // can add more TextSpans here...
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  )],
              ),
            ),
          ),
        ]));
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
}
