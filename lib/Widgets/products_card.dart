import 'package:flutter/material.dart';
import 'package:flutter_eyewear/Screens/product_page.dart';

class productsCard extends StatelessWidget {
  final String productID;
  final Function onPresssed;
  final String imageUrl;
  final String title;
  final String price;
  productsCard({this.onPresssed, this.imageUrl, this.title, this.price, this.productID});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => ProductPage(productID: productID,)
        ));
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
        ),
        height: 350.0,
        margin: EdgeInsets.symmetric(
          vertical: 12.0,
          horizontal: 24.0,
        ),
        child: Stack(
            children: [
              Container(
                height: 350,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.network("$imageUrl",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        price,
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Theme.of(context).accentColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ]
        ),
      ),
    );
  }
}
