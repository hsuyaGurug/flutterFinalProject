import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projectshoe/services/database.dart';
import 'package:projectshoe/widgets/Shoe.dart';

class Explore extends StatefulWidget {
  State<Explore> createState() => ExploreState();
}

class ExploreState extends State<Explore> {
  Database db = Database();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Explore"),
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
                  return const LinearProgressIndicator();
                }
                print('Data: YES');
                var listOfDocs = snapshot.data!.docs;
                print(listOfDocs.length);

                return Expanded(
                  child: ListView.builder(
                      itemCount: listOfDocs.length,
                      itemBuilder: (BuildContext context, index) {
                        var doc = listOfDocs[index];
                        return shoe(document: doc);
                      }),
                );
              })
        ]),
      ),
    );
  }
}
