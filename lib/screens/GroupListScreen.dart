/*
Written by Olusola Olaoye
Copyright © 2020

 */
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:howfa/helpers/DataHelper.dart';
import 'package:howfa/helpers/MessageReceiverType.dart';
import 'package:howfa/models/Group.dart';
import 'package:provider/provider.dart';
import 'package:howfa/screens/MessageScreen.dart';
import 'package:howfa/models/User.dart';

class GroupListScreen extends StatefulWidget
{
  final User currentUser;
  GroupListScreen({this.currentUser});

  @override
  _GroupListScreenState createState() => _GroupListScreenState();
}

class _GroupListScreenState extends State<GroupListScreen>
{
  String currentUserId = "";

  @override
  Widget build(BuildContext context)
  {
    getCurrentUserID() async {
      FirebaseUser user = await FirebaseAuth.instance.currentUser();

      currentUserId = user.uid;
    }
    getCurrentUserID();

    final groupList = Provider.of<List<Group>>(context) ?? [];

    List<Group> queriedGroup = List<Group>();

    setState(()
    {
      for(int i = 0; i< groupList.length; i++)
      {
        for(int j = 0; j < groupList[i].members.length; j++)
        {
           if(groupList[i].members[j].uid == currentUserId )
           {
              queriedGroup.add(groupList[i]);
           }
        }
      }
    });

    return queriedGroup.length > 0 ?
      ListView.builder(
      itemCount: queriedGroup.length,
      itemBuilder: (context, index) {
        return Column(
          children: <Widget>[
            ListTile(
              leading: CircleAvatar(
                radius: 24,
                child: Icon(
                    Icons.group,
                  size: 26,
                ),
              ),
              title: Text(queriedGroup[index].name),
              subtitle: Text("${queriedGroup[index].members.length} members"),

              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => MessageScreen(
                  currentUser: widget.currentUser,
                  receiver: queriedGroup[index].id,
                  messageReceiverType: MessageReceiverType.group,
                  header: DataHelper().getGroupViaID(queriedGroup[index].id, groupList).name,
                )));
              },
            ),
            Divider( height: 19,),
          ],
        );
      },
    ):
    Center(
      child: Text("You do not belong to any group"),
    );


  }
}
