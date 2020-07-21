/*
Written by Olusola Olaoye
Copyright © 2020

 */
import 'package:flutter/material.dart';
import 'package:howfa/helpers/DataHelper.dart';
import 'package:howfa/helpers/MessageReceiverType.dart';
import 'package:howfa/models/Message.dart';
import 'package:howfa/screens/MessageScreen.dart';
import 'package:provider/provider.dart';
import 'package:howfa/models/User.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatListScreen extends StatefulWidget {

  final User user;

  ChatListScreen({this.user});

  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen>
{

  String currentUserID = "";

  String formatStringTooLong(String s, int maxLength)
  {
    if(s.length > maxLength)
    {
      return s.substring(0, maxLength) + "...";
    }

    return s;
  }

  @override
  Widget build(BuildContext context)
  {
      getCurrentUserID() async {
        FirebaseUser user = await FirebaseAuth.instance.currentUser();

        currentUserID = user.uid;
      }

      getCurrentUserID();

      final messageList = Provider.of<List<Message>>(context) ?? [];
      final userList = Provider.of<List<User>>(context) ?? [];

      List<Message> queriedChat = List<Message>();

      setState(()
      {
        for(int i = messageList.length - 1; i>= 0; i-=1)
        {
          // is user is sender or receiver
          if(messageList[i].senderID == widget.user.uid || messageList[i].receiverID == widget.user.username)
            {
              // this block is to avoid duplicate chat
              if(!DataHelper().doesMessageSenderAndReceiverExist(messageList[i], queriedChat, userList) &&
                messageList[i].messageReceiverType == MessageReceiverType.individual)
              {
                queriedChat.add(messageList[i]);
              }
            }
        }
      });

      return queriedChat.length > 0 ?
        ListView.builder(
        itemCount: queriedChat.length,
        itemBuilder: (context, index) {
          return Column(
            children: <Widget>[
              ListTile(
                leading: CircleAvatar(
                  radius: 28,
                  backgroundImage: queriedChat[index].senderID == currentUserID ?
                  NetworkImage(DataHelper().getAvatarOfUserFromUsername(queriedChat[index].receiverID, userList))
                      :
                  NetworkImage(DataHelper().getAvatarOfUserFromID(queriedChat[index].senderID, userList)),
                ),
                title: queriedChat[index].senderID == currentUserID ?
                        Text(queriedChat[index].receiverID)
                        :
                        Text(DataHelper().getUserNameFromID(queriedChat[index].senderID, userList)),
                subtitle: queriedChat[index].messageType == "regular"?
                          Text(formatStringTooLong(queriedChat[index].message, 28)) :
                          Text("photo") ,

                trailing: Column(
                          children: <Widget>[

                            SizedBox(height: 5,),

                            Text(queriedChat[index].receivedAt.toString().substring(11,16)),

                            SizedBox(height: 8,),
                            SizedBox(width: 0, height: 0,)
                          ],

                        ),

                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MessageScreen(
                    currentUser: widget.user,
                    receiver: queriedChat[index].senderID == currentUserID ?
                    queriedChat[index].receiverID
                    :
                    DataHelper().getUserNameFromID(queriedChat[index].senderID, userList),
                    messageReceiverType: MessageReceiverType.individual,

                    receiverAvatar: queriedChat[index].senderID == currentUserID ?
                    NetworkImage(DataHelper().getAvatarOfUserFromUsername(queriedChat[index].receiverID, userList))
                        :
                    NetworkImage(DataHelper().getAvatarOfUserFromID(queriedChat[index].senderID, userList)),

                  )));
                },
              ),
              Divider( height: 8,),
            ],
          );
        },
      ):
      Container(
        child: Center(
          child: (Text("You Currently have no chats")),
        ),
      );
    }
}
