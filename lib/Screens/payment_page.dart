import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_eyewear/Widgets/custom_buttons.dart';
import 'package:flutter_eyewear/Widgets/custom_inputs.dart';
import 'package:flutter_eyewear/services/firebase_services.dart';

class PaymentPage extends StatefulWidget {

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {

  TextEditingController _fName = TextEditingController();
  TextEditingController _lName = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _address = TextEditingController();
  TextEditingController _city = TextEditingController();
  TextEditingController _pCode = TextEditingController();
  TextEditingController _cNumber = TextEditingController();


  FirebaseServices _firebaseServices = FirebaseServices();

  _submit (){
    Map<String, dynamic> _data = {
      "First Name" : _fName.text,
      "Last Name" : _lName.text,
      "Email" : _email.text,
      "Address" : _address.text,
      "City" : _city.text,
      "Postal Code" : _pCode.text,
      "Contact Number" : _cNumber.text
    };
    _firebaseServices.usersReference.doc(_firebaseServices.getUserID()).collection("Orders").add(_data);
  }


  @override
  Widget build(BuildContext context) {

    createAlterDialog1(BuildContext context){
      return showDialog(context: context, builder: (context){
        return AlertDialog(
          title: Text("Error"),
          actions: <Widget>[
            MaterialButton(
              elevation: 5.0,
              child: Text("OK"),
              onPressed: (){
                Navigator.pop(context);
              },
            )
          ],
        );
      });
    }

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 20.0
                  ),
                  child: TextFormField(
                    controller: _fName,
                    decoration: InputDecoration(
                      hintText: "First Name",
                      ),
                    ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 20.0
                  ),
                  child: TextFormField(
                    controller: _lName,
                    decoration: InputDecoration(
                      hintText: "Second Name",
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 20.0
                  ),
                  child: TextFormField(
                    controller: _email,
                    decoration: InputDecoration(
                      hintText: "Email",
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 20.0
                  ),
                  child: TextFormField(
                    controller: _address,
                    decoration: InputDecoration(
                      hintText: "Address",
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 20.0
                  ),
                  child: TextFormField(
                    controller: _city,
                    decoration: InputDecoration(
                      hintText: "City",
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 20.0
                  ),
                  child: TextFormField(
                    controller: _pCode,
                    decoration: InputDecoration(
                      hintText: "Postal Code",
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 20.0
                  ),
                  child: TextFormField(
                    controller: _cNumber,
                    decoration: InputDecoration(
                      hintText: "Contact Number",
                    ),
                  ),
                ),
                CustomBtn(
                  text: "Confirm Order",
                  onPressed: (){
                    if(_fName.text.isEmpty || _lName.text.isEmpty || _email.text.isEmpty || _address.text.isEmpty || _city.text.isEmpty || _pCode.text.isEmpty || _cNumber.text.isEmpty){
                      createAlterDialog1(context);
                      }
                    else
                    _submit();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
