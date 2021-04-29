import 'package:flutter/cupertino.dart';
import 'package:uber/datamodels/address.dart';

class Appdata extends ChangeNotifier{
   Address pickupAddress;
   Address destinationAddress;

   void updatePickupAddress(Address pickup){
     pickupAddress= pickup;
     notifyListeners();
   }

   void updateDestinationAddress (Address destination) {
     destinationAddress = destination;
     notifyListeners();
   }
}