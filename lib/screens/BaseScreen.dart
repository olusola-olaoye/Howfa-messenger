/*
Written by Olusola Olaoye
Copyright © 2020

 */

import 'package:flutter/material.dart';
import 'package:howfa/helpers/CurrentUser.dart';
import 'package:howfa/models/User.dart';
import 'package:howfa/screens/AboutScreen.dart';
import 'package:howfa/screens/AllContactsScreen.dart';
import 'package:howfa/screens/ChatsScreen.dart';
import 'package:howfa/screens/GroupsScreen.dart';
import 'package:howfa/services/AuthService.dart';
import 'EditProfileScreen.dart';

class BaseScreen extends StatefulWidget
{
  final int currentPageNumber;
  final User user;
  BaseScreen({this.currentPageNumber, this.user});


  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen>
{
  AuthService auth = new AuthService();

  int selectedIndex = 0;

  bool searchMode = false;

  _changeNavigationIndex(int index)
  {
    setState(() {
      selectedIndex = index;
    });

  }

  @override
  Widget build(BuildContext context)
  {
    double dividerheight = 10;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(63),
        child: searchMode?
          SafeArea
            (
            child: Container
              (
              child: Row(
                children: <Widget>[

                  IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: (){
                        searchMode = false;
                        setState(() {

                        });
                      }
                      ),
                  Expanded(
                    child: TextField(
                      
                    ),
                  ),
                ],
              ),
              height: 200,
            ),
          )
            :
          AppBar(
          elevation: 0.9,
          
          backgroundColor: Colors.grey[50],
          actions: <Widget>[

            IconButton(
              icon: Icon(Icons.search),
              color: Colors.blue,
              onPressed: (){
                searchMode = true;
                setState(() {

                });
              },
            ),



            FlatButton.icon(onPressed: () => auth.signOut(), icon: Icon(Icons.exit_to_app, color: Colors.blue, size: 22,),
              label: Text("",),
              padding: EdgeInsets.fromLTRB(19, 0, 0, 0),
            ),



          ],
          title: Text('HowFa',
            style: TextStyle(
                color: Colors.blue,
                fontSize: 20
            ),
          ),
          iconTheme: IconThemeData(color: Colors.blue),
        ),
      ),

      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader
              (
              child: Column(
                children: <Widget>[
                  Center(child: CircleAvatar
                    (
                    backgroundImage: NetworkImage(CurrentUser.user.photoURL),
                    radius: 42,
                    child: CurrentUser.user.photoURL == null ?
                    Icon(Icons.person, size: 55, ) :
                    SizedBox()
                  ),
                  ),
                  SizedBox(height: 13,),

                  Text(widget.user.username , style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 3,),
                  Text("+234-000-0" , style: TextStyle(fontSize: 12, color: Colors.white),
                  ),

                ],
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment(0.77, 0.0),
                    colors: [Colors.blue[200], Colors.blue[800]],
                    //tileMode: TileMode.repeated
                ),
                color: Colors.blue[300],
              ),
            ),
            ListTile(
              leading: Icon(Icons.edit, color: Colors.blue, size: 19,),
              title: Text('Edit Profile', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),),
              subtitle: Text("Change avatars, bio, and name",
                style: TextStyle(
                  color: Colors.blue[500],
                  fontSize: 12,
                  fontStyle: FontStyle.italic
                )
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfileScreen(
                  user: widget.user,
                )));
              },
            ),

            Divider(
              height: dividerheight,
            ),


            ListTile(
              leading: Icon(Icons.group, color: Colors.blue, size: 19,),
              title: Text('Create Group Chat', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),),
              subtitle: Text("Groupchat with up to 100 members",
                  style: TextStyle(
                      color: Colors.blue[500],
                      fontSize: 12,
                      fontStyle: FontStyle.italic
                  )
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => AllContactsScreen(
                  toAddGroup: true,
                )));
              },
            ),
            Divider(
              height: dividerheight,
            ),



            ListTile(
              leading: Icon(Icons.person, color: Colors.blue, size: 19,),
              title: Text('My Contats', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),),
              subtitle: Text("Sccess your contacts",
                  style: TextStyle(
                      color: Colors.blue[500],
                      fontSize: 12,
                      fontStyle: FontStyle.italic
                  )
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => AllContactsScreen(toAddGroup: false)));
              },
            ),
            Divider(
              height: dividerheight,
            ),


            ListTile(
              leading: Icon(Icons.info, color: Colors.blue, size: 19,),
              title: Text('About', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),),
              subtitle: Text("About this app",
                  style: TextStyle(
                      color: Colors.blue[500],
                      fontSize: 12,
                      fontStyle: FontStyle.italic
                  )
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => AboutScreen()));
              },
            ),
            Divider(
              height: 11,
            ),


          ],
        ),
      ),

      body: Center(
        child: selectedIndex == 0 ?
        ChatsScreen(currentUser: widget.user,):
        GroupsScreen(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedIconTheme: IconThemeData(color: Colors.blue),
        selectedLabelStyle: TextStyle(color: Colors.blue),

        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble),
            title: Text('Chats'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            title: Text('Groups'),
          ),

        ],
        currentIndex: selectedIndex,
        selectedItemColor: Colors.blue[800],
        onTap: _changeNavigationIndex,
      ),
    );
  }
}
