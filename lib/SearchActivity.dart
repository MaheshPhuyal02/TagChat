import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hotmessage/MessagesActivity.dart';
import 'package:hotmessage/UserModel.dart';

import 'EditProfile.dart';

class SearchActivity extends StatelessWidget {
  const SearchActivity({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SearchPage(title: 'Flutter Demo Home Page'),
    );
  }
}

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<SearchPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<SearchPage> {
  final globalKey = GlobalKey<ScaffoldState>();
  final TextEditingController _controller = TextEditingController();
  List searchresult = [];
  var chatDocs;
  String value = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller.addListener(() {
      refreshList();
    });
  }

  refreshList() {
    setState(() {
      value = _controller.text;
      print("Refresh");
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: buildAppBar(context),

        body: Container(
            child: FutureBuilder(
                initialData: FirebaseAuth.instance.currentUser,
                builder: (context, futureSnapshot) {
                  if (futureSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(FirebaseAuth.instance.currentUser?.uid)
                          .collection("messages")
                          .where("name", isGreaterThanOrEqualTo: value)
                          .where("name", isLessThanOrEqualTo: value + "\uF7FF")
                          .snapshots(),
                      builder: (context, chatSnapshot) {
                        if (chatSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        chatDocs =
                            (chatSnapshot as AsyncSnapshot).data.docs;
                        print(chatDocs.length);
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Flexible(
                                child:
                                ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: chatDocs.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    //   String listData = chatDocs[index];
                                    return
                                      InkWell(
                                        onTap: (){
                                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => MessagesPage(title: chatDocs[index]["id"], herRealID: '', from: 'm', herImage: '', herName: '', herTag: '',)));
                                        },
                                        child: Card(
                                          margin: EdgeInsets.all(9),
                                          child: Padding(
                                            padding: const EdgeInsets.all(7.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  height: 48,
                                                  width: 48,
                                                  child:CircleAvatar(
                                                    radius: 56,
                                                    backgroundColor: Colors.white,
                                                    child: ClipOval(
                                                      child: chatDocs[index]["herImage"] !=
                                                          "" ? (Image.network(
                                                        chatDocs[index]["herImage"],
                                                        height: 48,
                                                        width: 48,
                                                        fit: BoxFit.cover,
                                                      )) : Image.asset(
                                                          "assets/user.png"))),
                                                  margin: const EdgeInsets.only(
                                                      left: 2, right: 5),
                                                  alignment: Alignment.center,
                                                ),
                                                   Expanded(
                                                     child: Container(
                                                          child: Text(
                                                            chatDocs[index]["name"],
                                                            style: const TextStyle(
                                                                fontSize: 23,
                                                                fontWeight: FontWeight
                                                                    .w500),
                                                          ),
                                                       alignment: Alignment.centerLeft,
                                                        ),
                                                   ),
                                                    ],
                                    ),
                                          ),
                                        ),
                                      );
                                  },
                                ))

                          ],
                        );
                      });
                })));
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      iconTheme: const IconThemeData(color: Colors.black),
      elevation: 1,
      backgroundColor: Colors.white,
      centerTitle: true,
      title: TextField(
        autofocus: true,
        cursorColor: Colors.white,
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
        ),
        controller: _controller,
        decoration: InputDecoration(
          suffixIcon: InkWell(
              onTap: () {
                _controller.text = "";
              },
              child: Icon(
                Icons.close,
                color: Colors.white,
              )),
          hintStyle: const TextStyle(color: Colors.black54),
          hintText: "Search here",
        ),
      ),
    );
  }

}
