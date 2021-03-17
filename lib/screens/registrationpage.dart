//import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uber/brand_colors.dart';
import 'package:uber/screens/loginpage.dart';
import 'package:uber/screens/mainpage.dart';
import 'package:uber/widgets/ProgressDialog.dart';
import 'package:uber/widgets/TaxiButton.dart';

class RegistrationPage extends StatefulWidget {

  static const String id = 'register';

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  void showSnackBar(String title){
    final snackbar = SnackBar(
        content: Text(title, textAlign: TextAlign.center, style: TextStyle(fontSize: 15),),
    );
    scaffoldKey.currentState.showSnackBar(snackbar);

  final FirebaseAuth _auth = FirebaseAuth.instance;

  var fullNameController = TextEditingController();

  var phoneController = TextEditingController();

  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  void registerUser() async {
    // Show please wait dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => ProgressDialog(status: 'Registering you...',),
    );

    final FirebaseUser user = (await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
    ).catchError((ex){
      // Check error and display message
      Navigator.pop(context);
      PlatformException thisEx = ex;
      showSnackBar(thisEx.message);
    }));

    Navigator.pop(context);
    // Check if user registration successful
    if (user != null) {
      DatabaseReference newUserRef = FirebaseDatabase.instance.reference().child('users/${user.uid}');

      // Prepare data to be saved on users table
      Map userMap = {
        'fullname': fullNameController.text,
        'email': emailController.text,
        'phone': phoneController.text,
      };

      // newUserRef.set(userMap);

      // Take the user to mainpage
      Navigator.pushNamedAndRemoveUntil(context, MainPage.id, (route) => false);
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
                  height: 100.0,
                  width: 100.0,
                  image: AssetImage('images/logo.png'),
                ),
                SizedBox(
                  height: 40,
                ),
                Text(
                  'Create  Rider\'s Account',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25, fontFamily: 'Brand-Bold'),
                ),
                Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      children: <Widget>[
                        // Full name
                        TextField(
                          // controller: fullNameController,
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

                        SizedBox(height: 10, ),

                        // Email address
                        TextField(
                          // controller: emailController,
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
                          // controller: phoneController,
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
                          // controller: passwordController,
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
                          onPressed: () async{
                            // Check network awavillability
                            var connectivityResult = await Connectivity().checkConnectivity();
                            if(connectivityResult != ConnectivityResult.mobile && connectivityResult != ConnectivityResult.wifi){
                              showSnackBar('No internet connectivity');
                              return;
                            }

                            if (fullNameController.text.length < 3) {
                              showSnackBar('Please provide a valid fullname');
                              return ;
                            }
                            if (phoneController.text.length < 10) {
                              showSnackBar('Please provide a valid phone number');
                              return;
                            }
                            if (!emailController.text.contains('@')) {
                              showSnackBar('Please provide a valid email address');
                              return;
                            }
                            if (passwordController.text.length < 8) {
                              showSnackBar('Please must be at least 8 characters');
                              return;
                            }

                            registerUser();

                          },
                        ),
                      ],
                    )
                ),
                FlatButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(context, LoginPage.id, (route) => false);
                    },
                    child: Text('Already have a RIDER account? Log in'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}