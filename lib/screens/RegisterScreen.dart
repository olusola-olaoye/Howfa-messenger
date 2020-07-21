/*
Written by Olusola Olaoye
Copyright © 2020

 */
import 'package:flutter/material.dart';
import 'package:howfa/services/AuthService.dart';
class RegisterScreen extends StatefulWidget
{
  final Function toggleView;
  RegisterScreen({this.toggleView});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
{
  final AuthService auth = AuthService();

  final formKey = GlobalKey<FormState>();

  String username = '';

  String fullName = '';

  String email = '';

  String password = '';

  String error = '';
  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      appBar: AppBar(
        title: Text("Register"),
        actions: <Widget>[
          FlatButton.icon(onPressed: (){
            widget.toggleView();
          }, icon: Icon(Icons.person), label: Text("Sign In")
          )
        ],
      ),

      body: Container(
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
        child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20,),
              TextFormField(
                  decoration: InputDecoration(hintText: "Username"),
                  validator: (val) => val.isEmpty ? "Enter a valid username" : null,
                  onChanged: (val){
                    setState(() {
                      username = val;
                    });
                  }
              ),
              SizedBox(height: 30),

              TextFormField(
                  decoration: InputDecoration(hintText: "Full Name"),
                  validator: (val) => val.isEmpty? "Enter a valid name" : null,
                  onChanged: (val){
                    setState(() {
                      fullName = val;
                    });
                  }
              ),
              SizedBox(height: 30),

              TextFormField(
                  decoration: InputDecoration(hintText: "Email"),
                  validator: (val) => val.isEmpty? "Enter an Email" : null,
                  onChanged: (val){
                    setState(() {
                      email = val;
                    });
                  }
              ),
              SizedBox(height: 30),

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
              SizedBox(height: 30),

              TextFormField(
                  decoration: InputDecoration(hintText: "Confirm Password"),
                  validator: (val) => val.length < 6? "" : null,
                  obscureText: true,
                  onChanged: (val){
                    setState(() {
                      password = val;
                    });
                  }
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: RaisedButton(
                  
                  color: Colors.blue,
                  child: Text("Register"),
                  onPressed: () async{
                    if(formKey.currentState.validate())
                    {
                      dynamic result = auth.registerEmailPassword(username, fullName, email, password);
                      if(result == null)
                      {
                        setState(() {
                          error = "error";
                        });
                      }
                    }
                  },
                ),
              )
              ,
              SizedBox(height: 10),
              Text(error, style: TextStyle(color: Colors.red),),
            ],
          ),
        )
        ,
      ),

    ));
  }
}
