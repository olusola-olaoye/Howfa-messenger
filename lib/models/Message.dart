/*
Written by Olusola Olaoye
Copyright © 2020

 */
class Message
{
  String senderID;
  String receiverID;
  String receivedAt;
  String message;
  String messageType;
  String messageReceiverType;
  bool read;

  Message({this.senderID,
          this.receiverID,
          this.receivedAt,
          this.message,
          this.messageType,
          this.messageReceiverType,
          this.read
  });
}