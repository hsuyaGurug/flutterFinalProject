import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projectshoe/services/authorization.dart';

class Shoe extends StatefulWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> document;
  bool favourited;
  final Function addRemoveFavourite;
  List<DocumentSnapshot<Map<String, dynamic>>> favouriteShoes;
  List<Map<String, dynamic>> cartItems;
  final Function addToCart;

  Shoe(
      {required this.document,
      required this.favourited,
      required this.addRemoveFavourite,
      required this.favouriteShoes,
      required this.cartItems,
      required this.addToCart});

  @override
  State<Shoe> createState() => ShoeState();
}

class ShoeState extends State<Shoe> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController shoeSizeController = TextEditingController();

  Widget getWidget() {
    if (Authorization().currentUser != null) {
      return Column(
        children: [
          GestureDetector(
            onTap: () => {
              showDialog(
                  context: context,
                  builder: (context) => Form(
                        key: formKey,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              AlertDialog(
                                title: const Text("What is the shoe size?"),
                                content: Center(
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        decoration: const InputDecoration(
                                            hintText: "Shoe Size"),
                                        controller: shoeSizeController,
                                        validator: (input) {
                                          return (int.tryParse(input!) !=
                                                      null ||
                                                  input == "")
                                              ? null
                                              : 'Provide a number.';
                                        },
                                      )
                                    ],
                                  ),
                                ),
                                actions: [
                                  IconButton(
                                    icon: const Icon(Icons.add),
                                    onPressed: () {
                                      try {
                                        if (shoeSizeController.text != "" &&
                                            formKey.currentState!.validate()) {
                                          //Add to the database and the cart
                                          var shoe = widget.document.data();
                                          shoe["size"] =
                                              shoeSizeController.text;
                                          widget.cartItems.add(shoe);
                                          //Only add to database if user logged in
                                          if (Authorization().currentUser !=
                                              null) {
                                            widget.addToCart(
                                                shoe,
                                                Authorization()
                                                    .currentUser!
                                                    .uid);
                                          }
                                          //Resetting to the explore page
                                          shoeSizeController.clear();
                                          Navigator.pop(context);
                                        }
                                      } catch (e) {
                                        print(e);
                                      }
                                    },
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ))
            },
            child: Padding(
              padding: EdgeInsets.only(bottom: 30.0),
              child: Icon(Icons.shopping_bag_outlined),
            ),
          ),
          GestureDetector(
            onTap: () => {
              widget.addRemoveFavourite(
                  widget.document,
                  !widget.favouriteShoes.any((shoe) =>
                      shoe.data()!["id"] == widget.document.data()["id"])),
              setState(() {
                widget.favouriteShoes.any((shoe) =>
                        shoe.data()!["id"] == widget.document.data()["id"])
                    ? widget.favourited = true
                    : widget.favourited = false;
              }),
            },
            child: Padding(
              padding: EdgeInsets.only(top: 30.0),
              child: widget.favourited
                  ? Icon(Icons.favorite)
                  : Icon(Icons.favorite_border_outlined),
            ),
          )
        ],
      );
    } else {
      return Column(children: [
        Padding(
          padding: EdgeInsets.only(bottom: 30.0),
          child: widget.favourited
              ? Icon(Icons.favorite)
              : Icon(Icons.favorite_border_outlined),
        ),
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 5.0,
        key: Key('shoe-${widget.document.id}}'),
        child: Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 100.0,
                      child: const Row(
                        children: [Icon(Icons.gamepad)],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            style: TextStyle(fontSize: 20.0),
                            "${widget.document.data()["Brand"]} ${widget.document.data()["Name"]}"),
                        Text(
                            style: TextStyle(fontSize: 20.0),
                            "\$ ${widget.document.data()["Cost"]}.00")
                      ],
                    ),
                  ],
                ),
                getWidget(),
              ],
            )));
  }
}
