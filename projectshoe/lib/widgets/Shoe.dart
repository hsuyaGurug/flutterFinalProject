import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projectshoe/services/authorization.dart';

class shoe extends StatefulWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> document;
  bool favourited;
  final Function addRemoveFavourite;
  List<DocumentSnapshot<Map<String, dynamic>>> favouriteShoes;

  shoe({
    required this.document,
    required this.favourited,
    required this.addRemoveFavourite,
    required this.favouriteShoes,
  });

  State<shoe> createState() => ShoeState();
}

class ShoeState extends State<shoe> {
  Widget getWidget() {
    if (Authorization().currentUser != null) {
      return Column(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 30.0),
            child: Icon(Icons.shopping_bag_outlined),
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
                    Container(
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
