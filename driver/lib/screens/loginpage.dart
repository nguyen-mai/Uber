import 'package:driver/screens/registrationpage.dart';
import 'package:driver/widgets/ProgressDialog.dart';
import 'package:driver/widgets/TaxiButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';


import '../brand_colors.dart';
import '../main.dart';
import 'mainpage.dart';
class LoginPage extends StatelessWidget {

  static const String id = 'login';
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  TextEditingController emailEditingController = TextEditingController();
  TextEditingController passwordEditingController = TextEditingController();

  void showSnackBar(String title){
    final snackbar = SnackBar(
      content: Text(title, textAlign: TextAlign.center, style: TextStyle(fontSize: 15.0),),
    );
    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  void loginUser(BuildContext context) async {
    // Show please wait dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => ProgressDialog(status: 'Logging you in...',),
    );

    final User firebaseUser = (await _firebaseAuth
        .signInWithEmailAndPassword(
        email: emailEditingController.text,
        password: passwordEditingController.text)
        .catchError((errorMsg) {
          Navigator.pop(context);
          showSnackBar("Please try again");
          // displayToastMessage("Error: " + errorMsg.toString(), context);
    })).user;

    Navigator.pop(context);
    if (firebaseUser != null) // user created
      {
      usersRef.child(firebaseUser.uid).once().then((DataSnapshot snap) {
        if (snap.value != null) {
          Navigator.pushNamedAndRemoveUntil(context, MainPage.id, (route) => false);
        }
        else {
          showSnackBar("No record exists for this user. Please create new account");
          // _firebaseAuth.signOut();
          // displayToastMessage(
          //     "No record exists for this user. Please create new account",
          //     context);
        }
      });
    }
    else {
      showSnackBar("PLease try again");
      // displayToastMessage("Error occured, can not be signed", context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // key: scaffoldKey,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 70,
                ),
                Image(
                  alignment: Alignment.center,
                  height: 200.0,
                  width: 200.0,
                  image: AssetImage('images/icon.png'),
                ),
                SizedBox(
                  height: 40,
                ),
                Text(
                  'Sign In',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 30, fontFamily: 'Brand-Bold'),
                ),
                Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      children: <Widget>[
                        TextField(
                          controller: emailEditingController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              labelText: 'Email address',
                              labelStyle: TextStyle(
                                fontSize: 14.0,
                              ),
                              hintStyle: TextStyle(
                                  color: Colors.grey, fontSize: 10.0)),
                          style: TextStyle(fontSize: 14),
                        ),

                        SizedBox(
                          height: 10,
                        ),

                        TextField(
                          controller: passwordEditingController,
                          obscureText: true,
                          decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: TextStyle(
                                fontSize: 14.0,
                              ),
                              hintStyle: TextStyle(
                                  color: Colors.grey, fontSize: 10.0)),
                          style: TextStyle(fontSize: 14),
                        ),

                        SizedBox(
                          height: 40,
                        ),

                        TaxiButton(
                          title: 'LOGIN',
                          color: BrandColors.colorGreen,
                          onPressed: () {
                            if (!emailEditingController.text.contains("@")) {
                              // displayToastMessage(
                              //     "Email address is not valid", context);
                              showSnackBar("Please provide a valid email address");
                              return;
                            } else if (passwordEditingController.text.isEmpty) {
                              showSnackBar("Please provide a valid password");
                              return;
                              // displayToastMessage(
                              //     "Password is mandoatory", context);
                            } else {
                              loginUser(context);
                            }
                          },
                        ),
                      ],
                    )
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, RegistrationPage.id, (route) => false);
                    },
                    child: Text('Don\'t have an account, sign up here.'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

displayToastMessage(String message, BuildContext context) {
  Fluttertoast.showToast(msg: message);
}