import 'package:flutter/material.dart';

class ImageSwipe extends StatefulWidget {
  final List imageList;
  ImageSwipe({this.imageList});

  @override
  _ImageSwipeState createState() => _ImageSwipeState();
}

class _ImageSwipeState extends State<ImageSwipe> {
  int _selectedPage = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
        height:400.0,
        child: Stack(
          children: [
            PageView(
              onPageChanged: (num){
                setState(() {
                  _selectedPage = num;
                });
              },
            children: [
              for(var i=0; i < widget.imageList.length; i++ )
                Container(
                  child: Image.network("${widget.imageList[i]}",
                    fit: BoxFit.cover,
                  ),
                )
            ],
          ),
            Positioned(
              bottom: 20.0,
              left: 0.0,
              right: 0.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for(var i=0; i < widget.imageList.length; i++ )
                    AnimatedContainer(
                      duration: Duration(
                        milliseconds: 300
                      ),
                      curve: Curves.easeInOutCubic,
                      margin: EdgeInsets.symmetric(
                        horizontal: 5.0,
                      ),
                      width: _selectedPage == i ? 16.0 : 10.0,
                      height: _selectedPage == i ? 16.0 : 10.0,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(10.0)
                      ),
                    ),
                ],
              ),
            ),
          ],
        )
    );
  }
}
