import 'package:chat_app/services/chat_services.dart';
import 'package:chat_app/utils/style/app_text_style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatPageScreen extends StatefulWidget {
  const ChatPageScreen({
    super.key,
    required this.receiverUserEmail,
    required this.receiverUserId,
  });

  final String receiverUserEmail;
  final String receiverUserId;

  @override
  State<ChatPageScreen> createState() => _ChatPageScreenState();
}

class _ChatPageScreenState extends State<ChatPageScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ChatServices _chatServices = ChatServices();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatServices.sentMessage(
        recieverId: widget.receiverUserId,
        message: _messageController.text,
      );
      _messageController.clear();
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          widget.receiverUserEmail,
          style: AppTextStyle.bold.copyWith(
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildMessageList(),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return StreamBuilder(
      stream: _chatServices.getMessages(
        widget.receiverUserId,
        _firebaseAuth.currentUser!.uid,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView(
          children: snapshot.data!.docs
              .map(
                (e) => _buildMessageItems(e),
              )
              .toList(),
        );
      },
    );
  }

  Widget _buildMessageItems(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    var alignment = (data['sender_id'] == _firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;
    return Container(
      alignment: alignment,
      child: Column(
        children: [
          Text(
            data['sender_email'],
            style: AppTextStyle.regular,
          ),
          Text(
            data['message'],
            style: AppTextStyle.bold,
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            style: AppTextStyle.regular,
            controller: _messageController,
            decoration: InputDecoration(
                hintStyle: AppTextStyle.regular, hintText: 'Enter a message'),
          ),
        ),
        IconButton(
          icon: const Icon(
            Icons.send_sharp,
            color: Colors.blue,
          ),
          onPressed: sendMessage,
        ),
      ],
    );
  }
}
