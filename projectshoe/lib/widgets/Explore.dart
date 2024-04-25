import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projectshoe/services/database.dart';
import 'package:projectshoe/widgets/Shoe.dart';

class Explore extends StatefulWidget {
  final Function addRemoveFavourite;
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> favouriteShoes;
  final List<Map<String, dynamic>> cartItems;
  final Function addToCart;

  Explore(
      {required this.addRemoveFavourite,
      required this.favouriteShoes,
      required this.cartItems,
      required this.addToCart});

  State<Explore> createState() => ExploreState();
}

class ExploreState extends State<Explore> {
  Database db = Database();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Explore"),
        scrolledUnderElevation: 20.0,
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          StreamBuilder(
              stream: db.streamOfShoes(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                print('home.StreamBuilder.builder ${snapshot.connectionState}');
                if (snapshot.hasError) {
                  print('Error: ${snapshot.error}');
                }
                if (!snapshot.hasData) {
                  print('Data: NO');
                  return const CircularProgressIndicator();
                }
                print('Data: YES');
                var listOfDocs = snapshot.data!.docs;
                print(listOfDocs.length);

                return Expanded(
                  child: ListView.builder(
                      itemCount: listOfDocs.length,
                      itemBuilder: (BuildContext context, index) {
                        var doc = listOfDocs[index];

                        return Shoe(
                          document: doc,
                          favourited: widget.favouriteShoes.any(
                              (shoe) => shoe.data()["id"] == doc.data()["id"]),
                          favouriteShoes: widget.favouriteShoes,
                          addRemoveFavourite: widget.addRemoveFavourite,
                          cartItems: widget.cartItems,
                          addToCart: widget.addToCart,
                        );
                      }),
                );
              })
        ]),
      ),
    );
  }
}
