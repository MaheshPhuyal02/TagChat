import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseManager {
  FirebaseManager() {}

  bool isLoggedIn() {
    bool log = false;
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        log = false;
      } else {
        log = true;
      }
    });
    return log;
  }

  bool checkTag(tag) {
    bool has = false;
    FirebaseFirestore.instance
        .collection("tags")
        .doc('Uomd7pmSmuEB2sWQ0Z7y')
        .get()
        .then((value) {
      // first add the data to the Offset object
      has = List.from(value["tags"]).contains(tag);
      // print(has);
    });
    return has;
  }
}
