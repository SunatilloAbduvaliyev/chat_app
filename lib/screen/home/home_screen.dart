import 'package:chat_app/screen/chat/chat_page_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildUserList(),
    );
  }
  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot){
        if(snapshot.hasError){
          return Center(
            child: Text(snapshot.error.toString()),
          );
        }
        if(snapshot.connectionState == ConnectionState.waiting){
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView(
          children: snapshot.data!.docs.map<Widget>((e) => _buildUserListItem(e)).toList(),
        );
      },
    );
  }
  Widget _buildUserListItem(DocumentSnapshot document) {
    Map<String, dynamic> data  = document.data() as Map<String, dynamic>;
    if(_auth.currentUser!.email != data["email"]){
      return ListTile(
        title: Text(data["email"],),
        onTap: (){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>  ChatPageScreen(
                receiverUserEmail: data["email"],
                receiverUserId:  data["uuid"],
              ),
            ),
          );
        },
      );
    }else{
      return Container();
    }
  }
}
