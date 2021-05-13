import 'package:google_maps_flutter/google_maps_flutter.dart';

class TripDetail {
  String destinationAddress;
  String pickupAddress;
  LatLng pickup;
  LatLng destination;
  String riderID;
  String paymentMethod;
  String riderName;
  String riderPhone;

  TripDetail({
    this.destinationAddress,
    this.pickupAddress,
    this.destination,
    this.pickup,
    this.paymentMethod,
<<<<<<< Updated upstream
    this.riderName,
    this.rideID,
    this.riderPhone,
=======
    this.driverName,
    this.riderID,
    this.driverPhone,
>>>>>>> Stashed changes
  });
}
