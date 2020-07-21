/*
Written by Olusola Olaoye
Copyright © 2020

 */
import 'package:howfa/models/User.dart';

class Group
{
  String id;
  String name;
  List<User> members;


  Group({this.id, this.name, this.members});

  factory Group.fromMap(Map<dynamic, dynamic> map)
  {
    var members = map['members'] as List;

    List memberList = members.map((user) => User.fromMap(user)).toList();

    return Group(
      id : map['id'],
      name: map['name'],
      members: memberList
    );
  }
}