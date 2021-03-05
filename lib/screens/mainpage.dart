import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Main Page"),
      ),
      body: Center(
        child: MaterialButton(
          height: 50,
          onPressed:() {
            DatabaseReference dbref= FirebaseDatabase.instance.reference().child("Test");
            dbref.set("Connected");
          },
          minWidth: 300,
          color: Colors.green,
          child: Text("Test connection"),
        ),
      ),
    );
  }
}
