import 'package:connectivity/connectivity.dart';
import 'package:driver/globalvariables.dart';
import 'package:driver/screens/vehicleinfo.dart';
import 'package:driver/widgets/TaxiButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../brand_colors.dart';
import '../main.dart';
import 'loginpage.dart';


class RegistrationPage extends StatelessWidget {
  static const String id = 'register';

  TextEditingController nameEditingController = TextEditingController();
  TextEditingController emailEditingController = TextEditingController();
  TextEditingController phoneEditingController = TextEditingController();
  TextEditingController passwordEditingController = TextEditingController();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void registerUser(BuildContext context) async {
    final User firebaseUser = (await _firebaseAuth
        .createUserWithEmailAndPassword(
        email: emailEditingController.text,
        password: passwordEditingController.text)
        .catchError((errorMsg) {
      displayToastMessage("Error: " + errorMsg.toString(), context);
    }))
        .user;

    if (firebaseUser != null) // user created
        {
      // save user info to db
      DatabaseReference userRef = FirebaseDatabase.instance.reference().child("drivers/${firebaseUser.uid}");

      Map userDataMap = {
        "name": nameEditingController.text.trim(),
        "email": emailEditingController.text.trim(),
        "phone": phoneEditingController.text.trim(),
      };

      userRef.child(firebaseUser.uid).set(userDataMap);
      currentFirebaseUser = firebaseUser;
      displayToastMessage(
          "Congratulations, your account has been created", context);

      Navigator.pushNamed(context, VehicleInfoPage.id);
    } else {
      // error occured - display error msg
      displayToastMessage("Driver account has not been created", context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  'Create New Account',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25, fontFamily: 'Brand-Bold'),
                ),
                Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      children: <Widget>[
                        // Full name
                        TextField(
                          controller: nameEditingController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              labelText: 'Full name',
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

                        // Email address
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

                        // Phone
                        TextField(
                          controller: phoneEditingController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                              labelText: 'Phone number',
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

                        // Password
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
                          title: 'REGISTER',
                          color: BrandColors.colorGreen,
                          onPressed: () {
                            if (nameEditingController.text.length < 1) {
                              displayToastMessage(
                                  "Name must be at least 1 character", context);
                            } else if (!emailEditingController.text.contains("@")) {
                              displayToastMessage(
                                  "Email address is not valid", context);
                            } else if (phoneEditingController.text.isEmpty) {
                              displayToastMessage(
                                  "Phone number is mandatory", context);
                            } else if (passwordEditingController.text.length < 8) {
                              displayToastMessage(
                                  "Password must be at least 8 character", context);
                            } else {
                              registerUser(context);
                            }
                          },
                        ),
                      ],
                    )),
                FlatButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, LoginPage.id, (route) => false);
                    },
                    child: Text('Already have account? Log in'))
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