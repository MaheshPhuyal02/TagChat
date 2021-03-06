import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hotmessage/Constants.dart';
import 'package:hotmessage/MessageModel.dart';
import 'package:hotmessage/Profile.dart';
import 'package:hotmessage/UserModel.dart';
import 'package:image_picker/image_picker.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:timeago/timeago.dart' as timeago;

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
        title: 'Flutter Demo Home Page',
        from: "f",
        herRealID: "f",
        herName: "",
        herImage: "",
        herTag: "",),
    );
  }
}

class MessagesPage extends StatefulWidget {
  const MessagesPage({Key? key,
    required this.title,
    required this.from,
    required this.herRealID,
    required this.herName,
    required this.herTag,
    required this.herImage,
  })
      : super(key: key);
  final String title;
  final String from;
  final String herRealID;
  final String herName;
  final String herTag;
  final String herImage;

  @override
  State<MessagesPage> createState() => _MyMessagePageState();
}

class _MyMessagePageState extends State<MessagesPage> {
  // List<Map<String, dynamic>> chatDocs = [];
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
  bool isBlocked = false;
  bool sheBlocked = false;
  String name = "No Name";
  String herName = "No Name";
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
        acceptorID = querySnapshot.get("acceptorID");
        reqID = querySnapshot.get("requestorID");
        if (reqID == myID) {
          herID = acceptorID;
        } else {
          herID = reqID;
        }
        FirebaseFirestore.instance
            .collection("users")
            .doc(myID)
            .get()
            .then((value) {
          print("listen blovked my id");
          name = value["name"];
          tag = value["tag"];
          myImg = value["image"]!;


        });

        FirebaseFirestore.instance
            .collection("users")
            .doc(herID)
            .get()
            .then((event) {
              print(event.toString());

          // setState(() {
          if (widget.herTag != "" || widget.herName != "" ||
              widget.herImage != "") {
            print("Not null");
            if (event["name"] != widget.herName ||
                event["tag"] != widget.herTag ||
                event["image"] != widget.herImage) {
              setState(() {
                herName = event["name"];
                herTag = event["tag"];
                herImg = event["image"];
              });
            }
          } else {
            print("NULL");
          }
        });
      } catch (e) {}
      if (widget.from == "search") {
        herID = widget.herRealID;
      } else {
        setState(() {
          herImg = widget.herImage;
          herName = widget.herName;
          herTag = widget.herTag;
        });

        print("widget");
      }
      FirebaseFirestore.instance.collection("users")
          .doc(herID)
          .collection("messages")
          .doc(key)
          .snapshots()
          .listen((event) {
        if(event["blocked"]!=null) {
          print("listen blovked her id");
          setState(() {
            sheBlocked = event["blocked"];
          });
        }
      });
      FirebaseFirestore.instance.collection("users")
          .doc(myID)
          .collection("messages")
          .doc(key)
          .snapshots()
          .listen((event) {
        if(event["blocked"]!=null) {
          print("listen blovked her id");
          setState(() {
            isBlocked = event["blocked"];
          });
        }
      });

    });
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
          iconTheme: IconThemeData(color: Colors.black),
          elevation: 1,
          backgroundColor: Colors.white,
          title: Row(
            children: [
              Container(
                  width: 44,
                  height: 44,
                  child: CircleAvatar(
                    radius: 56,
                    backgroundColor: Colors.white,
                    child: ClipOval(
                        child:
                        CachedNetworkImage(
                          fit: BoxFit.cover,
                          height: 44,
                          width: 44,
                          imageUrl: herImg,
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              Image.asset("assets/user.png"),
                        )),
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
                          color: Colors.black,
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
                            color: Color(0xff242424),
                            fontSize: 12,
                          )
                      ),
                    )
                  ]),
                  alignment: Alignment.bottomLeft,
                ),
              ),
              PopupMenuButton(
                  itemBuilder: (context) =>
                  [
                    PopupMenuItem(
                      child: InkWell(child: Text("Delete Chat"),
                      onTap:() async {


                      },),
                      value: 1,
                      onTap: (){
                        print("Deleting");
                        List<String> del = [];
                        del.add(uid.toString());
                        for(int i=0; i< chatDocs.length; i++){
                          
                          FirebaseFirestore.instance.collection("chats")
                              .doc(key)
                              .collection("messages")
                              .doc(chatDocs[i]["id"])
                              .update({
                            "notDeletedBy": FieldValue.arrayRemove(del)
                          });
                        }
                        FirebaseFirestore.instance.collection("users")
                            .doc(uid)
                            .collection("messages")
                            .doc(key)
                            .update({
                             "deleted": true
                        });
                        Navigator.pop(context);
                      },
                    ),
                    PopupMenuItem(
                      onTap: (){
                        FirebaseFirestore.instance.collection("users")
                            .doc(uid)
                            .collection("messages")
                            .doc(key)
                            .update({
                          "blocked": !isBlocked
                        });
                        setState(() {
                          isBlocked = !isBlocked;
                        });
                      },
                      child: Text(
                       isBlocked?"Unblock":"Block", style: TextStyle(color: Colors.red),),
                      value: 2,
                    )
                  ]
              )
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

              print(uid);
              return StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('chats')
                      .doc(key)
                      .collection("messages")
                      .where("notDeletedBy", arrayContains: uid.toString())
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
                                        if(chatDocs != null) {
                                          if (chatDocs[index]["senderID"] !=
                                              myID &&
                                              !chatDocs[index]["seen"]) {
                                            FirebaseFirestore.instance
                                                .collection(
                                                "chats")
                                                .doc(key)
                                                .collection("messages")
                                                .doc(chatDocs[index]["id"])
                                                .update({
                                              "seen": true
                                            });
                                          }
                                        }
                                      },
                                      child: InkWell(
                                        onLongPress: (){
                                          showActionAlert(context);
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
                                                              child:
                                                              chatDocs[index]["messageType"] ==
                                                                  Constants
                                                                      .MESSAGE_TYPE_TEXT
                                                                  ?
                                                              Text(
                                                                message,
                                                                style: TextStyle(
                                                                    color: chatDocs[index]["senderID"] ==
                                                                        uid
                                                                        ? Colors
                                                                        .white
                                                                        : Colors
                                                                        .black,
                                                                    fontSize: 19),
                                                              )
                                                                  :
                                                              CachedNetworkImage(
                                                                fit: BoxFit.cover,
                                                                imageUrl: message,
                                                                placeholder: (
                                                                    context,
                                                                    url) =>
                                                                    CircularProgressIndicator(),
                                                                errorWidget: (
                                                                    context, url,
                                                                    error) =>
                                                                    Image.asset(
                                                                        "assets/user.png"),
                                                              )),
                                                          SizedBox(
                                                            width: 8.0,
                                                          ),
                                                          Container(
                                                            child: Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                  top: 6.0),
                                                              child: Text(
                                                                index == 0 ?
                                                                chatDocs[index]["seen"]
                                                                    ?
                                                                getTimeAgo(
                                                                    chatDocs[index]['dateTime']) +
                                                                    " Seen"
                                                                    : getTimeAgo(
                                                                    chatDocs[index]['dateTime']) +
                                                                    " Delivered"
                                                                    : getTimeAgo(
                                                                    chatDocs[index]['dateTime']),
                                                                style: TextStyle(
                                                                  fontSize: 11.0,
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
                                      ),
                                    );
                                  }),),
                            !getBlocked()?
                            Row(
                              children: [
                                InkWell(
                                  onTap: () async {
                                    final XFile? image = await ImagePicker()
                                        .pickImage(source: ImageSource.gallery,
                                        maxWidth: 500,
                                        maxHeight: 500,
                                        imageQuality: 50);
                                    if (image?.path != null) {
                                      createMessage(image!.path,
                                          Constants.MESSAGE_TYPE_IMAGE);
                                    }
                                  },
                                  child: SizedBox(
                                    height: 42,
                                    width: 47,
                                    child: Icon(
                                      Icons.photo_camera,
                                      size: 32,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
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
                                    createMessage(writeMessaged,
                                        Constants.MESSAGE_TYPE_TEXT);
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
                            ):
                            Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: 10),
                                  color: Colors.black54,
                                  height: 1,
                                  width: double.infinity,
                                ),
                                Container(
                                  padding: EdgeInsets.all(8),
                                  width: double.infinity,
                                  alignment: Alignment.center,
                                  child: Text("You can't reply to this conversation anymore"),
                                ),
                              ],
                            )
                          ]);
                  });
            }));
  }

  String getTimeAgo(s) {
    final date = s.toDate();
    return timeago.format(date).toString();
  }

  createMessage(message, type) {
    if (type == Constants.MESSAGE_TYPE_IMAGE) {
      Reference ref = FirebaseStorage.instance.ref("profile")
          .child(key)
          .child(FirebaseFirestore.instance
          .collection("chats")
          .doc()
          .id + ".png");
      UploadTask uploadTask = ref.putFile(File(message));
      uploadTask.whenComplete(() async {
        String url = await ref.getDownloadURL();
        sendMessage(url, Constants.MESSAGE_TYPE_IMAGE);
      });
    } else {
      sendMessage(message, type);
    }
  }
  bool getBlocked(){
    if(isBlocked || sheBlocked){
      return true;
    } else {
      return false;
    }
}
  sendMessage(message, type) {
    if (message
        .toString()
        .isNotEmpty) {
      DateTime currentPhoneDate = DateTime.now(); //DateTime
      Timestamp myTimeStamp = Timestamp.fromDate(currentPhoneDate);

      if (chatDocs.length <= 0) {
        FirebaseFirestore.instance.collection("chats").doc(key).set({
          "requestorID": FirebaseAuth.instance.currentUser?.uid,
          "createdTime": myTimeStamp,
          "acceptorID": this.herID,
        });
        //  reqID = FirebaseAuth.instance.currentUser?.uid.toString();
      }

      String createdID = FirebaseFirestore.instance
          .collection("chats")
          .doc(key)
          .collection("messages")
          .doc()
          .id
          .toString();
      List<String> notDeletors = [];
      notDeletors.add(myID.toString());
      notDeletors.add(herID.toString());
      FirebaseFirestore.instance
          .collection("chats")
          .doc(key)
          .collection("messages")
          .doc(createdID)
          .set({
        'dateTime': myTimeStamp,
        'message': message,
        'seen': false,
        'notDeletedBy': notDeletors,
        'id': createdID,
        'senderID': FirebaseAuth.instance.currentUser?.uid,
        'messageType': type,
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
        'lastMessageType': type,
        'lastDate': myTimeStamp,
        'deleted': false,
        'blocked': false,
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
        'herImage': myImg,
        'lastMessage': message,
        'lastDate': myTimeStamp,
        'lastMessageType': type,
        'name': name,
        'deleted': false,
        'blocked': false,
        'seen': false,
        'tag': tag,
      });
      controller.text = "";
    }
  }
  Future<void> showActionAlert(context) async {
    return showDialog<void>(
        context: context,// user must tap button!
        builder: (BuildContext context) {    // TODO: implement build
          return AlertDialog(

            content:
            SizedBox(
              width: 200,
              child: ListView(
                shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    ListTile(
                      leading: Icon(Icons.copy, color: Colors.black,),
                      title: Text('Copy'),
                    ),
                    ListTile(
                      leading: Icon(Icons.forward, color: Colors.black,),
                      title: Text('Forward'),
                    ),
                    ListTile(
                      leading: Icon(Icons.delete, color: Colors.red,),
                      title: Text('Delete', style: TextStyle(color:Colors.red),),
                    ),

                  ]),
            ),
          );
        });
  }
}

