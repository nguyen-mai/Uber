import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uber/DataProvider/appdata.dart';
import 'package:uber/screens/loginpage.dart';
import 'package:uber/screens/mainpage.dart';
import 'package:uber/screens/registrationpage.dart';

import 'dart:io';


Future<void> main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // final FirebaseApp app = await Firebase.initializeApp(
  //   name: 'db2',
  //   options: Platform.isIOS || Platform.isMacOS
  //       ? FirebaseOptions(
  //           appId: '1:297855924061:ios:c6de2b69b03a5be8',
  //           apiKey: 'AIzaSyD_shO5mfO9lhy2TVWhfo1VUmARKlG4suk',
  //           projectId: 'flutter-firebase-plugins',
  //           messagingSenderId: '297855924061',
  //           databaseURL: 'https://flutterfire-cd2f7.firebaseio.com',
  //         )
  //       : FirebaseOptions(
  //           appId: '1:623152305583:android:53cfa7493f5d7b3a834b5a',
  //           apiKey: 'AIzaSyACJE9wrXRvUpCpt3tXi4cGmHRwXiDBe80',
  //           messagingSenderId: '623152305583',
  //           projectId: 'uber-dcc4c',
  //           databaseURL: 'https://uber-dcc4c-default-rtdb.firebaseio.com',
  //         ),
  // );
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

DatabaseReference usersRef =
FirebaseDatabase.instance.reference().child("users");

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create:(context)=> Appdata(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Uber',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          fontFamily: 'Brand-Regular',
          primarySwatch: Colors.blue,
        ),
        initialRoute: MainPage.id,
        routes: {
          RegistrationPage.id: (context) => RegistrationPage(),
          LoginPage.id: (context) => LoginPage(),
          MainPage.id: (context) => MainPage(),
        },
      ),
    );
  }
}