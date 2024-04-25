import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class favouriteShoe extends StatefulWidget {
  final DocumentSnapshot<Map<String, dynamic>> document;
  final Function addRemoveFavourite;
  final Function parentCallback;

  favouriteShoe({
    required this.document,
    required this.addRemoveFavourite,
    required this.parentCallback,
  });

  State<favouriteShoe> createState() => favouriteShoeState();
}

class favouriteShoeState extends State<favouriteShoe> {
  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 5.0,
        key: Key('shoe-${widget.document.id}'),
        child: Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            style: TextStyle(fontSize: 20.0),
                            "${widget.document.data()!["Brand"]} ${widget.document.data()!["Name"]}"),
                        Text(
                            style: TextStyle(fontSize: 20.0),
                            "\$ ${widget.document.data()!["Cost"]}.00")
                      ],
                    ),
                    const Column(
                      children: [
                        SizedBox(
                          height: 100.0,
                          child: Row(
                            children: [Icon(Icons.gamepad)],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () => {},
                      child: const Column(children: [
                        Icon(Icons.shopping_basket_sharp),
                        Text("Add to Cart"),
                      ]),
                    ),
                    GestureDetector(
                      onTap: () => {
                        widget.addRemoveFavourite(widget.document, false),
                        widget.parentCallback()
                      },
                      child: const Column(
                        children: [
                          Icon(Icons.heart_broken_sharp),
                          Text("Unfavourite")
                        ],
                      ),
                    )
                  ],
                )
              ],
            )));
  }
}
