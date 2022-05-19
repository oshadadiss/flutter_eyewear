import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_eyewear/Screens/product_page.dart';
import 'package:flutter_eyewear/Widgets/custom_action_bar.dart';
import 'package:flutter_eyewear/Widgets/custom_buttons.dart';
import 'package:flutter_eyewear/services/firebase_services.dart';
import 'package:firebase_core/firebase_core.dart';

class SavedTab extends StatefulWidget {

  final String productID;
  SavedTab({this.productID});

  @override
  _SavedTabState createState() => _SavedTabState();
}

class _SavedTabState extends State<SavedTab> {
  final FirebaseServices _firebaseServices = FirebaseServices();

  //final CollectionReference _savedCollection = FirebaseFirestore.instance.collection('Saved');

  final SnackBar _snackBar = SnackBar(content: Text("Bookmarks Cleared"),);

  CollectionReference saved = FirebaseFirestore.instance.collection('Saved');


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          FutureBuilder<QuerySnapshot>(
            future: _firebaseServices.usersReference.doc(_firebaseServices.getUserID()).collection("Saved").get(),
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
                    var docId = document.id;
                    return GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => ProductPage(productID: document.id,)
                        ));
                      },
                      child: FutureBuilder(
                        future: _firebaseServices.productsReference.doc(document.id).get(),
                        builder: (context, productSnap){
                          if(productSnap.hasError){
                            return Container(
                              child: Center(
                                child: Text("${productSnap.error}"),
                              ),
                            );
                          }


                          if(productSnap.connectionState == ConnectionState.done){
                            Map _productMap = productSnap.data.data();

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 16.0,
                                horizontal: 24.0,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 90.0,
                                    height: 90.0,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.network("${_productMap['images'][0]}",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                      left: 16.0,
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("${_productMap['name']}",
                                          style: TextStyle(
                                            fontSize: 18.0,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 4.0,
                                          ),
                                          child: Text(
                                            "LKR ${_productMap['Price']}",
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                color: Theme.of(context).accentColor,
                                                fontWeight: FontWeight.w600
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          return Container(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );

                        },
                      ),
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
            title: "Saved",
            hasTitle: true,
            hasBackArrow: false,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children:[
              Container(
                padding: EdgeInsets.only(
                  bottom: 10.0
                ),
                child: CustomBtn(
                  text: "Clear",
                  onPressed: () {
                    Scaffold.of(context).showSnackBar(_snackBar);
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
