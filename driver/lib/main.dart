import 'package:driver/dataprovider.dart';
import 'package:driver/globalvariables.dart';
import 'package:driver/screens/vehicleinfo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:driver/screens/loginpage.dart';
import 'package:driver/screens/mainpage.dart';
import 'package:driver/screens/registrationpage.dart';

import 'dart:io';
import 'package:driver/screens/registrationpage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseApp app = await FirebaseApp.configure(
    name: 'db2',
    options: Platform.isIOS
        ? const FirebaseOptions(
      googleAppID: '1:169450788828:ios:565f2d4b4623a7dbf9a119',
      gcmSenderID: '169450788828',
      databaseURL: 'https://geetaxi-9c60a.firebaseio.com',
    )
        : const FirebaseOptions(
      googleAppID: '1:169450788828:android:5ecb13adb959cb18f9a119',
      apiKey: 'AIzaSyDQSm22dfjceA0OiQ9XL-0tQ0d7_XZTXpQ',
      databaseURL: 'https://geetaxi-9c60a.firebaseio.com',
    ),
  );

  currentFirebaseUser = await FirebaseAuth.instance.currentUser();

  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(
      create: (context) => AppData(),
      child: MaterialApp(
        theme: ThemeData(

          fontFamily: 'Brand-Regular',
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),

        //initialRoute: (currentFirebaseUser == null) ? LoginPage.id : MainPage.id,
        initialRoute:LoginPage.id,
        routes: {
          MainPage.id: (context) => MainPage(),
          RegistrationPage.id: (context) => RegistrationPage(),
          VehicleInfoPage.id: (context) => VehicleInfoPage(),
          LoginPage.id: (context) => LoginPage(),
        },
      ),
    );
  }
}

