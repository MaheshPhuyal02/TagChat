import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  late Timestamp dateTime;
  late String message;
  late int messageType;
  late bool send;
  late bool seen;

  MessageModel(this.message, this.dateTime, this.seen, this.messageType,
      this.send);

}