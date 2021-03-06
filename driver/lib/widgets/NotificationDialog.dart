<<<<<<< Updated upstream
import 'package:driver/brand_colors.dart';
import 'package:driver/datamodels/tripDetail.dart';
import 'package:driver/globalvariables.dart';
import 'package:driver/helpers/helperMethods.dart';
import 'package:driver/screens/newtrippage.dart';
import 'package:driver/widgets/BrandDivier.dart';
import 'package:driver/widgets/ProgressDialog.dart';
import 'package:driver/widgets/TaxiButton.dart';
import 'package:driver/widgets/TaxiOutlineButton.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:toast/toast.dart';

class NotificationDialog extends StatelessWidget {

  final TripDetail tripDetails;

  NotificationDialog({this.tripDetails});
=======
import 'package:driver/datamodels/tripDetail.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:toast/toast.dart';
import '../brand_colors.dart';
import '../globalvariables.dart';
import 'BrandDivier.dart';
import 'ProgressDialog.dart';
import 'TaxiOutlineButton.dart';
class NotificationDialog extends StatelessWidget {

  final TripDetail tripDetail;

  NotificationDialog({this.tripDetail});
>>>>>>> Stashed changes

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
<<<<<<< Updated upstream
        borderRadius: BorderRadius.circular(10.0),
=======
        borderRadius: BorderRadius.circular(10),
>>>>>>> Stashed changes
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.all(4),
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4)
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
<<<<<<< Updated upstream

            SizedBox(height: 30.0,),

            Image.asset('images/taxi.png', width: 100,),

            SizedBox(height: 16.0,),

            Text('NEW TRIP REQUEST', style: TextStyle(fontFamily: 'Brand-Bold', fontSize: 18),),
=======
            SizedBox(height: 30.0,),

            Image.asset("images/taxi.png", width: 100,),

            SizedBox(height: 16.0,),

            Text("NEW TRIP REQUEST",
              style: TextStyle(fontFamily: "Brand-Bold", fontSize: 18),),
>>>>>>> Stashed changes

            SizedBox(height: 30.0,),

            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
<<<<<<< Updated upstream

                children: <Widget>[

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Image.asset('images/pickicon.png', height: 16, width: 16,),
                      SizedBox(width: 18,),

                      Expanded(child: Container(child: Text(tripDetails.pickupAddress, style: TextStyle(fontSize: 18),)))


=======
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Image.asset(
                        "images/pickicon.png", height: 16, width: 16,),
                      SizedBox(width: 18,),

                      Text(
                        "diem di",
                        //tripDetail.pickupAddress,
                        style: TextStyle(fontSize: 18),),
                      // Text("Helo", style: TextStyle(fontSize: 18),),
>>>>>>> Stashed changes
                    ],
                  ),

                  SizedBox(height: 15,),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
<<<<<<< Updated upstream
                      Image.asset('images/desticon.png', height: 16, width: 16,),
                      SizedBox(width: 18,),

                      Expanded(child: Container(child: Text(tripDetails.destinationAddress, style: TextStyle(fontSize: 18),)))


                    ],
                  ),

=======
                      Image.asset(
                        "images/desticon.png", height: 16, width: 16,),
                      SizedBox(width: 18,),

                      Text(
                        "diem den",
                        //tripDetail.destinationAddress,
                        style: TextStyle(fontSize: 18),),
                      // Text("Hi", style: TextStyle(fontSize: 18),),
                    ],
                  ),
>>>>>>> Stashed changes
                ],
              ),
            ),

            SizedBox(height: 20,),

            BrandDivider(),

            SizedBox(height: 8,),

            Padding(
              padding: EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
<<<<<<< Updated upstream

                  Expanded(
                    child: Container(
                      child: TaxiOutlineButton(
                        title: 'DECLINE',
                        color: BrandColors.colorPrimary,
                        onPressed: () async {
                          //assetsAudioPlayer.stop();
=======
                  Expanded(
                    child: Container(
                      child: TaxiOutlineButton(
                        title: "DECLINE",
                        color: BrandColors.colorPrimary,
                        onPressed: () async {
                          // assetsAudioPlayer.stop();
>>>>>>> Stashed changes
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),

                  SizedBox(width: 10,),

                  Expanded(
                    child: Container(
<<<<<<< Updated upstream
                      child: TaxiButton(
                        title: 'ACCEPT',
                        color: BrandColors.colorGreen,
                        onPressed: () async {
                          //assetsAudioPlayer.stop();
                          checkAvailablity(context);
=======
                      child: TaxiOutlineButton(
                        title: "ACCEPT",
                        color: BrandColors.colorGreen,
                        onPressed: () async {
                           //assetsAudioPlayer.stop();
                           checkAvailability(context);
>>>>>>> Stashed changes
                        },
                      ),
                    ),
                  ),
<<<<<<< Updated upstream

=======
>>>>>>> Stashed changes
                ],
              ),
            ),

            SizedBox(height: 10.0,),

          ],
        ),
      ),
    );
  }
  void checkAvailability(context) {
    DatabaseReference newRideRef = FirebaseDatabase.instance.reference().child("drivers/${currentFirebaseUser.uid}/newtrip");
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => ProgressDialog(status: "Accepting request",),
    );

<<<<<<< Updated upstream
  void checkAvailablity(context){

    //show please wait dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => ProgressDialog(status: 'Accepting request',),
    );

    DatabaseReference newRideRef = FirebaseDatabase.instance.reference().child('drivers/${currentFirebaseUser.uid}/newtrip');
    newRideRef.once().then((DataSnapshot snapshot) {

      Navigator.pop(context);
      Navigator.pop(context);

      String thisRideID = "";
      if(snapshot.value != null){
        thisRideID = snapshot.value.toString();
      }
      else{
        Toast.show("Ride not found", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
      }

      if(thisRideID == tripDetails.rideID){
        newRideRef.set('accepted');
        HelperMethod.disableHomTabLocationUpdates();
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewTripPage(tripDetails: tripDetails,),
            ));
      }
      else if(thisRideID == 'cancelled'){
        Toast.show("Ride has been cancelled", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
      }
      else if(thisRideID == 'timeout'){
        Toast.show("Ride has timed out", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
      }
      else{
        Toast.show("Ride not found", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
      }

    });
  }

=======
    newRideRef.once().then((DataSnapshot snapshot) {
      Navigator.pop(context);
      /*Navigator.pop(context);*/

      String thisRideID = "";
      if(snapshot.value != null) {
        thisRideID = snapshot.value.toString();
      }
      else {
        print("error");
        /*Toast.show("Ride has been cancelled", context, duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);*/
      }
      if(thisRideID == tripDetail.riderID) {
        newRideRef.set("accepted");
        /*HelperMethod.disableHomeTabLocationUpdates();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NewTripPage(tripDetail: tripDetail,)),
        );*/
      }
      else if(thisRideID == "cancelled") {
        Toast.show("Ride has been cancelled", context, duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      }
      else if(thisRideID == "timeout") {
        Toast.show("Ride has been cancelled", context, duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      }
      else {
        Toast.show("Ride has been cancelled", context, duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      }
    });
  }
>>>>>>> Stashed changes
}