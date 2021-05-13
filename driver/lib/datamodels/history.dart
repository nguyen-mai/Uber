import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class History {
  String paymentMethod;
  String createdAt;
  String status;
  String fares;
  String destination;
  String pickup;

  History({
    this.paymentMethod,
    this.createdAt,
    this.status,
    this.destination,
    this.fares,
    this.pickup,
  });
  History.fromSnapshot(DataSnapshot snapshot){
    paymentMethod=snapshot.value["payment_method"];
    createdAt=snapshot.value["created_at"];
    fares=snapshot.value["fares"];
    destination=snapshot.value["destination_address"];
    pickup=snapshot.value["pickup_andress"];
    paymentMethod=snapshot.value["payment_method"];

  }
}
