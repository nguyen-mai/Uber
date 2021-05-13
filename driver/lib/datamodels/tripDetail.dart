import 'package:google_maps_flutter/google_maps_flutter.dart';

class TripDetail {
  String destinationAddress;
  String pickupAddress;
  LatLng pickup;
  LatLng destination;
  String rideID;
  String paymentMethod;
  String riderName;
  String riderPhone;

  TripDetail({
    this.destinationAddress,
    this.pickupAddress,
    this.destination,
    this.pickup,
    this.paymentMethod,
    this.riderName,
    this.rideID,
    this.riderPhone,
  });
}
