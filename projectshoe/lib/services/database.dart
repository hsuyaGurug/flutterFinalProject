// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projectshoe/services/authorization.dart';

class Database {
  Future<void> createNewUser(
      String? userId, String? userName, String? userEmail) async {
    print('Database createNewUser: TRY');
    try {
      await FirebaseFirestore.instance.collection("users").doc(userId).set({
        "name": userName,
        "email": userEmail,
      });
      print('Database createNewUser: SUCCESS');
    } catch (e) {
      print('Database createNewUser: CATCH $e.toString');
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamOfShoes() {
    print('Database streamOfAppData: TRY');
    try {
      return FirebaseFirestore.instance.collection("shoe").snapshots();
    } catch (e) {
      print('Database streamOfAppData: CATCH $e');
      rethrow;
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> favouriteShoes(String userId) {
    try {
      return FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection("favourites")
          .get();
    } catch (e) {
      print('Database streamOfFavourites: Catch $e');
      rethrow;
    }
  }

  Future<void> addFavouriteShoe(
      Map<String, dynamic> shoe, String userId) async {
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection("favourites")
          .add(shoe);
    } catch (e) {
      print('Database addFavouriteShoe: CATCH $e.toString');
    }
  }

  Future<void> removeFavouriteShoe(String userId, int shoeId) async {
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection("favourites")
          .where("id", isEqualTo: shoeId)
          .get()
          .then((value) => value.docs.forEach((element) {
                element.reference.delete();
              }));
    } catch (e) {
      print('Database removeFavouriteShoe: CATCH $e.toString');
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getCartItems(String userId) {
    try {
      return FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection("cart")
          .get();
    } catch (e) {
      print('Database streamOfFavourites: Catch $e');
      rethrow;
    }
  }

  Future<void> addCartShoe(Map<String, dynamic> shoe, String userId) async {
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection("cart")
          .add(shoe);
      print("SUCCESSS WOWZERS");
    } catch (e) {
      print('Database addCartShoe: CATCH $e.toString');
    }
  }

  Future<void> removeCartShoe(
      String userId, int shoeId, String shoeSize) async {
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection("cart")
          .where("id", isEqualTo: shoeId)
          .where("size", isEqualTo: shoeSize)
          .get()
          .then((value) => value.docs.forEach((element) {
                element.reference.delete();
              }));
    } catch (e) {
      print('Database addCartShoe: CATCH $e.toString');
    }
  }

  Future<void> checkout(
      String userId, List<Map<String, dynamic>> cartItem) async {
    String? id;
    try {
      //Create a new record

      await FirebaseFirestore.instance.collection("Records").add({
        "Buyer": userId,
        "Date": DateTime.now().toUtc(),
        "TotalCost": cartItem.fold(0.00, (p, c) => p + c["Cost"])
      }).then((DocumentReference docRef) => id = docRef.id);

      if (Authorization().currentUser != null) {
        await getCartItems(userId).then((snapshot) => {
              for (DocumentSnapshot doc in snapshot.docs)
                {
                  FirebaseFirestore.instance
                      .collection("Records")
                      .doc(id)
                      .collection("Shoes")
                      .add(doc.data() as Map<String, dynamic>)
                }
            });
      } else {
        for (var doc in cartItem) {
          FirebaseFirestore.instance
              .collection("Records")
              .doc(id)
              .collection("Shoes")
              .add(doc);
        }
      }
      // empty the cart in the user
      await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection("cart")
          .get()
          .then((snapshot) => {
                for (DocumentSnapshot doc in snapshot.docs)
                  {doc.reference.delete()}
              });
      //Create a record of the checkout
    } catch (e) {
      print("Checkout: Catch $e");
    }
  }
}
