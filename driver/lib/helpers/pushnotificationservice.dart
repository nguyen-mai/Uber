import 'dart:io';

// import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:driver/datamodels/tripDetail.dart';
import 'package:driver/globalvariables.dart';
import 'package:driver/widgets/NotificationDialog.dart';
import 'package:driver/widgets/ProgressDialog.dart';
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
        // assetsAudioPlayer.open(
        //   Audio('sounds/alert.mp3'),
        // );
        // assetsAudioPlayer.play();

        double pickupLat =
        double.parse(snapshot.value['location']['latitude'].toString());
        double pickupLng =
        double.parse(snapshot.value['location']['longitude'].toString());
        String pickupAddress = snapshot.value['pickup_address'].toString();

        double destinationLat =
        double.parse(snapshot.value['destination']['latitude'].toString());
        double destinationLng =
        double.parse(snapshot.value['destination']['longitude'].toString());
        String destinationAddress =
        snapshot.value['destination_address'].toString();
        String paymentMethod = snapshot.value['payment_method'];
        String riderName = snapshot.value['user_name'];
        String riderPhone = snapshot.value['user_phone'];


        TripDetail tripDetail= TripDetail();

        tripDetail.riderID = rideID;
        tripDetail.pickupAddress = pickupAddress;
        tripDetail.destinationAddress = destinationAddress;
        tripDetail.pickup = LatLng(pickupLat, pickupLng);
        tripDetail.destination = LatLng(destinationLat, destinationLng);
        tripDetail.paymentMethod = paymentMethod;
        tripDetail.riderName = riderName;
        tripDetail.riderPhone = riderPhone;

        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) => NotificationDialog(tripDetail: tripDetail,),
        );
      }
    });
  }

}
