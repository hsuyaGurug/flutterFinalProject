import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileInfo extends StatelessWidget {
  final User? user;

  ProfileInfo({required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.greenAccent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
            children: [Text("Email: ${user?.email}")],
          ),
          Row(
            children: [Text("Username: ${user?.displayName}")],
          )
        ],
      ),
    );
  }
}
