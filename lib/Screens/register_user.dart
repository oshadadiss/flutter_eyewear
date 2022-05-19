import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_eyewear/constants.dart';
import 'package:flutter_eyewear/Widgets/custom_buttons.dart';
import 'package:flutter_eyewear/Widgets/custom_inputs.dart';

class RegisterUser extends StatefulWidget {
  @override
  _RegisterUserState createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {

  //alert dialog to display errors
  Future<void>_alertDialogBuilder(String error) async{
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text("Error"),
            content: Container(
              child: Text(error),
            ),
            actions: [
              FlatButton(
                child: Text("Close"),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        }
    );
  }

  //create a new user account
  Future<String>_createAccount() async{
    try{
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _registerEmail,
          password: _registerPassword
      );
      return null;
    }on FirebaseAuthException catch(e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      }
      return e.message;
    }catch(e){
      return e.toString();
    }
  }

  void _submitForm() async {
    //set the form to loading state
    setState(() {
      _registerFormLoading = true;
    });
    //run create account method
    String _createAccountFeedback = await _createAccount();
    if(_createAccountFeedback != null){
      _alertDialogBuilder(_createAccountFeedback);

      //set the form to submit state
      setState(() {
        _registerFormLoading = false;
      });
    }else{
      //string is null, user is logged in
      Navigator.pop(context);
    }
  }


  //default form loading state
  bool _registerFormLoading = false;

  //form input field values
  String _registerEmail = "";
  String _registerPassword = "";

  //focus node for the input fields
  FocusNode _passwordFocusNode;

  @override
  void initState() {
    _passwordFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Container(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.only(
                    top: 48.0,
                  ),
                  child: Text(
                    "Create a New Account",
                    textAlign: TextAlign.center,
                    style: Constants.boldHeading,
                  ),
                ),
                Column(
                  children: [
                    CustomInput(
                      hintText: "Enter your Email",
                      onChanged: (value) {
                        _registerEmail = value;
                      },
                      onSubmit: (value) {
                        _passwordFocusNode.requestFocus();
                      },
                      textInputAction: TextInputAction.next,
                    ),
                    CustomInput(
                      hintText: "Password",
                      onChanged: (value) {
                        _registerPassword = value;
                      },
                      focusNode: _passwordFocusNode,
                      isPasswordField: true,
                      onSubmit: (value) {
                        _submitForm();
                      },
                    ),
                    CustomBtn(
                      text: "Create Account",
                      onPressed: (){
                        _submitForm();
                      },
                      isLoading: _registerFormLoading,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 16.0,
                  ),
                  child: CustomBtn(
                    text: "Back to Log In",
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    outlineBtn: true,
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
