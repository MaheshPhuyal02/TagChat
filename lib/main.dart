import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:hotmessage/ConnectionChecker.dart';
import 'package:hotmessage/EditProfile.dart';
import 'package:hotmessage/SearchActivity.dart';
import 'package:hotmessage/SignUpActivity.dart';
import 'package:hotmessage/WelcomeActivity.dart';
import 'Constants.dart';
import 'MessagesActivity.dart';
import 'UserModel.dart';
import 'online_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  if (FirebaseAuth.instance.currentUser != null) {
    runApp(const MyApp());
  } else {
    runApp(const WelcomeActivity());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Lato',
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Map _source = {ConnectivityResult.none: false};
  final ConnectionChecker _connectivity = ConnectionChecker.instance;
  String img = "not";
  String myTag = "@";
  List<Map<String, dynamic>> mainChatList = [];
  int _counter = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    getChatList();
    // TODO: implement initState
    super.initState();
    _connectivity.initialise();
    _connectivity.myStream.listen((source) {
      setState(() => _source = source);
    });
    FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .snapshots()
        .forEach((element) {
      setState(() {
        img = element.get("image");
      });
      myTag = element.get("tag");
    });
  }

  @override
  void dispose() {
    _connectivity.disposeStream();
    super.dispose();
  }

  Future<void> getChatList() async {
    CollectionReference reference = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection("messages");
    await reference
        .orderBy("lastDate", descending: true)
        .snapshots()
        .listen((querySnapshot) {
      mainChatList.clear();
      querySnapshot.docs.forEach((element) {
        Map<String, dynamic> mm = <String, dynamic>{
          "id": element.get("id"),
          "seen": element.get("seen"),
          "herImg": element.get("herImage")!,
          "lastMessage": element.get("lastMessage"),
          "lastMessageType": element.get("lastMessageType"),
          "lastDate": element.get("lastDate"),
          "name": element.get("name"),
          "tag": element.get("tag"),
        };
        //    print(element.doc.get("name"));
        setState(() {
          // mainChatList.clear();
          mainChatList.add(mm);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print(ConnectivityResult.none.name);
    return Scaffold(

      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Row(
          children: [
            Container(
                width: 36,
                height: 36,
                child: InkWell(
                  onTap: () {
                    //FirebaseAuth.instance.signOut();
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => EditProfilePage(title: "")));
                  },
                  child: CircleAvatar(
                    radius: 56,
                    backgroundColor: Colors.white,
                    child: ClipOval(
                        child: img != ""
                            ? (Image.network(
                                img,
                                fit: BoxFit.cover,
                                height: 34,
                                width: 34,
                              ))
                            : Image.asset("assets/user.png")),
                  ),
                )),
            Expanded(
              child: Container(
                child: const Text("TagChat", style: TextStyle(color: Colors.black),),
                alignment: Alignment.center,
              ),
              flex: 1,
            ),
          ],
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Row(children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (ConnectivityResult.none == true)
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(8),
                      width: double.infinity,
                      child: Text(
                        "No connection.",
                        style: TextStyle(color: Colors.white),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                      ),
                    ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const SearchPage(
                                title: 'hello',
                              )));
                      ;
                    },
                    child: Container(
                      padding: const EdgeInsets.only(
                          left: 12, top: 6, bottom: 6, right: 6),
                      margin: const EdgeInsets.all(6),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.search,
                            color: const Color(0xffa1a1a1),
                          ),
                          Expanded(
                            child: Container(
                              child: const Text(
                                "Search",
                                style: const TextStyle(
                                    fontSize: 19,
                                    color: const Color(0xff828282)),
                              ),
                              alignment: Alignment.center,
                            ),
                            flex: 1,
                          )
                        ],
                      ),
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                          color: Color(0xFFF2F2F2)),
                    ),
                  ),
                  Row(mainAxisSize: MainAxisSize.max, children: [
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: getChatList,
                        child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: mainChatList.length,
                            itemBuilder: (BuildContext context, int index) {
                              //  String name = mainChatList[index].name;
                              return InkWell(
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (context) => MessagesPage(
                                                  title: mainChatList.length > 0
                                                      ? mainChatList[index]
                                                          ["id"]
                                                      : "",
                                                  from: "message",
                                                  herRealID: "",
                                                  herName: mainChatList[index]["name"],
                                                  herTag: mainChatList[index]["tag"],
                                                  herImage: mainChatList[index]["herImg"],
                                                )));
                                  },
                                  child: Card(
                                      margin: EdgeInsets.all(9),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          margin: const EdgeInsets.only(
                                              left: 12,
                                              right: 0,
                                              top: 5,
                                              bottom: 5),
                                          child: Row(
                                            children: [
                                              Container(
                                                height: 38,
                                                width: 38,
                                                child: ClipOval(
                                                    child: mainChatList[index]
                                                                ["herImg"] !=
                                                            ""
                                                        ? (Image.network(
                                                            mainChatList[index]
                                                                ["herImg"],
                                                            fit: BoxFit
                                                                .fitHeight,
                                                          ))
                                                        : Image.asset(
                                                            "assets/user.png")),
                                                margin: const EdgeInsets.only(
                                                    left: 2, right: 5),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Container(
                                                      child: Text(
                                                        mainChatList[index]
                                                            ["name"],
                                                        style: const TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                      width: double.infinity,
                                                    ),
                                                    Container(
                                                      child:
                                                      Text(
                                                        mainChatList[index]["lastMessageType"] == Constants.MESSAGE_TYPE_TEXT?
                                                        mainChatList[index]
                                                            ["lastMessage"]:
                                                        "Sent a photo",
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                      width: double.infinity,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(mainChatList[index]
                                                            ["lastDate"] !=
                                                        null
                                                    ? GetTimeAgo.parse(
                                                        mainChatList[index]
                                                                ["lastDate"]
                                                            .toDate())
                                                    : ""),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )));
                            }),
                      ),
                    ),
                  ]),
                ],
              ),
            ),
          ),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                String searchTag = "";
                bool isLoading = false;
                late StateSetter _setState;
                return AlertDialog(
                  title: const Text("Search People"),
                  content: StatefulBuilder(
                      // You need this, notice the parameters below:
                      builder: (BuildContext context, StateSetter setState) {
                    _setState = setState;
                    return TextField(
                        maxLines: 1,
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) {
                          searchTag = value;
                          //Do something with the user input.
                        },
                        autofocus: true,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(10),
                          prefix: Text(
                            "@",
                            style: TextStyle(color: Colors.blue),
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          labelText: "Input tag or email",
                        ));
                  }),
                  actions: [
                    MaterialButton(
                        child: const Text("Cancel"),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                    MaterialButton(
                        child: const Text(
                          "Search",
                          style: TextStyle(color: Colors.blue),
                        ),
                        onPressed: () async {
                          Navigator.pop(context);

                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                initState() async {
                                  int cPos = checkIfExist(searchTag);
                                  if (cPos == -1) {
                                    var documentList = (await FirebaseFirestore
                                            .instance
                                            .collection("tags")
                                            .where("tag", isEqualTo: searchTag)
                                            .get(const GetOptions(
                                                source: Source.serverAndCache)))
                                        .docs;
                                    // print(documentList[0].get("id"));
                                    Navigator.of(context).pop();
                                    //print(documentList.length);
                                    if (documentList.isNotEmpty) {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MessagesPage(
                                                    title: FirebaseFirestore
                                                        .instance
                                                        .collection("chats")
                                                        .doc()
                                                        .id,
                                                    from: "search",
                                                    herRealID: documentList[0]
                                                        .get("id"), herTag: '', herName: '', herImage: '',
                                                  )));
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                            "Cannot find user with this tag."),
                                        duration: Duration(milliseconds: 800),
                                      ));
                                    }
                                  }
                                  else if(searchTag == myTag){
                                    print("MYTAg");
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text(
                                          "I didn't find any reason to message yourself."),
                                      duration: Duration(milliseconds: 800),
                                    ));
                                  } else {
                                    //    print("already exist");
                                    Navigator.of(context).pop();
                                    WidgetsBinding.instance
                                        ?.addPostFrameCallback((_) {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MessagesPage(
                                                    title: mainChatList[cPos]
                                                        ["id"],
                                                    from: "ma",
                                                    herRealID: "",
                                                    herName: mainChatList[cPos]["name"],
                                                    herTag: mainChatList[cPos]["tag"],
                                                    herImage: mainChatList[cPos]["herImage"],
                                                  )));
                                    });
                                  }
                                }

                                initState();
                                int? selectedRadio = 0;
                                return AlertDialog(
                                  content: Row(
                                    children: [
                                      const CircularProgressIndicator(),
                                      Container(
                                          margin:
                                              const EdgeInsets.only(left: 7),
                                          child: const Text("Loading...")),
                                    ],
                                  ),
                                );
                              });
                        })
                  ],
                );
              });
          // Add your onPressed code here!
        },
        child: const Icon(Icons.message),
        backgroundColor: Colors.blue,
      ),
// This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  int checkIfExist(String v) {
    bool r = false;
    int pos = 0;
    int rePos = -1;
    loop:
    mainChatList.forEach((element) {
      if (element["tag"] == v) {
        rePos = pos;
        return;
      }
      pos++;
    });
    return rePos;
  }
}
