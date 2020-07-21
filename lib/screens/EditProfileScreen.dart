/*
Written by Olusola Olaoye
Copyright © 2020

 */
import 'package:flutter/material.dart';
import 'package:howfa/helpers/CurrentUser.dart';
import 'package:howfa/models/User.dart';
import 'package:howfa/services/DatabaseService.dart';
import 'package:howfa/uploader/FileHandler.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();

  final User user;
  EditProfileScreen({this.user});
}

class _EditProfileScreenState extends State<EditProfileScreen>
{
  final imagePicker = ImagePicker();
  dynamic attachedFile;

  Future selectImage(ImageSource source) async {
    final pickedFile = await imagePicker.getImage(source: source);

    setState(() {
      attachedFile = File(pickedFile.path);
    });

    String dp_url = await FileHandler(file: attachedFile, folder_name: "display_pictures", file_name: CurrentUser.user.uid).startUpload();


    DatabaseService().updateUserDP(dp_url);

    Navigator.pop(context);

  }
  
  _showImageUploadOptions()
  {
    showModalBottomSheet(context: context, builder: (context){

      return Container(
        height: 199,
        child: Column(
          children: <Widget>[
            ListTile(
              leading: CircleAvatar(backgroundColor: Colors.white, child: Icon(Icons.camera_alt),),
              title: Text("Camera"),
              onTap: ()=> selectImage(ImageSource.camera),
            ),
            ListTile(
              leading: CircleAvatar(backgroundColor: Colors.white, child: Icon(Icons.picture_in_picture_alt),),
              title: Text("Gallery"),
              onTap: ()=> selectImage(ImageSource.gallery),
            ),
            ListTile(
              leading: CircleAvatar(backgroundColor: Colors.white, child: Icon(Icons.delete),),
              title: Text("Remove Photo"),
              onTap: ()=> selectImage(null),
            ),
            
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context)
  {

    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 25,
            ),
            Stack(

              overflow: Overflow.clip,
              children: <Widget>[
                CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(CurrentUser.user.photoURL),
                  child: CurrentUser.user.photoURL == null ?
                  Icon(Icons.person, size: 55, ) :
                  SizedBox()
                ),
                CircleAvatar(

                  radius: 12,
                  backgroundColor: Colors.red[300],
                  child: FlatButton.icon(
                    onPressed: (){
                      _showImageUploadOptions();
                    },
                    icon: Icon(
                        Icons.photo_camera,
                        color: Colors.white,
                        size: 2,
                    ),
                    label: Text(""),
                  )
                ),

              ],
            ),
            SizedBox(
              height: 30,
            ),
            ListTile(
              leading: Icon(Icons.info, color: Colors.blue,),
              title: Text("Bio"),
              subtitle: Text(CurrentUser.user.bio),

              isThreeLine: true,
              trailing: Icon(Icons.edit, size: 20, color: Colors.red[300],),
            ),

            Divider(
              height: 29,
            ),

            ListTile(
              leading: Icon(Icons.person, color: Colors.blue,),
              title: Text("Username"),
              subtitle: Text(widget.user.username),
              trailing: Icon(Icons.edit, size: 20, color: Colors.red[300],),
            ),

            ListTile(
              leading: SizedBox(),
              title: Text("Full name"),
              subtitle: Text(widget.user.fullName),
              trailing: Icon(Icons.edit, size: 20, color: Colors.red[300],),
            ),

            Divider( height: 23,),
            ListTile(
              leading: Icon(Icons.phone, color: Colors.blue,),
              title: Text("Phone number"),
              subtitle: Text("+234-000-0"),
            ),
          ],
        ),
      ),
    );
  }
}
