import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:projectshoe/services/authorization.dart';

class CartShoe extends StatelessWidget {
  final Function removeShoe;
  final Map<String, dynamic> shoe;
  final Function parentCallback;

  CartShoe(
      {required this.removeShoe,
      required this.shoe,
      required this.parentCallback});

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: Key('shoe-${shoe["id"]}'),
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) async {
              removeShoe(Authorization().currentUser!.uid, shoe);
              parentCallback();
            },
            icon: Icons.remove_circle_outline,
            backgroundColor: const Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            label: "Remove",
          )
        ],
      ),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${shoe["Brand"]} ${shoe["Name"]}",
                    style: const TextStyle(fontSize: 25.0),
                  ),
                  Text("Cost: ${shoe["Cost"]}",
                      style: const TextStyle(fontSize: 20.0))
                ],
              ),
              Text("Size ${shoe["size"]}",
                  style: const TextStyle(fontSize: 20.0))
            ],
          ),
        ),
      ),
    );
  }
}
