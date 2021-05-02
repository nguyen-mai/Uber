import 'dart:io';
//import 'dart:js';

import 'package:driver/datamodels/tripDetail.dart';
import 'package:driver/globalvariables.dart';
import 'package:driver/widgets/ProgressDialog.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PushNotificationService {
  final FirebaseMessaging fcm = FirebaseMessaging();

  Future initialize(context) async {
    fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        fetchRideInfo(getRideID(message),context);
      },
      onLaunch: (Map<String, dynamic> message) async {
        fetchRideInfo(getRideID(message),context);
      },
      onResume: (Map<String, dynamic> message) async {
        fetchRideInfo(getRideID(message),context);
      },
    );
    // Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.
    /* await Firebase.initializeApp();

      RemoteMessage message;

      print("Handling a background message: ${message}");*/
    // }
    // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  Future<String> getToken() async {
    String token = await fcm.getToken();
    print('token: $token');

    DatabaseReference tokenRef = FirebaseDatabase.instance
        .reference()
        .child('drivers/${currentFirebaseUser.uid}');
    tokenRef.set(token);

    fcm.subscribeToTopic('alldrivers');
    fcm.subscribeToTopic('allusers');
  }

  String getRideID(Map<String, dynamic> message) {
    String rideID;
    if (Platform.isAndroid) {
      rideID = message['data']['ride_id'];
      print('rideID: $rideID');
    }
    return rideID;
  }

  void fetchRideInfo(String rideID,context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => ProgressDialog(status: 'Fetching detail',),
    );
    DatabaseReference rideRef =
    FirebaseDatabase.instance.reference().child("rideRequest/$rideID");
    rideRef.once().then((DataSnapshot snapshot){
      Navigator.pop(context);
      if (snapshot.value != null) {
        double pickupLat =
        double.parse(snapshot.value['location']['latitude'].toString());
        double pickupLng =
        double.parse(snapshot.value['location']['longitude'].toString());
        String pickupAddress = snapshot.value['pickup_andress'].toString();

        double destinationLat =
        double.parse(snapshot.value['destination']['latitude'].toString());
        double destinationLng =
        double.parse(snapshot.value['destination']['longitude'].toString());
        String destinationAddress =
        snapshot.value['destination_address'].toString();
        String paymentMethod = snapshot.value['payment_method'];

        TripDetail tripDetail= TripDetail();
        tripDetail.rideID=rideID;
        tripDetail.pickupAddress=pickupAddress;
        tripDetail.destinationAddress=destinationAddress;
        tripDetail.pickup=LatLng(pickupLat, pickupLng);
        tripDetail.destination=LatLng(destinationLat, destinationLng);
        tripDetail.paymentMethod=paymentMethod;
        print(pickupAddress);
      }
    });
  }

}
