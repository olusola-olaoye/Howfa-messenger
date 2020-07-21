/*
Written by Olusola Olaoye
Copyright © 2020

 */
import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget
{
  String aboutBody = "Howfa is an instant messaging application still in development. Developed by Olusola Olaoye";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[

            SizedBox(
              height: 15,
            ),

            Text(
              "Howfa",
              style: TextStyle(
                color: Colors.blue[300],
                fontSize: 34,

              ),
            ),

            SizedBox(
              height: 35,
            ),

            Text(
              aboutBody,
              style: TextStyle(

                fontSize: 13,

              ),
            ),
          ],
        ),
      ),
    );
  }
}
