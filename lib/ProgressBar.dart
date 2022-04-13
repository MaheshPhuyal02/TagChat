import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProgressBar extends StatefulWidget {
  @override
  _CircularProgressIndicatorClassState createState() => _CircularProgressIndicatorClassState();
}

class _CircularProgressIndicatorClassState extends State<ProgressBar> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(
            Icons.arrow_forward_ios_rounded
        ),
        onPressed: (){
          setState(() {
            loading = !loading;

          });
        },
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal:38),
        child: Center(
          child: loading?CircularProgressIndicator():Text(
            "No task to do",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,

            ),
          ),
        ),
      ),
    );
  }
}