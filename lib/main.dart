/*
Written by Olusola Olaoye
Copyright © 2020

 */
import 'package:flutter/material.dart';
import 'package:howfa/services/DatabaseService.dart';
import 'screens/HomeScreen.dart';
import 'package:provider/provider.dart';
import 'models/User.dart';
import 'services/AuthService.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return
    MultiProvider(
      providers: [
        StreamProvider<User>(create: (_)=> AuthService().user),
        StreamProvider<List<User>>(create: (_)=> DatabaseService().users),
      ],
      child: MaterialApp(
        title: "Howfa",
        debugShowCheckedModeBanner: false,
        home : HomeScreen(
        ),
      ),
    );
  }
}
