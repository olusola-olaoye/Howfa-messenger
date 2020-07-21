/*
Written by Olusola Olaoye
Copyright © 2020

 */

import 'package:flutter/material.dart';
import 'package:howfa/services/AuthService.dart';
class SignInScreen extends StatefulWidget
{
  final Function toggleView;
  SignInScreen({this.toggleView});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {

  final AuthService auth = AuthService();

  final formKey = GlobalKey<FormState>();

  String email = '';

  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold
      (
      
      appBar: AppBar(
        title: Text("Sign In"),

        actions: <Widget>[
          FlatButton.icon(onPressed: (){
            widget.toggleView();
          }, icon: Icon(Icons.person), label: Text("Register")
          )
        ],
      ),

      body: Container(
        color: Colors.white,
        child: Center(
            child: Flexible(
              child: Container(
                color: Colors.grey[190],
                padding: EdgeInsets.all(12),
                margin: EdgeInsets.all(42),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                  child: Form(
                    key: formKey,
                    child: Expanded(
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 20,),

                          TextFormField(
                              decoration: InputDecoration(hintText: "Email"),
                              validator: (val) => val.isEmpty? "Enter an Email" : null,
                              onChanged: (val){
                                setState(() {
                                  email = val;
                                });
                              }
                          ),
                          SizedBox(height: 80),

                          TextFormField(
                              decoration: InputDecoration(hintText: "Password"),
                              validator: (val) => val.length < 6? "Enter a long pass word" : null,
                              obscureText: true,
                              onChanged: (val){
                                setState(() {
                                  password = val;
                                });
                              }

                          ),

                          SizedBox(
                            height: 120,
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: RaisedButton(

                              color: Colors.blue,
                              child: Text("Sign In"),
                              onPressed: () async{
                                if(formKey.currentState.validate())
                                {
                                  dynamic result = auth.signIn (email, password);
                                  if(result == null)
                                  {
                                    setState(() {

                                    });
                                  }
                                }
                              },
                            ),
                          )
                          ,
                          SizedBox(height: 10),

                        ],
                      ),
                    ),
                  )
                  ,
                ),
              ),
            ),
        ),
      )
    );
  }
}
