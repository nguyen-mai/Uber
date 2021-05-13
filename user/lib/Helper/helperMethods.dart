import 'dart:convert';
import 'dart:math';

import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber/DataProvider/appdata.dart';
import 'package:uber/Helper/RequestHelper.dart';
import 'package:uber/datamodels/address.dart';
import 'package:uber/datamodels/directiondetails.dart';
import 'package:uber/datamodels/user.dart';
import 'package:uber/globevariable.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class HelperMethod {
  static void getCurrentUserInfo() async {
    currentFirebaseUser = await FirebaseAuth.instance.currentUser;
    String userId = currentFirebaseUser.uid;

    DatabaseReference usersRef =
    FirebaseDatabase.instance.reference().child('users').child(userId);
    usersRef.once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        //print(snapshot.value);
        currentUserInfo = UserInformation.fromSnapshot(snapshot);
        //print('My name is ${currentUserInfo.fullName}');
        userName = currentUserInfo.fullName;
        //print(userName);
        //print(userId);

      }
    });
  }

  static Future<String> findCordinateAndress(Position position, context) async {
    String placeAddress = '';
    var connectivityReslut = await Connectivity().checkConnectivity();
    if (connectivityReslut != ConnectivityResult.mobile &&
        connectivityReslut != ConnectivityResult.wifi) {
      return placeAddress;
    }
    var url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=${mapKey}');
    var response = await RequestHelper.getRequest(url);
    if (response != "failed") {
      placeAddress = response['results'][0]['formatted_address'];
      Address pickupAddress = new Address();
      pickupAddress.longitude = position.longitude;
      pickupAddress.latitude = position.latitude;
      pickupAddress.placeName = placeAddress;

      Provider.of<AppData>(context, listen: false)
          .updatePickupAddress(pickupAddress);
    }
    /* if(response=="failed"){
      return "Unknown";
    }*/
    return placeAddress;
  }

  static Future<DirectionDetails> getDirectionDetails(
      LatLng startPosition, LatLng endPosition) async {
    var url = Uri.parse(
        'https://maps.googleapis.com/maps/api/directions/json?origin=${startPosition.latitude},${startPosition.longitude}&destination=${endPosition.latitude},${endPosition.longitude}&mode=driving&key=$mapKey');

    var response = await RequestHelper.getRequest(url);

    if (response == 'failed') {
      return null;
    }

    DirectionDetails directionDetails = DirectionDetails();

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

    return directionDetails;
  }

  static int estimateFares(DirectionDetails details) {
    //1km=6.900d
    //base fare=10.000d
    //time fare= 2.000d/min
    double basefare = 10000;
    double distanceFare = (details.distanceValue / 1000) * 6900;
    double timeFare = (details.durationValue / 60) * 2000;
    double totalFare = basefare + distanceFare + timeFare;
    return totalFare.truncate();
  }

  static double generateRandomNumber(int max) {
    var randomGenerator = Random();
    int randInt = randomGenerator.nextInt(max);

    return randInt.toDouble();
  }

  static sendNotification(String token, context, String userID) async {
    var destination = Provider.of<AppData>(context, listen: false).destinationAddress;


    Map<String, String> headerMap = {
      'Content-Type': 'application/json',
      'Authorization': serverKey,
    };

    Map notificationMap = {
      'title': 'NEW TRIP REQUEST',
      'body': 'Destination, ${destination.placeName}',
    };

    Map dataMap = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'id': '1',
      'status': 'done',
      'user_id': userID,
    };

    Map bodyMap = {
      'notification': notificationMap,
      'data': dataMap,
      'priority': 'high',
      'to': token,
    };

    var response = await http.post(
        'https://fcm.googleapis.com/fcm/send',
        headers: headerMap,
        body: jsonEncode(bodyMap)
    );

    print(response.body);
  }
}
