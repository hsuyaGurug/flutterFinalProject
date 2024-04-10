import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class shoe extends StatefulWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> document;

  const shoe({required this.document});

  State<shoe> createState() => ShoeState();
}

class ShoeState extends State<shoe> {
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
                        children: [Icon(Icons.face_2)],
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
                    )
                  ],
                ),
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 30.0),
                      child: Icon(Icons.shopping_bag_outlined),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 30.0),
                      child: Icon(Icons.favorite_border_outlined),
                    )
                  ],
                )
              ],
            )));
  }
}
