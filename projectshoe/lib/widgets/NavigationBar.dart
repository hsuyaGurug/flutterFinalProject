import 'package:flutter/material.dart';
import 'package:projectshoe/services/authorization.dart';
import 'package:projectshoe/widgets/Explore.dart';
import 'package:projectshoe/widgets/Favorite.dart';
import 'package:projectshoe/widgets/Profile.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => NavState();
}

class NavState extends State<NavBar> {
  int _currentIndex = 0;
  //checks if the user is logged in or not
  bool loggedIn = Authorization().currentUser == null ? false : true;

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
        Explore(),
        Favorite(
          loggedIn: loggedIn,
          authCallback: () {
            setState(() {
              loggedIn = Authorization().currentUser == null ? false : true;
            });
          },
        ),
        Text("@2"),
        Profile(
          loggedIn: loggedIn,
          authCallback: () {
            setState(() {
              loggedIn = Authorization().currentUser == null ? false : true;
            });
          },
        ),
        //Explore View
      ][_currentIndex],
    );
  }
}
