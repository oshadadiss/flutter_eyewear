import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_eyewear/Widgets/custom_action_bar.dart';
import 'package:flutter_eyewear/Widgets/image_swipe.dart';
import 'package:flutter_eyewear/constants.dart';
import 'package:flutter_eyewear/services/firebase_services.dart';
import 'package:external_app_launcher/external_app_launcher.dart';

class ProductPage extends StatefulWidget {
  final String productID;
  ProductPage({this.productID});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  FirebaseServices _firebaseServices = FirebaseServices();

  int total = 0;

  Future _addToCart(){
    return _firebaseServices.usersReference.doc(_firebaseServices.getUserID()).collection("Cart").doc(widget.productID).set(
      {}
    );
  }

  Future _addToSaved(){
    return _firebaseServices.usersReference.doc(_firebaseServices.getUserID()).collection("Saved").doc(widget.productID).set(
        {}
    );
  }

  final SnackBar _snackBar = SnackBar(content: Text("Product added to the cart"),);
  final SnackBar _snackBar2 = SnackBar(content: Text("Product Bookmarked"),);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder(
            future: _firebaseServices.productsReference.doc(widget.productID).get(),
            builder: (context, snapshot) {
              if(snapshot.hasError){
                return Scaffold(
                  body: Center(
                    child: Text("Error: ${snapshot.error}"),
                  ),
                );
              }

              if(snapshot.connectionState == ConnectionState.done){

                Map<String, dynamic> documentdata = snapshot.data.data();

                List imageList = documentdata['images'];

                return ListView(
                  padding: EdgeInsets.all(0),
                  children: [
                    ImageSwipe(imageList: imageList,),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 24.0,
                        left: 24.0,
                        right: 24.0,
                        bottom: 4.0
                      ),
                      child: Text("${documentdata['name']}" ?? "Product Name",
                      style: Constants.boldHeading,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4.0,
                        horizontal: 24.0,
                        ),
                      child: Text("LKR ${documentdata['Price']}" ?? "Price",
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Theme.of(context).accentColor,
                        fontWeight: FontWeight.w600
                      ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4.0,
                        horizontal: 24.0,
                        ),
                      child: Text("${documentdata['Description']}" ?? "Description",
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap:() async{
                              await _addToSaved();
                              Scaffold.of(context).showSnackBar(_snackBar2);
                            },
                            child: Container(
                              width: 60.0,
                              height:60.0,
                              decoration: BoxDecoration(
                                color: Color(0xFFDCDCDC),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              alignment: Alignment.center,
                              child: Image(
                                image: AssetImage("assets/images/tab_saved.png"),
                                width: 15.0,
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap:() async{
                                await _addToCart();
                                total = total + documentdata['Price'];
                                Scaffold.of(context).showSnackBar(_snackBar);
                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                  left: 16.0,
                                  right: 16.0,
                                ),
                                width: 180.0,
                                height: 60.0,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                alignment: Alignment.center,
                                child: Text("Add to cart",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 18.0,
                                ),),
                              ),
                            ),
                          ),
                          ElevatedButton(style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(
                            vertical: 18.0,
                            horizontal: 20.0,
                          )),
                              child: Text("Try On"),
                              onPressed: () async {
                                await LaunchApp.openApp(
                                  androidPackageName: 'com.DefaultCompany.ARApp',
                                  // openStore: false
                                );
                              })
                        ],
                      ),
                    )
                  ],
                );
              }

              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
          ),
          CustomActionBar(
            hasBackArrow: true,
            hasTitle: false,
            hasBackground: false,
          ),
        ],
      ),
    );
  }
}
