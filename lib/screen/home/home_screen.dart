import 'package:chat_app/data/repository/account_repository.dart';
import 'package:chat_app/screen/chat/chat_page_screen.dart';
import 'package:chat_app/utils/style/app_text_style.dart';
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Conversations',
          style: AppTextStyle.bold,
        ),
      ),
      body: _buildUserList(),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        var data = snapshot.data!.docs;
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
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              SizedBox(
                height: 100,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: List.generate(
                    accounts.length,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      child: Column(
                        children: [
                          Image.asset(
                            accounts[index].image,
                            width: 50,
                            height: 50,
                          ),
                          Text(
                            accounts[index].userName,
                            style: AppTextStyle.regular.copyWith(fontSize: 12),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                  child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  Map<String, dynamic> json =
                      data[index].data() as Map<String, dynamic>;
                  if (_auth.currentUser!.email != json["email"]) {
                    return ListTile(
                      title: Row(
                        children: [
                          Image.asset(
                            accounts[index].image,
                            width: 50,
                            height: 50,
                          ),
                          const SizedBox(width: 10,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                accounts[index].userName,
                              ),
                              Text(
                                json["email"],
                              ),
                            ],
                          )
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatPageScreen(
                              receiverUserEmail: json["email"],
                              receiverUserId: json["uuid"],
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return Container();
                  }
                },
              )),
            ],
          ),
        );
      },
    );
  }
}
