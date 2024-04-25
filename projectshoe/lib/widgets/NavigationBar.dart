import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projectshoe/services/authorization.dart';
import 'package:projectshoe/services/database.dart';
import 'package:projectshoe/widgets/Cart.dart';
import 'package:projectshoe/widgets/Explore.dart';
import 'package:projectshoe/widgets/Favorite.dart';
import 'package:projectshoe/widgets/Profile.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => NavState();
}

class NavState extends State<NavBar> {
  Database db = Database();
  int _currentIndex = 0;
  //checks if the user is logged in or not
  bool loggedIn = Authorization().currentUser == null ? false : true;

  //list of favourite shoes
  List<QueryDocumentSnapshot<Map<String, dynamic>>> favouriteShoes = [];
  //List of items in cart
  List<Map<String, dynamic>> cart = [];

  void getFavouriteShoes() async {
    var snapshot = await db.favouriteShoes(Authorization().currentUser!.uid);
    favouriteShoes = snapshot.docs;
    setState(() {});
  }

  void getCartItems() async {
    var snapshot = await db.getCartItems(Authorization().currentUser!.uid);
    snapshot.docs.forEach((element) {
      cart.add(element.data());
    });
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (loggedIn) {
      getFavouriteShoes();
      getCartItems();
    } else {
      favouriteShoes = [];
      cart = [];
    }
  }

  //Callback function for the childwidgets
  void addRemoveFavourite(
      QueryDocumentSnapshot<Map<String, dynamic>> shoe, bool adding) {
    if (adding) {
      favouriteShoes.add(shoe);
      if (loggedIn) {
        db.addFavouriteShoe(shoe.data(), Authorization().currentUser!.uid);
      }
    } else {
      favouriteShoes.remove(shoe);
      if (loggedIn) {
        db.removeFavouriteShoe(
            Authorization().currentUser!.uid, shoe.data()["id"]);
      }
    }
  }

  void addToCart(Map<String, dynamic> shoe, userId) {
    db.addCartShoe(shoe, userId);
    cart.add(shoe);
  }

  void removeFromCart(String userId, Map<String, dynamic> shoe) {
    db.removeCartShoe(userId, shoe["id"], shoe["size"]);
    cart.remove(shoe);
  }

  void checkout(String userId, List<Map<String, dynamic>> cartItems) {
    db.checkout(userId, cartItems);
    cart = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const <Widget>[
          NavigationDestination(icon: Icon(Icons.search), label: "Explore"),
          NavigationDestination(icon: Icon(Icons.favorite), label: "Favorite"),
          NavigationDestination(
              icon: Icon(Icons.shopping_basket), label: "Cart"),
          NavigationDestination(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
      body: <Widget>[
        Explore(
          favouriteShoes: favouriteShoes,
          addRemoveFavourite: addRemoveFavourite,
          cartItems: cart,
          addToCart: addToCart,
        ),
        Favorite(
          loggedIn: loggedIn,
          authCallback: () {
            setState(() {
              loggedIn = Authorization().currentUser == null ? false : true;
              if (loggedIn) {
                getCartItems();
                getFavouriteShoes();
              } else {
                cart = [];
                favouriteShoes = [];
              }
            });
          },
          favouriteCallback: addRemoveFavourite,
          favouriteShoes: favouriteShoes,
          addCart: addToCart,
        ),
        Cart(
          cart: cart,
          removeShoeFromCart: removeFromCart,
          checkout: checkout,
          parentCallback: () {
            setState(() {});
          },
        ),
        Profile(
          loggedIn: loggedIn,
          authCallback: () {
            setState(() {
              loggedIn = Authorization().currentUser == null ? false : true;
              if (loggedIn) {
                getCartItems();
                getFavouriteShoes();
              } else {
                cart = [];
                favouriteShoes = [];
              }
            });
          },
        ),
        //Explore View
      ][_currentIndex],
    );
  }
}
