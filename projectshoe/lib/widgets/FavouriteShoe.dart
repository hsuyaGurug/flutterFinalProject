import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projectshoe/services/authorization.dart';

class favouriteShoe extends StatefulWidget {
  final DocumentSnapshot<Map<String, dynamic>> document;
  final Function addRemoveFavourite;
  final Function parentCallback;
  final Function addCart;

  favouriteShoe({
    required this.document,
    required this.addRemoveFavourite,
    required this.parentCallback,
    required this.addCart,
  });

  State<favouriteShoe> createState() => favouriteShoeState();
}

class favouriteShoeState extends State<favouriteShoe> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController shoeSizeController = TextEditingController();

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
                                          title: const Text(
                                              "What is the shoe size?"),
                                          content: Center(
                                            child: Column(
                                              children: [
                                                TextFormField(
                                                  decoration:
                                                      const InputDecoration(
                                                          hintText:
                                                              "Shoe Size"),
                                                  controller:
                                                      shoeSizeController,
                                                  validator: (input) {
                                                    return (int.tryParse(
                                                                    input!) !=
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
                                                  if (shoeSizeController.text !=
                                                          "" &&
                                                      formKey.currentState!
                                                          .validate()) {
                                                    //Add to the database and the cart
                                                    var shoe =
                                                        widget.document.data();
                                                    shoe?["size"] =
                                                        shoeSizeController.text;
                                                    //Only add to database if user logged in
                                                    if (Authorization()
                                                            .currentUser !=
                                                        null) {
                                                      widget.addCart(
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
