/*
Written by Olusola Olaoye
Copyright © 2020

 */
import 'package:flutter/material.dart';
import 'package:howfa/screens/RegisterScreen.dart';
import 'package:howfa/screens/SignInScreen.dart';

class AuthenticationScreen extends StatefulWidget {
  @override
  _AuthenticationScreenState createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  bool showSignInScreen = true;

  void toggleView()
  {
    setState(() => showSignInScreen = !showSignInScreen);
  }
  @override
  Widget build(BuildContext context) {
    if(showSignInScreen)
    {
      return  SignInScreen(toggleView: toggleView);
    }
    else
    {
      return RegisterScreen(toggleView : toggleView);
    }
  }
}
