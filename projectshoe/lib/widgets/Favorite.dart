import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projectshoe/widgets/FavouriteShoe.dart';
import 'package:projectshoe/widgets/logIn.dart';

class Favorite extends StatefulWidget {
  final bool loggedIn;
  final Function authCallback;
  final Function favouriteCallback;
  final List<DocumentSnapshot<Map<String, dynamic>>> favouriteShoes;

  Favorite(
      {required this.loggedIn,
      required this.authCallback,
      required this.favouriteCallback,
      required this.favouriteShoes});
  @override
  State<Favorite> createState() => FavoriteState();
}

class FavoriteState extends State<Favorite> {
  @override
  Widget build(BuildContext context) {
    if (widget.loggedIn) {
      return MaterialApp(
          home: Scaffold(
              appBar: AppBar(
                title: Text("Favourites"),
              ),
              body: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                        itemCount: widget.favouriteShoes.length,
                        itemBuilder: (BuildContext context, index) {
                          return favouriteShoe(
                              document: widget.favouriteShoes[index],
                              addRemoveFavourite: widget.favouriteCallback,
                              parentCallback: () => {setState(() {})});
                        }),
                  ),
                ],
              )));
    } else {
      return Login(
        authCallback: widget.authCallback,
        loggedIn: widget.loggedIn,
      );
    }
  }
}
