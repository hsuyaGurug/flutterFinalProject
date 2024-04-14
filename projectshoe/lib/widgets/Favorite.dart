import 'package:flutter/material.dart';
import 'package:projectshoe/widgets/logIn.dart';

class Favorite extends StatefulWidget {
  final bool loggedIn;
  final Function authCallback;
  final Function favouriteCallback;

  Favorite(
      {required this.loggedIn,
      required this.authCallback,
      required this.favouriteCallback});
  @override
  State<Favorite> createState() => FavoriteState();
}

class FavoriteState extends State<Favorite> {
  @override
  Widget build(BuildContext context) {
    if (widget.loggedIn) {
      return Text("EEE");
    } else {
      return Login(
        authCallback: widget.authCallback,
        loggedIn: widget.loggedIn,
      );
    }
  }
}
