/*
Written by Olusola Olaoye
Copyright © 2020

 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:howfa/helpers/DataHelper.dart';
import 'package:howfa/helpers/MessageReceiverType.dart';
import 'package:howfa/models/User.dart';
import 'package:howfa/screens/AddNewGroupScreen.dart';
import 'package:provider/provider.dart';
import 'package:howfa/screens/MessageScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ContactListScreen extends StatefulWidget
{

  final bool toAddGroup;
  ContactListScreen({this.toAddGroup});

  @override
  _ContactListScreenState createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen>
{
  String currentUserID = "";

  List<String> selectedUsersOnTap = new List<String>();

  bool isStringInSelectedUsers(String name)
  {
    for(int i = 0; i< selectedUsersOnTap.length; i++)
      {
        if(name == selectedUsersOnTap[i])
          {
            return true;
          }
      }

    return false;
  }

  void removeStringInSelectedUsers(String name)
  {
    for(int i = 0; i< selectedUsersOnTap.length; i++)
    {
      if(name == selectedUsersOnTap[i])
      {
        selectedUsersOnTap.remove(selectedUsersOnTap[i]);
      }
    }
  }

  List<User> getListOfUsers(List<String> userNames, List<User> userList)
  {
    List<User> users = new List<User>();

    for(int i = 0; i < userNames.length; i++)
      {

         users.add(DataHelper().getUserFromUsername(userNames[i], userList));
      }

    return users;
  }
  @override
  Widget build(BuildContext context)
  {
    getCurrentUserID() async {
      FirebaseUser user = await FirebaseAuth.instance.currentUser();

      currentUserID = user.uid;
    }

    getCurrentUserID();
    final userList = Provider.of<List<User>>(context) ?? [];

    List<User> queriedUserList = [];

    userList.forEach((user){
      if(user.uid != currentUserID)
        {
          queriedUserList.add(user);
        }
    });

    return Column(
       children: <Widget>[
         Flexible(
           flex: 1,
           child: ListView.builder(
               scrollDirection: Axis.horizontal,
               itemCount: selectedUsersOnTap.length,
               itemBuilder: (context, index){
                 return Container(
                   
                   child: Center(
                       child: Padding(
                         padding: EdgeInsets.all(20),
                         child: Row(
                             children: <Widget>[
                               Icon(Icons.cancel),
                               Text(selectedUsersOnTap[index]),
                               SizedBox(width: 20,),
                             ],
                         ),
                       )
                   ),
                 );
               }
           ),
         ),
         Flexible(
           flex: selectedUsersOnTap.length > 0 ? 6 : 100,
           child: ListView.builder(

             itemCount: queriedUserList.length,

             itemBuilder: (context, index) {
               return Column(
                 children: <Widget>[
                   ListTile(

                     leading : CircleAvatar(
                       backgroundImage:NetworkImage(DataHelper().getAvatarOfUserFromUsername(queriedUserList[index].username, userList)),
                       radius: 25,
                       //child: Icon(Icons.person),
                     ),
                     title: Text(queriedUserList[index].username),
                     subtitle: Text(queriedUserList[index].bio),
                     trailing : isStringInSelectedUsers(queriedUserList[index].username) ?
                     CircleAvatar(
                       maxRadius: 12,
                       child: Icon(Icons.done),
                       backgroundColor: Colors.green,)
                         :
                     null,
                     
                     onTap: (){
                       if(widget.toAddGroup)
                       {
                         setState(() 
                         {
                           if(isStringInSelectedUsers(queriedUserList[index].username))
                             {
                               removeStringInSelectedUsers(queriedUserList[index].username);
                             }
                           else
                             {
                               selectedUsersOnTap.add(queriedUserList[index].username);
                             }
                           
                         });
                       }
                       else
                       {
                         Navigator.push(context, MaterialPageRoute(builder: (context) => MessageScreen(
                           receiver: queriedUserList[index].username,
                           messageReceiverType: MessageReceiverType.individual,
                           header: queriedUserList[index].username,
                           receiverAvatar: NetworkImage(DataHelper().getAvatarOfUserFromUsername(queriedUserList[index].username, userList)),
                         )));
                       }

                     },
                   ),
                   Divider()
                 ],
               );
             },
           ),
         ),
         selectedUsersOnTap.length > 0 ? Flexible(
           flex: 1,
           child: Align(
             alignment: Alignment.topRight,
             child: FloatingActionButton(
              child: Icon(Icons.arrow_forward),
               onPressed: (){
                 Navigator.push(context, MaterialPageRoute(builder: (context) => AddNewGroupScreen(
                    users: getListOfUsers(selectedUsersOnTap, queriedUserList),
                 )));
               },
             ),
           ),
         ): Container()
       ],
    );
  }

}
