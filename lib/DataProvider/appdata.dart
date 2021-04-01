import 'package:flutter/cupertino.dart';
import 'package:uber/datamodels/andress.dart';

class Appdata extends ChangeNotifier{
   Andress pickupAndress;
   void updatePickupAndress(Andress pickup){
     pickupAndress= pickup;
     notifyListeners();
   }
}