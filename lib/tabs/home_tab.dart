import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_eyewear/Screens/product_page.dart';
import 'package:flutter_eyewear/Widgets/custom_action_bar.dart';
import 'package:flutter_eyewear/Widgets/products_card.dart';

class HomeTab extends StatelessWidget {
  final CollectionReference _productsReference = FirebaseFirestore.instance.collection("Products");

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          FutureBuilder<QuerySnapshot>(
            future: _productsReference.get(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Scaffold(
                  body: Center(
                    child: Text("Error: ${snapshot.error}"),
                  ),
                );
              }

              //collection data ready to display
              if(snapshot.connectionState == ConnectionState.done) {
                //display data inside list view
                return ListView(
                  padding: EdgeInsets.only(
                    top: 100.0,
                    bottom: 12.0,
                  ),
                  children: snapshot.data.docs.map((document) {
                    return productsCard(
                      title: document.data()['name'],
                      imageUrl: document.data()['images'][0],
                      price: "LKR ${document.data()['Price']}",
                      productID: document.id,

                    );
                  }).toList(),
                );
              }

              //loading state
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
          ),
          CustomActionBar(
            title: "Home",
            hasTitle: true,
            hasBackArrow: false,
          ),
        ],
      ),
    );
  }
}
