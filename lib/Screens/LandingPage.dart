import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_eyewear/constants.dart';
import 'package:flutter_eyewear/Screens/home_page.dart';
import 'package:flutter_eyewear/Screens/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LandingPage extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          //if snapshot has errors
          if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Text("Error: ${snapshot.error}"),
              ),
            );
          }

          //connection initialized - firebase app is running
          if (snapshot.connectionState == ConnectionState.done) {
            return StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, streamSnapshot) {
                //if stream snapshot has errors
                if (streamSnapshot.hasError) {
                  return Scaffold(
                    body: Center(
                      child: Text("Error: ${streamSnapshot.error}"),
                    ),
                  );
                }

                //connection state active
                //do the user login check inside if statement
                if(streamSnapshot.connectionState == ConnectionState.active){

                  //get user
                  User _user = streamSnapshot.data;

                  //if user is null
                  //not logged in
                  if(_user == null){
                    return LoginPage();
                  }else{
                    //user logged in
                    return HomePage();
                  }
                }

                //checking the auth state - loading
                return Scaffold(
                  body: Center(
                    child: Text(
                      "Checking Authentication..",
                      style: Constants.regularHeading,
                    ),
                  ),
                );
              },
            );
          }

          //connecting to firebase - loading
          return Scaffold(
            body: Center(
              child: Text(
                "Initializing App..",
                style: Constants.regularHeading,
              ),
            ),
          );
        });
  }
}
