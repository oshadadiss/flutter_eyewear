import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseServices {
  //collection reference user id
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  //collection reference firebase firestore
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  String getUserID(){
    return _firebaseAuth.currentUser.uid;
  }


  //calling products
  final CollectionReference productsReference = FirebaseFirestore.instance.collection("Products");

  //adding to cart
  //User -> UserID{Document} -> Cart -> ProductID{Document}
  final CollectionReference usersReference = FirebaseFirestore.instance.collection("Users");


  final CollectionReference savedReference = FirebaseFirestore.instance.collection("Saved");


}
