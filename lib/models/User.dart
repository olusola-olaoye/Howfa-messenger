/*
Written by Olusola Olaoye
Copyright © 2020

 */

class User
{
  String uid;

  String username;

  String fullName;

  String email;

  String photoURL;

  String bio;

  String location;

  String dateCreated;

  String settings;

  User({this.uid, this.username, this.fullName, this.email, this.photoURL, this.bio, this.location, this.dateCreated, this.settings});

  factory User.fromMap(Map<dynamic, dynamic> map)
  {
    return User(
      uid: map['id'],
      username: map['username'],
      fullName: map['fullname'],
      email: map['email'],

      photoURL: map['photourl'],
      bio: map['bio'],
      location: map['location'],
      dateCreated: map['datecreated'],
      settings: map['settings'],


    );
  }
}

