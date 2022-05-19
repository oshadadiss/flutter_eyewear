import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_eyewear/Widgets/custom_inputs.dart';
import 'package:flutter_eyewear/Widgets/products_card.dart';
import 'package:flutter_eyewear/constants.dart';
import 'package:flutter_eyewear/services/firebase_services.dart';

class SearchTab extends StatefulWidget {

  @override
  _SearchTabState createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  FirebaseServices _firebaseServices = FirebaseServices();

  String _search = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          if(_search.isEmpty)
            Center(
              child: Container(
                child: Text("No Search Results",
                style: Constants.regularDarkText,),
              ),
            )
          else
          FutureBuilder<QuerySnapshot>(
            future: _firebaseServices.productsReference
                .orderBy('s_string')
                .startAt([_search])
                .endAt(["$_search\uf8ff"])
                .get(),
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
                      price: "${document.data()['Price']}",
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
          Padding(
            padding: const EdgeInsets.only(
              top: 45.0
            ),
            child: CustomInput(
              hintText: "Search here",
              onSubmit: (value){
                if(value.isNotEmpty){
                  setState(() {
                    _search = value.toLowerCase();
                  });
                }
                if(value.isEmpty){
                  setState(() {
                    _search = "";
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
