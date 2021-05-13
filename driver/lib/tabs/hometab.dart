import 'dart:async';

import 'package:driver/brand_colors.dart';
import 'package:driver/datamodels/driver.dart';
import 'package:driver/globalvariables.dart';
import 'package:driver/helpers/helperMethods.dart';
import 'package:driver/helpers/pushnotificationservice.dart';
import 'package:driver/widgets/AvailabilityButton.dart';
import 'package:driver/widgets/ConfirmSheet.dart';
import 'package:driver/widgets/NotificationDialog.dart';
import 'package:driver/widgets/TaxiButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  GoogleMapController mapController;
  Completer<GoogleMapController> _controller = Completer();
<<<<<<< Updated upstream

  DatabaseReference tripRequestRef;

  var geoLocator = Geolocator();
  var locationOptions = LocationOptions(accuracy: LocationAccuracy.bestForNavigation, distanceFilter: 4);
=======
  Position currentPosition;

  DatabaseReference tripRequestRef;

  var geolocator = Geolocator();
  var locationOptions = LocationOptions(
      accuracy: LocationAccuracy.bestForNavigation, distanceFilter: 4);
>>>>>>> Stashed changes

  String availabilityTitle = 'GO ONLINE';
  Color availabilityColor = BrandColors.colorOrange;

  bool isAvailable = false;


  void getCurrentPosition() async {
<<<<<<< Updated upstream

    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
=======
    Position position = await Geolocator().getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
>>>>>>> Stashed changes
    currentPosition = position;
    LatLng pos = LatLng(position.latitude, position.longitude);
    mapController.animateCamera(CameraUpdate.newLatLng(pos));

  }

<<<<<<< Updated upstream
  void getCurrentDriverInfo () async {

    currentFirebaseUser = await FirebaseAuth.instance.currentUser();
    DatabaseReference driverRef = FirebaseDatabase.instance.reference().child('drivers/${currentFirebaseUser.uid}');
    driverRef.once().then((DataSnapshot snapshot){

      if(snapshot.value != null){
        currentDriverInfo = Driver.fromSnapshot(snapshot);
        print(currentDriverInfo.fullName);
      }

    });

=======

  void getCurrentDriverInfo() async {
    currentFirebaseUser = await FirebaseAuth.instance.currentUser;
    DatabaseReference driverRef = FirebaseDatabase.instance
        .reference()
        .child("drivers/${currentFirebaseUser.uid}");
    driverRef.once().then((DataSnapshot snapshot) {
      if (snapshot != null) {
        currentDriverInfo = Driver.fromSnapShot(snapshot);
      }
    });
>>>>>>> Stashed changes
    PushNotificationService pushNotificationService = PushNotificationService();

    pushNotificationService.initialize(context);
    pushNotificationService.getToken();

    HelperMethod.getHistoryInfo(context);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentDriverInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        GoogleMap(
          padding: EdgeInsets.only(top: 135),
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          mapType: MapType.normal,
          initialCameraPosition: googleFlex,
          onMapCreated: (GoogleMapController controller){
            _controller.complete(controller);
            mapController = controller;

            getCurrentPosition();
          },
        ),
        Container(
          height: 135,
          width: double.infinity,
          color: BrandColors.colorPrimary,
        ),
        Positioned(
          top: 60,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              AvailabilityButton(
                title: availabilityTitle,
                color: availabilityColor,
<<<<<<< Updated upstream
                onPressed: (){


                  showModalBottomSheet(
                    isDismissible: false,
                    context: context,
                    builder: (BuildContext context) => ConfirmSheet(
                      title: (!isAvailable) ? 'GO ONLINE' : 'GO OFFLINE',
                      subtitle: (!isAvailable) ? 'You are about to become available to receive trip requests': 'you will stop receiving new trip requests',

                      onPressed: (){

                        if(!isAvailable){
                          GoOnline();
                          getLocationUpdates();
                          Navigator.pop(context);

                          setState(() {
                            availabilityColor = BrandColors.colorGreen;
                            availabilityTitle = 'GO OFFLINE';
                            isAvailable = true;
                          });

                        }
                        else{

                          GoOffline();
                          Navigator.pop(context);
                          setState(() {
                            availabilityColor = BrandColors.colorOrange;
                            availabilityTitle = 'GO ONLINE';
                            isAvailable = false;
                          });
                        }

                      },
                    ),
                  );

=======
                onPressed: () {


                  showModalBottomSheet(
                      isDismissible: false,
                      context: context,
                      builder: (BuildContext context) => ConfirmSheet(
                            title: (!isAvailable) ? 'GO ONLINE' : 'GO OFFLINE',
                            subtitle: (!isAvailable)
                                ? 'You are about to become available to receive trip requests'
                                : 'You will stop receiving new trip requests',
                            onPressed: () {
                              if (!isAvailable) {
                                GoOnLine();
                                getLocationUpdates();
                                Navigator.pop(context);

                                setState(() {
                                  availabilityColor = BrandColors.colorGreen;
                                  availabilityTitle = 'GO OFFLINE';
                                  isAvailable = true;
                                });
                              } else {
                                goOffline();
                                Navigator.pop(context);
                                setState(() {
                                  availabilityColor = BrandColors.colorOrange;
                                  availabilityTitle = 'GO ONLINE';
                                  isAvailable = false;
                                });
                              }
                            },
                          ));
>>>>>>> Stashed changes
                },
              ),
            ],
          ),
        )

      ],
    );
  }

  void GoOnline(){
    Geofire.initialize('driversAvailable');
<<<<<<< Updated upstream
    Geofire.setLocation(currentFirebaseUser.uid, currentPosition.latitude, currentPosition.longitude);

    tripRequestRef = FirebaseDatabase.instance.reference().child('drivers/${currentFirebaseUser.uid}/newtrip');
    tripRequestRef.set('waiting');

    tripRequestRef.onValue.listen((event) {

    });

=======

    // Setting location data
    Geofire.setLocation(currentFirebaseUser.uid, currentPosition.latitude,
        currentPosition.longitude);

    tripRequestRef = FirebaseDatabase.instance
        .reference()
        .child('drivers/${currentFirebaseUser.uid}/new_trip');
    tripRequestRef.set('waiting');

    tripRequestRef.onValue.listen((event) {});
>>>>>>> Stashed changes
  }

  void GoOffline (){

    Geofire.removeLocation(currentFirebaseUser.uid);
    tripRequestRef.onDisconnect();
    tripRequestRef.remove();
    tripRequestRef = null;

  }

<<<<<<< Updated upstream
  void getLocationUpdates(){

    homeTabPositionStream = geoLocator.getPositionStream(locationOptions).listen((Position position) {
      currentPosition = position;

      if(isAvailable){
        Geofire.setLocation(currentFirebaseUser.uid, position.latitude, position.longitude);
=======
  // Update driver location
  void getLocationUpdates() {
    homeTabPositionStream = geolocator
        .getPositionStream(locationOptions)
        .listen((Position position) {
      currentPosition = position;

      if (isAvailable) {
        Geofire.setLocation(
            currentFirebaseUser.uid, position.latitude, position.longitude);
>>>>>>> Stashed changes
      }

      LatLng pos = LatLng(position.latitude, position.longitude);
      mapController.animateCamera(CameraUpdate.newLatLng(pos));
    });

  }
}
