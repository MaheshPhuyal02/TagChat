import 'package:cloud_firestore/cloud_firestore.dart';

class ChatListModel{
 late String id;
 late String lastActive;
 late String lastMessage;
 late bool seen;
 late String name;
 late String tag;
 ChatListModel(this.id, this.lastActive, this.lastMessage, this.seen, this.tag, this.name);
}