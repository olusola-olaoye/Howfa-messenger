/*
Written by Olusola Olaoye
Copyright © 2020

 */
import 'package:flutter/material.dart';
import 'package:howfa/helpers/CurrentUser.dart';
import 'package:howfa/screens/BaseScreen.dart';
import 'file:///C:/Users/Olusola%20Olaoye/Documents/My%20Apps/howfa/lib/screens/AuthenticationScreen.dart';
import 'package:provider/provider.dart';
import 'package:howfa/models/User.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context)
  {
    final user = Provider.of<User>(context);
    final userList = Provider.of<List<User>>(context);

    if(user == null)
    {
      return AuthenticationScreen();
    }
    else
    {
      User currentUser;
      for(int i =0; i < userList.length; i++)
        {
          if(user.uid == userList[i].uid)
            {
              currentUser = User(
                  uid: userList[i].uid,
                  username: userList[i].username,
                  fullName: userList[i].fullName,
                  email: userList[i].email,
                  bio: userList[i].bio,
                  photoURL: userList[i].photoURL,
                  settings: userList[i].settings,
                  location: userList[i].location,
              );

            }
        }
      CurrentUser.user = currentUser;
      return BaseScreen(user: currentUser,);
    }
  }
}
