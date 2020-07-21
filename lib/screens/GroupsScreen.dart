/*
Written by Olusola Olaoye
Copyright © 2020

 */
import 'package:flutter/material.dart';
import 'package:howfa/screens/GroupListScreen.dart';
import 'package:provider/provider.dart';
import 'package:howfa/services/DatabaseService.dart';
import 'package:howfa/models/Group.dart';
import 'package:howfa/screens/AllContactsScreen.dart';
import 'package:howfa/models/User.dart';

class GroupsScreen extends StatefulWidget
{
  final User currentUser;
  GroupsScreen({this.currentUser});

  @override
  _GroupsScreenState createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body: MultiProvider(
            providers: [
              StreamProvider<List<Group>>(create: (_) => DatabaseService().groups),
            ],
            child: GroupListScreen(
              currentUser: widget.currentUser,
            )
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          child: Icon(Icons.group_add),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => AllContactsScreen(toAddGroup: true)));
          },
        )
    );
  }
}
