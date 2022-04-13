import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("Sign In"),
        ),
      ),
      body: Row(
        children: [
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
                      "Enter your email and password.",
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
                            child: Text(
                              "SignIn",
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () async {
                              showLoaderDialog(context);
                              try {
                                User? user = (await FirebaseAuth.instance
                                    .signInWithEmailAndPassword(
                                  email: emailValue,
                                  password: passValue,
                                )).user;
                                if (user != null) {
                                  Navigator.pop(context);
                                  Navigator.of(context)
                                      .pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                          const MyApp()));
                                } else {
                                  Navigator.pop(context);
                                }
                              }catch(e){
                                Navigator.pop(context);
                                showAlertDialog(context, "Error Login", e.toString());
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: Text.rich(
                            TextSpan(
                              text: 'Doesn\'t have an account? ',
                              children: [
                                TextSpan(
                                    recognizer: TapGestureRecognizer()..onTap = (){
                                      Navigator.of(context)
                                          .pushReplacement(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                              const SignUpPage(title: "")));
                                    },
                                    text: 'Click here to create.',
                                    style: TextStyle(
                                      color: Colors.red,
                                      decoration: TextDecoration.underline,
                                    )),
                                // can add more TextSpans here...
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
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
