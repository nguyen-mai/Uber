import "package:connectivity/connectivity.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_database/firebase_database.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:uber/brand_colors.dart";
import "package:uber/main.dart";
import "package:uber/screens/loginpage.dart";
import "package:uber/screens/mainpage.dart";
import "package:uber/widgets/ProgressDialog.dart";
import "package:uber/widgets/TaxiButton.dart";

class RegistrationPage extends StatelessWidget {
  static const String id = "register";
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController nameEditingController = TextEditingController();
  TextEditingController emailEditingController = TextEditingController();
  TextEditingController phoneEditingController = TextEditingController();
  TextEditingController passwordEditingController = TextEditingController();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void showSnackBar(String title){
    final snackbar = SnackBar(
      content: Text(title, textAlign: TextAlign.center, style: TextStyle(fontSize: 15.0),),
    );
    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  void registerUser(BuildContext context) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => ProgressDialog(status: 'Registering you...',),
    );

    final User firebaseUser = (await _firebaseAuth
            .createUserWithEmailAndPassword(
                email: emailEditingController.text,
                password: passwordEditingController.text)
            .catchError((errorMsg) {
              Navigator.pop(context);
              displayToastMessage("Error: " + errorMsg.toString(), context);
    }))
        .user;

    Navigator.pop(context);
    // Check if user registration successful
    if (firebaseUser != null) // user created
    {
      // save user info to db

      Map userDataMap = {
        "name": nameEditingController.text.trim(),
        "email": emailEditingController.text.trim(),
        "phone": phoneEditingController.text.trim(),
      };

      usersRef.child(firebaseUser.uid).set(userDataMap);
      showSnackBar("Congratulations, your account has been created");
      // displayToastMessage(
      //     "Congratulations, your account has been created", context);

      Navigator.pushNamedAndRemoveUntil(
          context, LoginPage.id, (route) => false);
    } else {
      // error occured - display error msg
      showSnackBar("User account has not been created");
      // displayToastMessage("User account has not been created", context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
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
                  image: AssetImage("images/icon.png"),
                ),
                SizedBox(
                  height: 40,
                ),
                Text(
                  "Create New Account",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25, fontFamily: "Brand-Bold"),
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
                              labelText: "Full name",
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
                              labelText: "Email address",
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
                              labelText: "Phone number",
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
                              labelText: "Password",
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
                          title: "REGISTER",
                          color: BrandColors.colorGreen,
                          onPressed: () {
                            if (nameEditingController.text.length < 3) {
                              showSnackBar("Please provide a valid fullname");
                              return;
                            } else if (!emailEditingController.text
                                .contains("@")) {
                              showSnackBar("Please provide a valid email address");
                              return;
                            } else if (phoneEditingController.text.length < 10 && phoneEditingController.text.length > 13) {
                              showSnackBar("Please provide a valid phone number");
                              return;
                            } else if (passwordEditingController.text.length < 8) {
                              showSnackBar("Please provide a valid password");
                              return;
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
                    child: Text("Already have account? Log in"))
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
