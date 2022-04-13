
import 'package:flutter/material.dart';
class AddPeople extends StatefulWidget {
  @override
  _DialogsState createState() => _DialogsState();
}
class _DialogsState extends State<AddPeople> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Custom Dialog In Flutter"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        child: Center(
          child: RaisedButton(
            onPressed: (){
              showDialog(context: context,
                  builder: (BuildContext context){
                    return Text("hello");
                  }
              );
            },
            child: Text("Custom Dialog"),
          ),
        ),
      ),
    );
  }
}