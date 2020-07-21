/*
Written by Olusola Olaoye
Copyright © 2020

 */
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:howfa/helpers/CurrentUser.dart';
import 'package:howfa/models/Message.dart';
import 'package:howfa/models/Group.dart';
import 'package:howfa/models/User.dart';

class DatabaseService
{

  final CollectionReference contactsCollection = Firestore.instance.collection('Contacts');
  final CollectionReference messageCollection = Firestore.instance.collection('Messages');
  final CollectionReference userCollection = Firestore.instance.collection('Users');
  final CollectionReference groupCollection = Firestore.instance.collection('Groups');

  Future addUserToDatabase(String id, String username, String fullname, String email, String photoURL,
                          String bio, String location, String dateCreated, String settings) async
  {


    return await userCollection.document(id).setData({
      'id': id,
      'username': username,
      'fullname': fullname,
      'email': email,
      'photourl': photoURL,
      'bio': bio,
      'location': location,
      'datecreated': dateCreated,
      'settings': settings

    });
  }

  Future addChat(Message message) async
  {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    return await messageCollection.document().setData({
      'sender': message.senderID,
      'receiver': message.receiverID,
      'receivedat': message.receivedAt,
      'message': message.message,
      'messagetype': message.messageType,
      'messagereceivertype' : message.messageReceiverType,
      'read' : message.read
    });
  }

  Future addGroup( Group group) async
    {
      return await groupCollection.document().setData({
        'id': groupCollection.document().documentID,
        'name' : group.name,
        'members' : group.members.map((group) => {
          'id': group.uid,
          'username': group.username,
          'fullname': group.fullName,
          'email': group.email
        }).toList(),
      });
    }


  List<Message> getMessageListFromSnapshots(QuerySnapshot snapshot)
  {
    return snapshot.documents.map((doc){
      return Message(
        senderID: doc.data['sender'] ?? '',
        receiverID: doc.data['receiver'] ?? '',
        receivedAt: doc.data['receivedat'] ?? '',
        message: doc.data['message'] ?? '',
        messageType: doc.data['messagetype'] ?? '',
        messageReceiverType: doc.data['messagereceivertype'] ?? '',
        read: doc.data['read']
      );
    }).toList();
  }

  List<User> getUsersFromSnapshot(QuerySnapshot snapshot)
  {
    return snapshot.documents.map((doc){
      return User(
          uid: doc.data['id'],
          username: doc.data['username'],
          fullName: doc.data['fullname'],
          email: doc.data['email'],
          photoURL: doc.data['photourl'],
          bio: doc.data['bio'],
          location: doc.data['location'],
          dateCreated: doc.data['datecreated'],
          settings: doc.data['settings'],
      );
    }).toList();
  }
  
  List<Group> getGroupsFromSnapshot(QuerySnapshot snapshot)
  {
    return snapshot.documents.map((doc)
    {
      Map groupMap = Map<dynamic, dynamic>.from(doc.data);
      Group group = Group.fromMap(groupMap);

      return group;
    }
    ).toList();
  }

  Future updateUserDP(String url) async
  {
     return await userCollection.document(CurrentUser.user.uid).updateData({
      'photourl' : url
    });
  }

  Stream<List<Message>> get messages
  {
    return messageCollection.orderBy('receivedat').snapshots().map(getMessageListFromSnapshots);

  }

  Stream<List<User>> get users
  {
    return userCollection.snapshots().map(getUsersFromSnapshot);
  }
  
  Stream<List<Group>> get groups
  {
    return groupCollection.snapshots().map(getGroupsFromSnapshot);
  }
}