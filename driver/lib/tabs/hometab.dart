import 'dart:async';

import 'package:driver/brand_colors.dart';
import 'package:driver/globalvariables.dart';
import 'package:driver/helpers/pushnotificationservice.dart';
import 'package:driver/widgets/AvailabilityButton.dart';
import 'package:driver/widgets/ConfirmSheet.dart';
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
  Position currentPosition;
  
  DatabaseReference tripRequestRef;

  var geolocator = Geolocator();
  var locationOptions = LocationOptions(accuracy: LocationAccuracy.bestForNavigation, distanceFilter: 4);

  String availabilityTitle ='GO ONLINE';
  Color availabilityColor = BrandColors.colorOrange;

  bool isAvailable = false;

  // Lấy Vị trí hiện tại
  void getCurrentPosition() async {
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
    currentPosition = position;
    LatLng pos = LatLng(position.latitude, position.longitude);
    mapController.animateCamera(CameraUpdate.newLatLng(pos));
  }

  void getCurrentDriverInfo() async {
    currentFirebaseUser = await FirebaseAuth.instance.currentUser;
    PushNotificationService pushNotificationService = PushNotificationService();

    pushNotificationService.initialize();
    pushNotificationService.getToken();

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
          onMapCreated: (GoogleMapController controller) {
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
            children: [
              AvailabilityButton(
                title: availabilityTitle,
                color:  availabilityColor,
                onPressed: () {

                  
                  showModalBottomSheet(
                    isDismissible: false,
                    context: context,
                    builder: (BuildContext context) => ConfirmSheet(
                      title: (!isAvailable) ? 'GO ONLINE' : 'GO OFFLINE',
                      subtitle: (!isAvailable) ? 'You are about to become available to receive trip requests' : 'You will stop receiving new trip requests',
                      onPressed: () {
                        if(!isAvailable) {
                          GoOnLine();
                          getLocationUpdates();
                          Navigator.pop(context);

                          setState(() {
                            availabilityColor = BrandColors.colorGreen;
                            availabilityTitle = 'GO OFFLINE';
                            isAvailable = true;
                          });
                        }
                        else {
                          goOffline();
                          Navigator.pop(context);
                          setState(() {
                            availabilityColor = BrandColors.colorOrange;
                            availabilityTitle = 'GO ONLINE';
                            isAvailable = false;
                          });
                        }
                      },
                    )
                  );
                },
              ),
            ],
          ),
        )
      ],
    );
  }

  // Make driver available online using GeoFire
  void GoOnLine() {
    Geofire.initialize('driversAvailable');

    // Setting location data
    Geofire.setLocation(currentFirebaseUser.uid, currentPosition.latitude, currentPosition.longitude);

    tripRequestRef = FirebaseDatabase.instance.reference().child('drivers/${currentFirebaseUser.uid}/new_trip');
    tripRequestRef.set('waiting');
    
    tripRequestRef.onValue.listen((event) {
    });
  }

  void goOffline() {
    Geofire.removeLocation((currentFirebaseUser.uid));
    tripRequestRef.onDisconnect();
    tripRequestRef.remove();
    tripRequestRef = null;
  }

  // Update driver location
  void getLocationUpdates() {

    homeTabPositionStream = geolocator.getPositionStream(locationOptions).listen((Position position) {
      currentPosition = position;

      if(isAvailable) {
        Geofire.setLocation(currentFirebaseUser.uid, position.latitude, position.longitude);
      }

      LatLng pos = LatLng(position.latitude, position.longitude);
      mapController.animateCamera(CameraUpdate.newLatLng(pos));

    });
  }
}
