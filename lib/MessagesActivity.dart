import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:hotmessage/Constants.dart';
import 'package:hotmessage/MessageModel.dart';
import 'package:hotmessage/UserModel.dart';
import 'package:visibility_detector/visibility_detector.dart';

class chatDocsActivity extends StatelessWidget {
  const chatDocsActivity({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MessagesPage(
          title: 'Flutter Demo Home Page', from: "f", herRealID: "f"),
    );
  }
}

class MessagesPage extends StatefulWidget {
  const MessagesPage({Key? key,
    required this.title,
    required this.from,
    required this.herRealID})
      : super(key: key);
  final String title;
  final String from;
  final String herRealID;

  @override
  State<MessagesPage> createState() => _MyMessagePageState();
}

class _MyMessagePageState extends State<MessagesPage> {
  // List<Map<String, dynamic>> chatDocs = [];
  late bool accepted = false;
  String reqID = "";
  String acceptorID = "";
  String key = "";
  String? myID = "";
  String herID = "";
  String herImg = "";
  String myImg = "";
  var chatDocs;
  TextEditingController controller = TextEditingController();
  ScrollController listScrollController = ScrollController();
  bool _despose = false;
  String name = "NO Name";
  String herName = "NO Name";
  String tag = "NOTAGGUY";
  String herTag = "NOTAGGUY";

  @override
  void initState() {

    key = widget.title;
    controller.removeListener(() {});
    // TODO: implement initState
    myID = FirebaseAuth.instance.currentUser?.uid.toString();
    DocumentReference documentReference =
    FirebaseFirestore.instance.collection('chats').doc(key);
    documentReference.snapshots().listen((querySnapshot) {
      try {
        accepted = querySnapshot.get("accepted");
        acceptorID = querySnapshot.get("acceptorID");
        reqID = querySnapshot.get("requestorID");
        if (reqID == myID) {
          herID = acceptorID;
        } else {
          herID = reqID;
        }
        if (accepted) {
          FirebaseFirestore.instance
              .collection("users")
              .doc(myID)
              .get()
              .then((value) {
              name = value["name"];
              tag = value["tag"];


            myImg = value["image"]!;
          });
          FirebaseFirestore.instance
              .collection("users")
              .doc(herID)
              .get()
              .then((value) {
            setState(() {
              herName = value["name"];
              herTag = value["tag"];
              herImg = value["image"];
            });
          });
        }
      } catch (e) {}

    });

    if (widget.from == "search") {
      herID = widget.herRealID;
    }
    super.initState();
  }

  @override
  void dispose() {
    _despose = true;
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    //   getData();

    String? uid = FirebaseAuth.instance.currentUser?.uid;
    String writeMessaged = "";

    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
            Container(
            width: 42,
            height: 42,
             child: CircleAvatar(
                radius: 56,
                backgroundColor: Colors.black,
                child: ClipOval(
                    child:
                    herImg !=  ""?(Image.network(
                      herImg,
                      fit: BoxFit.fitHeight,
                    )): Image.asset("assets/user.png")),
              )),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 17),
                  child: Column(mainAxisSize: MainAxisSize.max, children: [
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        herName,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        "@" + herTag,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Color(0xffE2E2E2),
                          fontSize: 13,
                        ),
                      ),
                    )
                  ]),
                  alignment: Alignment.bottomLeft,
                ),
              ),
            ],
          ),
        ),
        body:
        FutureBuilder(
            initialData: FirebaseAuth.instance.currentUser,
            builder: (context, futureSnapshot) {
              if (futureSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return StreamBuilder(

                  stream: FirebaseFirestore.instance
                      .collection('chats')
                      .doc(key)
                      .collection("messages")
                      .orderBy('dateTime', descending: true)
                      .snapshots(),

                  builder: (context, chatSnapshot) {
                    print("refresh");
                    if (chatSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    chatDocs =
                        (chatSnapshot as AsyncSnapshot).data.docs;
                    print(chatDocs.length);
                    return
                      Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: false,
                                  controller: listScrollController,
                                  reverse: true,
                                  itemCount: chatDocs.length,
                                  itemBuilder: (BuildContext context,
                                      int index) {
                                    // scrollToBottom();

                                    String message = chatDocs[index]["message"];
                                    return VisibilityDetector(
                                      key: Key(chatDocs[index]["id"]),

                                      onVisibilityChanged: (
                                          VisibilityInfo info) {
                                        if (chatDocs[index]["senderID"] !=
                                            myID && !chatDocs[index]["seen"]) {
                                          FirebaseFirestore.instance.collection(
                                              "chats")
                                              .doc(key)
                                              .collection("messages")
                                              .doc(chatDocs[index]["id"])
                                              .update({
                                            "seen": true
                                          });
                                        }
                                      },
                                      child: Row(
                                          mainAxisAlignment:
                                          chatDocs[index]["senderID"] == uid
                                              ? MainAxisAlignment.end
                                              : MainAxisAlignment.start,
                                          children: [
                                            Flexible(
                                                child: Container(
                                                    padding: EdgeInsets.only(
                                                        left: 6,
                                                        right: 6,
                                                        top: 8,
                                                        bottom: 8),
                                                    margin: EdgeInsets.only(
                                                        left: chatDocs[index]
                                                        ["senderID"] ==
                                                            uid
                                                            ? 100
                                                            : 10,
                                                        right: chatDocs[index]
                                                        ["senderID"] ==
                                                            uid
                                                            ? 10
                                                            : 100,
                                                        top: 7),
                                                    decoration: BoxDecoration(
                                                        color: chatDocs[index]
                                                        ["senderID"] ==
                                                            uid
                                                            ? Colors.blue
                                                            : Color(0xffe5e5e5),
                                                        borderRadius: BorderRadius
                                                            .all(
                                                            Radius.circular(
                                                                8.0))),
                                                    child: Column(
                                                      mainAxisSize: MainAxisSize
                                                          .min,
                                                      children: <Widget>[
                                                        Container(
                                                          child: Text(
                                                            message,
                                                            style: TextStyle(
                                                                color: chatDocs[index]
                                                                [
                                                                "senderID"] ==
                                                                    uid
                                                                    ? Colors
                                                                    .white
                                                                    : Colors
                                                                    .black,
                                                                fontSize: 19),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 8.0,
                                                        ),
                                                        Container(
                                                          child: Padding(
                                                            padding: EdgeInsets
                                                                .only(
                                                                top: 6.0),
                                                            child: Text(
                                                              index == 0
                                                                  ? chatDocs[index]
                                                              ["seen"]
                                                                  ? GetTimeAgo.parse(chatDocs[index]["dateTime"].toDate())+" Seen"
                                                                  : GetTimeAgo.parse(chatDocs[index]["dateTime"].toDate())+  " Delivered"
                                                                  : GetTimeAgo.parse(chatDocs[index]["dateTime"].toDate()),
                                                              style: TextStyle(
                                                                fontSize: 13.0,
                                                                color: chatDocs[index]
                                                                [
                                                                "senderID"] ==
                                                                    uid
                                                                    ? Colors
                                                                    .white60
                                                                    : Colors
                                                                    .black45,
                                                              ),
                                                              textAlign:
                                                              TextAlign.right,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 8.0,
                                                        ),
                                                      ],
                                                    )))
                                          ]),
                                    );
                                  }),),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 45,
                                    child: TextField(
                                      onChanged: (v) {
                                        writeMessaged = v;
                                      },
                                      controller: controller,
                                      style: TextStyle(
                                          backgroundColor: Color(0xffececec),
                                          fontSize: 19),
                                      decoration: InputDecoration.collapsed(
                                        hintText: "Write something..",
                                        border: InputBorder.none,
                                      ),
                                    ),
                                    padding:
                                    EdgeInsets.only(
                                        left: 15, right: 10, top: 3, bottom: 3),
                                    margin: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                        color: Color(0xffececec)),
                                    alignment: Alignment.centerLeft,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    sendMessage(writeMessaged);
                                  },
                                  child: SizedBox(
                                    height: 42,
                                    width: 42,
                                    child: Icon(
                                      Icons.send,
                                      size: 32,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ]);
                  });
            }));
  }

  sendMessage(message) {
    if (message
        .toString()
        .isNotEmpty) {
      DateTime currentPhoneDate = DateTime.now(); //DateTime

      Timestamp myTimeStamp = Timestamp.fromDate(currentPhoneDate);

      if (chatDocs.length <= 0) {
        FirebaseFirestore.instance.collection("chats").doc(key).set({
          "requestorID": FirebaseAuth.instance.currentUser?.uid,
          "createdTime": myTimeStamp,
          "accepted": false,
          "acceptorID": this.herID,
        });
        //  reqID = FirebaseAuth.instance.currentUser?.uid.toString();
      } else if (reqID != FirebaseAuth.instance.currentUser?.uid && !accepted) {
        FirebaseFirestore.instance.collection("chats").doc(key).update({
          "acceptorID": FirebaseAuth.instance.currentUser?.uid,
          "accepted": true,
        });
        FirebaseFirestore.instance
            .collection("users")
            .doc(herID)
            .get()
            .then((value) {
          setState(() {
            herName = value["name"];
            herTag = value["tag"];
            herImg = value["image"];
          });
        });
      } else {}
      String createdID = FirebaseFirestore.instance
          .collection("chats")
          .doc(key)
          .collection("messages")
          .doc()
          .id
          .toString();
      FirebaseFirestore.instance
          .collection("chats")
          .doc(key)
          .collection("messages")
          .doc(createdID)
          .set({
        'dateTime': myTimeStamp,
        'message': message,
        'seen': false,
        'id': createdID,
        'senderID': FirebaseAuth.instance.currentUser?.uid,
        'messageType': Constants.MESSAGE_TYPE_TEXT,
      });
      FirebaseFirestore.instance
          .collection("users")
          .doc(myID)
          .collection("messages")
          .doc(key)
          .set({
        'id': key,
        'herImage': herImg,
        'lastMessage': message,
        'lastDate': myTimeStamp,
        'name': herName,
        'seen': false,
        'tag': herTag,
      });

      FirebaseFirestore.instance
          .collection("users")
          .doc(herID)
          .collection("messages")
          .doc(key)
          .set({
        'id': key,
        'herImage': herImg,
        'lastMessage': message,
        'lastDate': myTimeStamp,
        'name': name,
        'seen': false,
        'tag': tag,
      });
      controller.text = "";
    }
  }
}
