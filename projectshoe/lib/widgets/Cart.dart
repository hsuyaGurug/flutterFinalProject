import 'package:flutter/material.dart';
import 'package:projectshoe/services/authorization.dart';
import 'package:projectshoe/widgets/CartShoe.dart';

class Cart extends StatefulWidget {
  final List<Map<String, dynamic>> cart;
  final Function removeShoeFromCart;
  final Function checkout;

  Cart(
      {required this.cart,
      required this.removeShoeFromCart,
      required this.checkout});

  State<Cart> createState() => CartState();
}

class CartState extends State<Cart> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            scrolledUnderElevation: 5.0,
            title: Text(
                "Total Cost: ${widget.cart.fold(0.00, (p, c) => p + c["Cost"])}"),
            actions: [
              Padding(
                padding: EdgeInsets.all(10.0),
                child: TextButton(
                  onPressed: () => {
                    widget.checkout(
                        Authorization().currentUser!.uid, widget.cart),
                    setState(() {})
                  },
                  style: TextButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 217, 255, 233),
                      foregroundColor: Color.fromARGB(255, 0, 0, 0)),
                  child: const Text("Checkout"),
                ),
              )
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                    itemCount: widget.cart.length,
                    itemBuilder: (BuildContext context, index) {
                      return CartShoe(
                          removeShoe: widget.removeShoeFromCart,
                          shoe: widget.cart[index],
                          parentCallback: () => {setState(() {})});
                    }),
              ),
            ],
          )),
    );
  }
}
