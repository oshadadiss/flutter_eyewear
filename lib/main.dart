import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_eyewear/Screens/login_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_eyewear/Screens/LandingPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
        accentColor: Color(0xFFFF1E00),
      ),
      home: LandingPage(),
    );
  }
}

class Landing extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if(snapshot.hasError){
          return Scaffold(
            body: Center(
              child: Text("Error: ${snapshot.error}"),
            ),
          );
        }
        if(snapshot.connectionState == ConnectionState.done){
          return Scaffold(
            body: Center(
              child: Text("initialized"),
            ),
          );
        }
        return Scaffold(
          body: Center(
            child: Text("initializing....."),
          ),
        );
      },
    );
  }
}




