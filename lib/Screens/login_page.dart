import 'package:flutter/material.dart';
import 'package:flutter_eyewear/Screens/register_user.dart';
import 'package:flutter_eyewear/constants.dart';
import 'package:flutter_eyewear/Widgets/custom_buttons.dart';
import 'package:flutter_eyewear/Widgets/custom_inputs.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

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
  Future<String>_loginAccount() async{
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _loginEmail,
          password: _loginPassword
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
      _loginFormLoading = true;
    });
    //run create account method
    String _loginFeedback = await _loginAccount();
    if(_loginFeedback != null){
      _alertDialogBuilder(_loginFeedback);

      //set the form to submit state
      setState(() {
        _loginFormLoading = false;
      });
    }
  }


  //default form loading state
  bool _loginFormLoading = false;

  //form input field values
  String _loginEmail = "";
  String _loginPassword = "";

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
                    "Welcome\nPlease Log In to your account",
                    textAlign: TextAlign.center,
                    style: Constants.boldHeading,
                  ),
                ),
                Column(
                  children: [
                    CustomInput(
                      hintText: "Enter your Email",
                      onChanged: (value) {
                        _loginEmail = value;
                      },
                      onSubmit: (value) {
                        _passwordFocusNode.requestFocus();
                      },
                      textInputAction: TextInputAction.next,
                    ),
                    CustomInput(
                      hintText: "Password",
                      onChanged: (value) {
                        _loginPassword = value;
                      },
                      focusNode: _passwordFocusNode,
                      isPasswordField: true,
                      onSubmit: (value) {
                        _submitForm();
                      },
                    ),
                    CustomBtn(
                      text: "Log In",
                      onPressed: (){
                        _submitForm();
                      },
                      isLoading: _loginFormLoading,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 16.0,
                  ),
                  child: CustomBtn(
                    text: "Create New Account",
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterUser()
                          )
                      );
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
