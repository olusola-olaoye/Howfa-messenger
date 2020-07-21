/*
Written by Olusola Olaoye
Copyright © 2020

 */
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:howfa/helpers/MessageReceiverType.dart';
import 'package:howfa/models/Group.dart';
import 'package:howfa/models/Message.dart';
import 'package:howfa/screens/MessageListScreen.dart';
import 'package:howfa/screens/PhotoMessageSender.dart';
import 'package:howfa/services/DatabaseService.dart';
import 'package:provider/provider.dart';
import 'package:howfa/models/User.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

enum ActionToUser
{
  viewprofile,
  voicecall,
  videocall,
}

class MessageScreen extends StatefulWidget
{
  @override
  _MessageScreenState createState() => _MessageScreenState();


  final User currentUser;
  final String receiver;
  final String messageReceiverType;
  final String header;
  final NetworkImage receiverAvatar;


  MessageScreen({this.receiver, this.currentUser, this.messageReceiverType, this.header, this.receiverAvatar});
}

class _MessageScreenState extends State<MessageScreen>
{
  String messageContent = "";
  String signedInUser = "";
  bool showPopupMenu = false;

  TextEditingController _controller = TextEditingController();

  ActionToUser _currentAction;

  final imagePicker = ImagePicker();
  dynamic attachedFile;

  sendMessage(Message message)
  {
    DatabaseService().addChat(message);
  }

  selectFile(ImageSource source) async
  {
    final pickedFile = await imagePicker.getImage(source: source);

    setState(() {
      attachedFile = File(pickedFile.path);
    });

    Navigator.pop(context);

    Navigator.push(context, MaterialPageRoute(builder: (context) =>
        PhotoMessageSender(
          imageFile: attachedFile,
          currentUser: widget.currentUser,
          receiver: widget.receiver,
          messageReceiverType: widget.messageReceiverType,

        )
    )
    );


  }

   getSignedInUser() async{
   FirebaseUser user = await FirebaseAuth.instance.currentUser();

   signedInUser =  user.uid;
  }

  _showAttachmentOptions()
  {
    showModalBottomSheet(context: context, builder: (context){
      return Container(
        height: 160,
        child: Column(
          children: <Widget>[
            ListTile(
              leading: CircleAvatar(backgroundColor: Colors.white, child: Icon(Icons.image),),
              title: Text("Gallery"),
              onTap: ()=> {
                selectFile(ImageSource.gallery)
              },
            ),
            ListTile(
              leading: CircleAvatar(backgroundColor: Colors.white, child: Icon(Icons.camera_alt),),
              title: Text("Camera"),
              onTap: ()=> {
                selectFile(ImageSource.camera)
              },
            ),

          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      getSignedInUser();
    });

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            CircleAvatar(
              backgroundImage: widget.receiverAvatar
            ),
            Column(
              children: <Widget>[
                Text(widget.messageReceiverType == MessageReceiverType.individual ?
                  widget.receiver
                  :
                  widget.header,

                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 19,
                      fontWeight:
                      FontWeight.bold),
                ),

                SizedBox(
                  height: 5,
                ),
                Row(
                  children: <Widget>[
                    SizedBox(width: 15, height : 4),

                    Text("Last seen at 10:45", textAlign: TextAlign.left, style: TextStyle(fontSize: 13, fontWeight: FontWeight.normal),),
                  ],
                )
              ],
            )
          ],
        ),
        actions: <Widget>[
          Flexible(
            flex: 10,
            child: SizedBox(),
          ),

          Flexible(
            flex: 2,
            child: PopupMenuButton<ActionToUser>(
              onSelected: (ActionToUser result){
                setState(() {
                  _currentAction = result;
                });
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<ActionToUser>>[

                PopupMenuItem<ActionToUser>(
                  value: ActionToUser.viewprofile,
                  child: ListTile(
                    leading: Icon(Icons.person),
                    title: Text("View Profile"),
                  )
                ),

                PopupMenuItem<ActionToUser>(
                  value: ActionToUser.voicecall,
                  child: ListTile(
                    leading: Icon(Icons.call),
                    title: Text("Voice Call"),
                  )
                ),

                PopupMenuItem<ActionToUser>(
                  value: ActionToUser.videocall,
                  child: ListTile(
                    leading: Icon(Icons.video_call),
                    title: Text("Video Call"),
                  )
                ),
              ]
            )
          ),
        ],
      ),

      body: Column(
        children: <Widget>[
          Flexible(
            flex: 9,
            child: MultiProvider(
              providers: [
                StreamProvider<List<Message>>(create: (_) => DatabaseService().messages,),
                StreamProvider<List<User>>(create: (_) => DatabaseService().users,),
                StreamProvider<List<Group>>(create: (_) => DatabaseService().groups,),

              ],
              child: MessageListScreen(
                receiver: widget.receiver,
                currentUser: widget.currentUser,
                messageReceiverType: widget.messageReceiverType
              )
            )
          ),

          Flexible(
            flex: 1,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(9)),
                  color: Colors.white,
                ),

                child: Row(
                  children: <Widget>[
                    Flexible(
                      flex : 2,
                      child:
                      FlatButton.icon(onPressed: (){}, icon: Icon(Icons.tag_faces), label: Text("")),

                    ),

                    Flexible(
                      flex: 18,
                      child: ConstrainedBox(
                        constraints: new BoxConstraints(
                          minWidth: 45,
                          maxWidth: 165,
                          minHeight: 25.0,
                          maxHeight: 135.0,
                        ),
                        child: Scrollbar(
                          child: TextField(
                            controller: _controller,
                            onChanged: (val) => messageContent = val,
                            minLines: 1,
                            cursorColor: Colors.blue,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(
                                    top: 2.0,
                                    left: 13.0,
                                    right: 13.0,
                                    bottom: 2.0),
                                hintText: "Type your message",
                                hintStyle: TextStyle(
                                  color:Colors.grey,
                                )
                            ),
                          ),
                        ),
                      ),
                    ),

                    Flexible(
                      flex: 1,
                      child: SizedBox(
                        width: 15,
                      ),
                    ),
                    Flexible(
                        flex : 5,
                        child: FlatButton(onPressed: (){
                        _showAttachmentOptions();
                        },
                        child: Icon(
                          Icons.attach_file
                        ),
                        ),
                    ),
                    Flexible(
                      flex:  4,
                      child: FlatButton(onPressed: () async {
                        if(messageContent.length > 0)
                        {
                          FirebaseUser user = await FirebaseAuth.instance.currentUser();
                          sendMessage(
                              Message(
                                senderID: user.uid,
                                receiverID: widget.receiver ?? "",
                                receivedAt: DateTime.now().toString(),
                                message: messageContent,
                                messageType: "regular",
                                messageReceiverType: widget.messageReceiverType,
                                read: false
                              ));

                          _controller.clear();
                          messageContent = "";
                        }

                        setState(() {
                        });
                      },

                      child: Icon(
                        Icons.send
                      ),
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ),
        ],
      )
    );
  }
}
