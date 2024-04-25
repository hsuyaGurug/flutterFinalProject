import 'package:flutter/material.dart';
import 'package:projectshoe/services/authorization.dart';
import 'package:projectshoe/widgets/ProfileInfo.dart';
import 'package:projectshoe/widgets/logIn.dart';

class Profile extends StatefulWidget {
  final bool loggedIn;
  final Function authCallback;

  Profile({
    required this.loggedIn,
    required this.authCallback,
  });

  @override
  State<Profile> createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    if (widget.loggedIn) {
      return Scaffold(
          appBar: AppBar(
            title: const Text("Profile"),
          ),
          body: Column(
            children: [
              ProfileInfo(
                user: Authorization().currentUser,
              ),
              ElevatedButton(
                child: const Text("Log Out"),
                onPressed: () async {
                  try {
                    await Authorization().logOut();
                    //Update the parent State
                    widget.authCallback();
                    setState(() {});
                  } catch (e) {
                    print(e);
                  }
                },
              ),
            ],
          ));
    } else {
      return Login(
        authCallback: widget.authCallback,
        loggedIn: widget.loggedIn,
      );
    }
  }
}
