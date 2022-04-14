import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'SignIn.dart';
import 'SignUpActivity.dart';

class WelcomeActivity extends StatelessWidget {
  const WelcomeActivity({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const WelcomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<WelcomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark),
    child: Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 59,
            ),
            Expanded(
              child: Image.asset(
                "assets/launcher_icon.png",
                height: 140,
                width: 140,
              ),
              flex: 1,
            ),

            SizedBox(
              height: 20,
            ),
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 6, bottom: 2),
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      "Welcome to TagChat",
                      style: TextStyle(
                          fontSize: 30, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 6, bottom: 40),
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      "Create an account or login to continue.",
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 19, color: Colors.black87),
                    ),
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
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder:(context) => SignUpPage(title: '',)));
                        },
                        child: const Text(
                          "Create an account.",
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
                          Navigator.push(context, MaterialPageRoute(builder:(context) => SignInPage(title: '',)));
                        },
                        child: const Text(
                          "Already have an account.",
                          style:
                          TextStyle(color: Colors.blue, fontSize: 19),
                        )),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }

}