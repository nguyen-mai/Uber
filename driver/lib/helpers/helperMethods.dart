<<<<<<< Updated upstream
import 'dart:math';

import 'package:driver/datamodels/directiondetails.dart';
import 'package:driver/datamodels/history.dart';
=======
import 'dart:html';
import 'dart:math';

import 'package:driver/datamodels/directiondetails.dart';
>>>>>>> Stashed changes
import 'package:driver/dataprovider.dart';
import 'package:driver/helpers/requestHelper.dart';
import 'package:driver/widgets/ProgressDialog.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../globalvariables.dart';

<<<<<<< Updated upstream

class HelperMethod {

  static Future<DirectionDetails> getDirectionDetails(LatLng startPosition, LatLng endPosition) async {

    String url = 'https://maps.googleapis.com/maps/api/directions/json?origin=${startPosition.latitude},${startPosition.longitude}&destination=${endPosition.latitude},${endPosition.longitude}&mode=driving&key=$mapKey';

    var response = await RequestHelper.getRequest(url);

    if(response == 'failed'){
=======
class HelperMethods {
  static Future<DirectionDetails> getDirectionDetails(
      LatLng startPosition, LatLng endPosition) async {
    String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${startPosition.latitude},${startPosition.longitude}&destination=${endPosition.latitude},${endPosition.longitude}&mode=driving&key=$mapKey';

    var response = await RequestHelper.getRequest(url);

    if (response == 'failed') {
>>>>>>> Stashed changes
      return null;
    }

    DirectionDetails directionDetails = DirectionDetails();

<<<<<<< Updated upstream
    directionDetails.durationText = response['routes'][0]['legs'][0]['duration']['text'];
    directionDetails.durationValue = response['routes'][0]['legs'][0]['duration']['value'];

    directionDetails.distanceText = response['routes'][0]['legs'][0]['distance']['text'];
    directionDetails.distanceValue = response['routes'][0]['legs'][0]['distance']['value'];

    directionDetails.encodedPoints = response['routes'][0]['overview_polyline']['points'];
=======
    directionDetails.durationText =
        response['routes'][0]['legs'][0]['duration']['text'];
    directionDetails.durationValue =
        response['routes'][0]['legs'][0]['duration']['value'];

    directionDetails.distanceText =
        response['routes'][0]['legs'][0]['distance']['text'];
    directionDetails.distanceValue =
        response['routes'][0]['legs'][0]['distance']['value'];

    directionDetails.encodedPoints =
        response['routes'][0]['overview_polyline']['points'];
>>>>>>> Stashed changes

    return directionDetails;
  }

<<<<<<< Updated upstream

  static double generateRandomNumber(int max){

=======
  static int estimateFares(DirectionDetails details, int durationValue) {
    // per km = $0.3,
    // per minute = $0.2,
    // base fare = $3,

    double baseFare = 3;
    double distanceFare = (details.distanceValue / 1000) * 0.3;
    double timeFare = (durationValue / 60) * 0.2;

    double totalFare = baseFare + distanceFare + timeFare;

    return totalFare.truncate();
  }

  static double generateRandomNumber(int max) {
>>>>>>> Stashed changes
    var randomGenerator = Random();
    int randInt = randomGenerator.nextInt(max);

    return randInt.toDouble();
  }

<<<<<<< Updated upstream
  static void disableHomTabLocationUpdates(){
=======
  static void disableHomTabLocationUpdates() {
>>>>>>> Stashed changes
    homeTabPositionStream.pause();
    Geofire.removeLocation(currentFirebaseUser.uid);
  }

<<<<<<< Updated upstream
  static void enableHomTabLocationUpdates(){
    homeTabPositionStream.resume();
    Geofire.setLocation(currentFirebaseUser.uid, currentPosition.latitude, currentPosition.longitude);
  }

  static void showProgressDialog(context){

=======
  static void enableHomTabLocationUpdates() {
    homeTabPositionStream.resume();
    Geofire.setLocation(currentFirebaseUser.uid, currentPosition.latitude,
        currentPosition.longitude);
  }

  static void showProgressDialog(context) {
>>>>>>> Stashed changes
    //show please wait dialog
    showDialog(
      barrierDismissible: false,
      context: context,
<<<<<<< Updated upstream
      builder: (BuildContext context) => ProgressDialog(status: 'Please wait',),
    );
  }

  static void getHistoryInfo (context){

    DatabaseReference earningRef = FirebaseDatabase.instance.reference().child('drivers/${currentFirebaseUser.uid}/earnings');

    earningRef.once().then((DataSnapshot snapshot){
      if(snapshot.value != null){
        String earnings = snapshot.value.toString();
        Provider.of<AppData>(context, listen: false).updateEarnings(earnings);
      }

    });

    DatabaseReference historyRef = FirebaseDatabase.instance.reference().child('drivers/${currentFirebaseUser.uid}/history');
    historyRef.once().then((DataSnapshot snapshot) {

      if(snapshot.value != null){

=======
      builder: (BuildContext context) => ProgressDialog(
        status: 'Please wait',
      ),
    );
  }

  static void getHistoryInfo(context) {
    DatabaseReference earningRef = FirebaseDatabase.instance
        .reference()
        .child('drivers/${currentFirebaseUser.uid}/earnings');

    earningRef.once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        String earnings = snapshot.value.toString();
        Provider.of<AppData>(context, listen: false).updateEarnings(earnings);
      }
    });

    DatabaseReference historyRef = FirebaseDatabase.instance
        .reference()
        .child('drivers/${currentFirebaseUser.uid}/history');
    historyRef.once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
>>>>>>> Stashed changes
        Map<dynamic, dynamic> values = snapshot.value;
        int tripCount = values.length;

        // update trip count to data provider
        Provider.of<AppData>(context, listen: false).updateTripCount(tripCount);

        List<String> tripHistoryKeys = [];
<<<<<<< Updated upstream
        values.forEach((key, value) {tripHistoryKeys.add(key);});

        // update trip keys to data provider
        Provider.of<AppData>(context, listen: false).updateTripKeys(tripHistoryKeys);

        getHistoryData(context);

      }
    });


  }

  static void getHistoryData(context){

    var keys = Provider.of<AppData>(context, listen: false).tripHistoryKeys;

    for(String key in keys){
      DatabaseReference historyRef = FirebaseDatabase.instance.reference().child('rideRequest/$key');

      historyRef.once().then((DataSnapshot snapshot) {
        if(snapshot.value != null){

          var history = History.fromSnapshot(snapshot);
          Provider.of<AppData>(context, listen: false).updateTripHistory(history);
=======
        values.forEach((key, value) {
          tripHistoryKeys.add(key);
        });

        // update trip keys to data provider
        Provider.of<AppData>(context, listen: false)
            .updateTripKeys(tripHistoryKeys);

        getHistoryData(context);
      }
    });
  }

  static void getHistoryData(context) {
    var keys = Provider.of<AppData>(context, listen: false).tripHistoryKeys;

    for (String key in keys) {
      DatabaseReference historyRef =
          FirebaseDatabase.instance.reference().child('rideRequest/$key');

      historyRef.once().then((DataSnapshot snapshot) {
        if (snapshot.value != null) {
          var history = History.fromSnapshot(snapshot);
          Provider.of<AppData>(context, listen: false)
              .updateTripHistory(history);
>>>>>>> Stashed changes

          print(history.destination);
        }
      });
    }
<<<<<<< Updated upstream

  }


  static String formatMyDate(String datestring){

    DateTime thisDate = DateTime.parse(datestring);
    String formattedDate = '${DateFormat.MMMd().format(thisDate)}, ${DateFormat.y().format(thisDate)} - ${DateFormat.jm().format(thisDate)}';

    return formattedDate;
  }
  static int estimateFares(DirectionDetails details, int durationValue) {
    //1km=6.900d
    //base fare=10.000d
    //time fare= 2.000d/min
    double basefare = 10000;
    double distanceFare = (details.distanceValue / 1000) * 6900;
    double timeFare = (details.durationValue / 60) * 2000;
    double totalFare = basefare + distanceFare + timeFare;
    return totalFare.truncate();
  }

=======
  }

  static String formatMyDate(String datestring) {
    DateTime thisDate = DateTime.parse(datestring);
    String formattedDate =
        '${DateFormat.MMMd().format(thisDate)}, ${DateFormat.y().format(thisDate)} - ${DateFormat.jm().format(thisDate)}';

    return formattedDate;
  }
>>>>>>> Stashed changes
}
