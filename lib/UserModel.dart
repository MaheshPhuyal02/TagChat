import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hotmessage/ChatListModel.dart';

class UserModel{
  late String name;
  late String tag;
  late String email;
  List<Map<String, dynamic>> chatLists = <Map<String, dynamic>>[];
  UserModel(this.name, this.tag, this.email, this.chatLists);
  UserModel.fromSnapshot(DocumentSnapshot snapshot)
      :
        name = snapshot['name'],
        email = snapshot['email'],
        tag = snapshot['tag'],
        chatLists = snapshot['chats'].cast<Map<String, dynamic>>();

}