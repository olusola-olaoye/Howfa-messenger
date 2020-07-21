/*
Written by Olusola Olaoye
Copyright © 2020

 */
import 'package:flutter/material.dart';
import 'package:howfa/models/Message.dart';
import 'package:howfa/screens/AllContactsScreen.dart';
import 'package:howfa/screens/ChatListScreen.dart';
import 'package:howfa/models/User.dart';
import 'package:provider/provider.dart';
import 'package:howfa/services/DatabaseService.dart';

class ChatsScreen extends StatefulWidget
{
  @override
  _ChatsScreenState createState() => _ChatsScreenState();

  final User currentUser;
  ChatsScreen({this.currentUser});
}
class _ChatsScreenState extends State<ChatsScreen> with SingleTickerProviderStateMixin
{
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(

      body: MultiProvider(
          providers: [
            StreamProvider<List<Message>>(create: (_) => DatabaseService().messages,),
            StreamProvider<List<User>>(create: (_) => DatabaseService().users,),

          ],
          child: ChatListScreen(
            user: widget.currentUser,
          )
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: Icon(Icons.message),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => AllContactsScreen(toAddGroup: false)));
        },
      )
    );
  }
}
