// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';

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

  Future<QuerySnapshot<Map<String, dynamic>>> streamOfFavouriteShoes(
      String userId) {
    try {
      return FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection("favourites")
          .snapshots()
          .first;
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
}
