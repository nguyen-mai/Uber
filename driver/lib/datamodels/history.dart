import 'package:google_maps_flutter/google_maps_flutter.dart';

class History {
  String destinationAddress;
  String pickupAddress;
  LatLng pickup;
  LatLng destination;
  String riderID;
  String paymentMethod;
  String riderName;
  String riderPhone;

  History({
    this.destinationAddress,
    this.pickupAddress,
    this.destination,
    this.pickup,
    this.paymentMethod,
    this.riderName,
    this.riderID,
    this.riderPhone,
  });
}
