/*
Written by Olusola Olaoye
Copyright © 2020

 */
import 'package:flutter/material.dart';
import 'package:howfa/screens/AllContactsScreen.dart';

class MyContactsScreen extends StatefulWidget {
  @override
  _MyContactsScreenState createState() => _MyContactsScreenState();
}

class _MyContactsScreenState extends State<MyContactsScreen>
{
  @override
  Widget build(BuildContext context)
  {

    return Scaffold(
      appBar: AppBar(
        title: Text("My Contacts"),

        actions: <Widget>[
          FlatButton.icon(onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => AllContactsScreen()));
          },
              icon: Icon(Icons.person_add),
              label: Text("add new"))
        ],
      ),
    );
  }
}
