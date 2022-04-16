import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hotmessage/Dialogs.dart';
import 'package:hotmessage/WelcomeActivity.dart';
import 'package:hotmessage/main.dart';
import 'package:image_picker/image_picker.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<EditProfilePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<EditProfilePage> {
  String name = "";
  String bio = "";
  String img = "";
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController tagController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  void getProfileData() {
    FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .snapshots()
        .forEach((element) {
      setState(() {
        emailController.text = element.get("email");
        tagController.text = element.get("tag");
        nameController.text = element.get("name");
        bioController.text = element.get("bio");
        img = element.get("image");
        print(img);
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProfileData();
  }

  ImageProvider getImage() {
    if (img == "")
      return AssetImage("assets/user.png");
    else if (img.startsWith("https://"))
      return NetworkImage(img) as ImageProvider;
    else
      return FileImage(File(img));
  }

  @override
  Widget build(BuildContext context) {
    bool _loading = false;
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.black),
        title: Row(
          children: [
            Expanded(
                child: Center(
                    child: Text(
              "Update profile",
              style: TextStyle(color: Colors.black),
            ))),
            InkWell(
                onTap: () {
                  // mess = mess.toString().lastIndexOf("]");
                  Widget okButton = TextButton(
                    child: const Text("Cancel", style: TextStyle(
                      color: Colors.black
                    ),),
                    onPressed: () {
                      try {
                        Navigator.pop(context);
                      } catch (e) {}
                    },
                  );
                  Widget cancelButton = TextButton(
                    child: const Text("Logout"),
                    onPressed: () {
                      Navigator.pop(context);
                      FirebaseAuth.instance.signOut();
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (builder) => WelcomeActivity()),
                            (route) => false,
                      );
                    },
                  );

                  // set up the AlertDialog
                  AlertDialog alert = AlertDialog(
                    title: Text("Log out"),
                    content: Text("Are you sure want to logout?"),
                    actions: [
                      cancelButton,
                      okButton,
                    ],
                  );
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return alert;
                    },
                  );

                },
                child: Icon(
                  Icons.exit_to_app,
                  color: Colors.black,
                )),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 30, bottom: 30),
                constraints:
                    new BoxConstraints(maxHeight: 200.0, maxWidth: 200.0),
                padding:
                    new EdgeInsets.only(left: 16.0, bottom: 8.0, right: 16.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: getImage(),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: [
                    new Positioned(
                      right: 0.0,
                      bottom: 3.0,
                      child: Container(
                        constraints:
                            new BoxConstraints(maxHeight: 50.0, maxWidth: 50.0),
                        decoration: new BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                                color: Color(0xFFdedede), offset: Offset(2, 2)),
                          ],
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: GestureDetector(
                          onTap: () async {
                            final XFile? image = await _picker.pickImage(
                                source: ImageSource.gallery,
                                maxWidth: 500,
                                maxHeight: 500,
                                imageQuality: 50);
                            if (image?.path != null)
                              setState(() {
                                img = image!.path;
                              });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.photo_camera,
                              size: 34,
                              color: Color(0xFF00cde7),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              TextField(
                  style: TextStyle(fontSize: 17),
                  maxLines: 1,
                  controller: bioController,
                  keyboardType: TextInputType.text,
                  onChanged: (value) {
                    bio = value;
                  },
                  decoration: const InputDecoration(
                    filled: true,
                    prefixIcon: Icon(Icons.edit),
                    fillColor: Colors.black12,
                    contentPadding: const EdgeInsets.all(10),
                    labelText: 'Enter bio',
                  )),
              SizedBox(
                height: 20,
              ),
              TextField(
                  style: TextStyle(fontSize: 17),
                  maxLines: 1,
                  controller: nameController,
                  keyboardType: TextInputType.text,
                  onChanged: (value) {
                    bio = value;
                  },
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.black12,
                    prefixIcon: Icon(Icons.person),
                    contentPadding: const EdgeInsets.all(10),
                    labelText: 'UserName',
                  )),
              SizedBox(
                height: 20,
              ),
              TextField(
                  controller: tagController,
                  style: TextStyle(fontSize: 17),
                  maxLines: 1,
                  enabled: false,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.black12,
                    prefixIcon: Icon(Icons.tag),
                    contentPadding: const EdgeInsets.all(10),
                    labelText: 'Tag',
                  )),
              SizedBox(
                height: 20,
              ),
              TextField(
                  enabled: false,
                  controller: emailController,
                  style: TextStyle(fontSize: 17),
                  maxLines: 1,
                  keyboardType: TextInputType.text,
                  onChanged: (value) {
                    bio = value;
                  },
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.black12,
                    prefixIcon: Icon(Icons.email),
                    contentPadding: const EdgeInsets.all(10),
                    labelText: 'Email here',
                  )),
              SizedBox(
                height: 50,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 5),
                      decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      child: TextButton(
                          onPressed: () {
                            if (Navigator.canPop(context)) {
                              Navigator.pop(context);
                            } else {
                              Navigator.of(context)
                                  .pushAndRemoveUntil(
                                MaterialPageRoute(builder: (builder) => MyHomePage(title: "")),
                                    (route) => false,
                              );
                            }
                          },
                          child: Text(
                            "Cancel",
                            style:
                                TextStyle(color: Colors.black54, fontSize: 22),
                          )),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 40, right: 5),
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      child: _loading
                          ? CircularProgressIndicator()
                          : TextButton(
                              onPressed: () {
                                if (img.startsWith("https")) {
                                  FirebaseFirestore.instance
                                      .collection("users")
                                      .doc(FirebaseAuth
                                          .instance.currentUser?.uid)
                                      .update({
                                    "name": nameController.text,
                                    "bio": bioController.text,
                                  });
                                  if (Navigator.canPop(context)) {
                                    Navigator.pop(context);
                                  } else {
                                    SystemNavigator.pop();
                                  }
                                } else if (img != "") {
                                  print("Uploading");
                                  Dialogs.showLoaderDialog(context);
                                  String? fN =
                                      "${FirebaseAuth.instance.currentUser?.uid.toString()}.png";
                                  Reference ref = FirebaseStorage.instance
                                      .ref("profile")
                                      .child(fN);
                                  UploadTask uploadTask =
                                      ref.putFile(File(img));
                                  uploadTask.whenComplete(() async {
                                    String url = await ref.getDownloadURL();
                                    FirebaseFirestore.instance
                                        .collection("users")
                                        .doc(FirebaseAuth
                                            .instance.currentUser?.uid)
                                        .update({
                                      "name": nameController.text,
                                      "image": url,
                                      "bio": bioController.text,
                                    });
                                    if (Navigator.canPop(context)) {
                                      Navigator.pop(context);
                                      Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (builder) => MyHomePage(
                                                  title: '',
                                                )),
                                        (route) => false,
                                      );
                                    } else {
                                      SystemNavigator.pop();
                                      SystemNavigator.pop();
                                    }
                                    // print("Completed");
                                    // print(url);
                                  }).catchError((onError) {
                                    setState(() {
                                      _loading = false;
                                    });
                                    Dialogs.showAlertDialog(
                                        context,
                                        "Failed to upload file",
                                        onError.toString());
                                  });
                                } else {
                                  Navigator.of(context)
                                      .pushAndRemoveUntil(
                                    MaterialPageRoute(builder: (builder) => MyHomePage(title: "")),
                                        (route) => false,
                                  );
                                }
                              },
                              child: Text(
                                "Save",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 22),
                              )),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
