import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:provider/provider.dart';
import 'package:uber/DataProvider/appdata.dart';
import 'package:uber/Helper/firehelper.dart';
import 'package:uber/Helper/helperMethods.dart';
import 'package:uber/Style/style.dart';
import 'package:uber/brand_colors.dart';
import 'package:uber/datamodels/directiondetails.dart';
import 'package:uber/datamodels/nearbydriver.dart';
import 'package:uber/globevariable.dart';
import 'package:uber/screens/searchpage.dart';
import 'package:uber/widgets/BrandDivier.dart';
import 'package:uber/widgets/CollectPaymentDialog.dart';
import 'package:uber/widgets/ProgressDialog.dart';
import 'package:uber/widgets/TaxiButton.dart';
import 'package:intl/intl.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import '../rideVariables.dart';
import '../widgets/NoDriverDialog.dart';

class MainPage extends StatefulWidget {
  static const String id = 'mainpage';

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  double rideDetailsSheetHeight = 0;
  GoogleMapController mapController;
  double searchSheetHeight = 300;
  double mapBottomPadding = 0;
  double requestingSheetHeight = 0;
  double tripSheetHeight = 0;
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  Completer<GoogleMapController> _controller = Completer();

  List<LatLng> polyLineCoordinates = [];
  Set<Polyline> _polylines = {};
  Set<Marker> _Markers = {};
  Set<Circle> _Circles = {};
  Position currentPosition;

  BitmapDescriptor nearByIcon;

  var geoLocator = Geolocator();

  bool drawerCarOpen = true;
  final fommatter = new NumberFormat.currency(locale: 'vi_VN', symbol: 'VND');

  DirectionDetails tripDirectionDetails;

  String appState = "NORMAL";

  DatabaseReference rideRef;

  StreamSubscription<Event> rideSubcription;

  List<NearByDriver> availableDrivers;

  bool nearByDriversKeysLoaded = false;

  void showRequestingSheet() {
    setState(() {
      rideDetailsSheetHeight = 0;
      requestingSheetHeight = 250;
      drawerCarOpen = true;
    });
    createRideRequest();
  }

  showTripSheet() {
    setState(() {
      requestingSheetHeight = 0;
      tripSheetHeight = 275;
      mapBottomPadding = 280;

    });
  }

  void setupPositionLocator() async {
    Position position = await geoLocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    currentPosition = position;

    LatLng pos = LatLng(position.latitude, position.longitude);
    CameraPosition cp = new CameraPosition(target: pos, zoom: 14);
    mapController.animateCamera(CameraUpdate.newCameraPosition(cp));

    startGeofireListener();
    //call address func
    String address = await HelperMethod.findCordinateAndress(position, context);
    // print(address);
  }

  void showDetailSheet() async {
    await getDirection();
    setState(() {
      searchSheetHeight = 0;
      rideDetailsSheetHeight = 250;
      mapBottomPadding = 10;
      drawerCarOpen = false;
    });
  }

  void createMarker() {
    if (nearByIcon == null) {
      ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context, size: Size(2, 2));
      BitmapDescriptor.fromAssetImage(
              imageConfiguration, 'images/car_android.png')
          .then((icon) {
        nearByIcon = icon;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    HelperMethod.getCurrentUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    createMarker();

    return Scaffold(
        key: scaffoldKey,
        drawer: Container(
          width: 250,
          color: Colors.white,
          child: Drawer(
            child: ListView(
              padding: EdgeInsets.all(0),
              children: <Widget>[
                Container(
                  color: Colors.white,
                  height: 160,
                  child: DrawerHeader(
                    decoration: BoxDecoration(color: Colors.white),
                    child: Row(
                      children: <Widget>[
                        Image.asset(
                          'images/user_icon.png',
                          height: 60,
                          width: 60,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              '$userName',
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                  fontSize: 20, fontFamily: "Brand-Bold"),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text("View profile"),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                BrandDivider(),
                SizedBox(
                  height: 10,
                ),
                ListTile(
                  leading: Icon(OMIcons.cardGiftcard),
                  title: Text(
                    "Free Ride",
                    style: kDrawerItemStyle,
                  ),
                ),
                ListTile(
                  leading: Icon(OMIcons.creditCard),
                  title: Text(
                    "Payment",
                    style: kDrawerItemStyle,
                  ),
                ),
                ListTile(
                  leading: Icon(OMIcons.history),
                  title: Text(
                    "History",
                    style: kDrawerItemStyle,
                  ),
                ),
                ListTile(
                  leading: Icon(OMIcons.contactSupport),
                  title: Text(
                    "Support",
                    style: kDrawerItemStyle,
                  ),
                ),
                ListTile(
                  leading: Icon(OMIcons.info),
                  title: Text(
                    "Info",
                    style: kDrawerItemStyle,
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Stack(
          children: <Widget>[
            GoogleMap(
              myLocationEnabled: true,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: true,
              padding: EdgeInsets.only(bottom: mapBottomPadding, top: 150),
              mapType: MapType.normal,
              myLocationButtonEnabled: true,
              polylines: _polylines,
              markers: _Markers,
              circles: _Circles,
              initialCameraPosition: googleFlex,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
                mapController = controller;

                setState(() {
                  mapBottomPadding = 300;
                });
                setupPositionLocator();
              },
            ),

            // MenuButton
            Positioned(
              top: 44,
              left: 20,
              child: GestureDetector(
                onTap: () {
                  if (drawerCarOpen) {
                    scaffoldKey.currentState.openDrawer();
                  } else {
                    resetApp();
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black26,
                            blurRadius: 5.0,
                            spreadRadius: 0.5,
                            offset: Offset(
                              0.7,
                              0.7,
                            ))
                      ]),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 20,
                    child: Icon(
                      drawerCarOpen ? Icons.menu : Icons.arrow_back,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),

            // SearchSheet
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: AnimatedSize(
                vsync: this,
                duration: new Duration(milliseconds: 150),
                curve: Curves.easeIn,
                child: Container(
                  height: searchSheetHeight,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black26,
                            blurRadius: 15,
                            spreadRadius: 0.5,
                            offset: Offset(
                              0.7,
                              0.7,
                            )),
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Nice to see you",
                          style: TextStyle(fontSize: 13),
                        ),
                        Text(
                          "Where are you going",
                          style:
                              TextStyle(fontSize: 20, fontFamily: "Brand-Bold"),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () async {
                            var response = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SearchPage()));

                            if (response == 'getDirection') {
                              showDetailSheet();
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 5.0,
                                      spreadRadius: 0.5,
                                      offset: Offset(
                                        0.7,
                                        0.7,
                                      )),
                                ]),
                            child: Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.search,
                                    color: Colors.blueAccent,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Search Destination",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 22,
                        ),
                        Row(
                          children: <Widget>[
                            Icon(
                              OMIcons.home,
                              color: BrandColors.colorDimText,
                              size: 25,
                            ),
                            SizedBox(
                              height: 12,
                              width: 14,
                            ),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                      (Provider.of<AppData>(context)
                                                  .pickupAddress !=
                                              null)
                                          ? Provider.of<AppData>(context)
                                              .pickupAddress
                                              .placeName
                                          : "And home",
                                      style: TextStyle(fontSize: 16),
                                      overflow: TextOverflow.ellipsis),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Text("Your home address",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: BrandColors.colorDimText,
                                      )),
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        BrandDivider(),
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          children: <Widget>[
                            Icon(
                              OMIcons.workOutline,
                              color: BrandColors.colorDimText,
                              size: 25,
                            ),
                            SizedBox(
                              height: 12,
                              width: 14,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Work",
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Text("Your Work Address",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: BrandColors.colorDimText,
                                    )),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // RideDetails Sheet
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: AnimatedSize(
                vsync: this,
                duration: new Duration(milliseconds: 150),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black26,
                          blurRadius: 15.0, // soften the shadow
                          spreadRadius: 0.5, // extend the shadow
                          offset: Offset(
                            0.7, //move to right 10 horizontally
                            0.7, // move to bottom 10 vertically
                          ))
                    ],
                  ),
                  height: tripSheetHeight,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 18),
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: double.infinity,
                          color: BrandColors.colorAccent1,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: <Widget>[
                                Image.asset(
                                  'images/taxi.png',
                                  height: 70,
                                  width: 70,
                                ),
                                SizedBox(
                                  width: 16,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Taxi',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontFamily: 'Brand-Bold'),
                                    ),
                                    Text(
                                      (tripDirectionDetails != null)
                                          ? tripDirectionDetails.distanceText
                                          : '',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: BrandColors.colorTextLight),
                                    )
                                  ],
                                ),
                                Expanded(child: Container()),
                                Text(
                                  (tripDirectionDetails != null)
                                      ? fommatter.format(
                                          HelperMethod.estimateFares(
                                              tripDirectionDetails))
                                      : '',
                                  style: TextStyle(
                                      fontSize: 18, fontFamily: 'Brand-Bold'),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 22,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                FontAwesomeIcons.moneyBillAlt,
                                size: 18,
                                color: BrandColors.colorTextLight,
                              ),
                              SizedBox(width: 16),
                              Text('Cash'),
                              SizedBox(
                                width: 5,
                              ),
                              Icon(
                                Icons.keyboard_arrow_down,
                                color: BrandColors.colorTextLight,
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 22,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: TaxiButton(
                            title: 'REQUEST CAR',
                            color: BrandColors.colorGreen,
                            onPressed: () {
                              setState(() {
                                appState = "REQUESTING";
                              });
                              showRequestingSheet();

                              availableDrivers = FireHelper.nearByDriverList;

                              findDriver();
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Request Sheet
            Positioned(
              left: 0,
              bottom: 0,
              right: 0,
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black26,
                            blurRadius: 5.0,
                            spreadRadius: 0.5,
                            offset: Offset(
                              0.7,
                              0.7,
                            ))
                      ]),
                  height: requestingSheetHeight,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      SpinKitRipple(
                        color: Colors.greenAccent,
                        size: 90,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Requesting your trip....',
                        style: TextStyle(fontSize: 25),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          cancelRequest();
                          resetApp();
                        },
                        child: Container(
                          height: 52,
                          width: 52,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(26),
                            border:
                                Border.all(width: 1.5, color: Colors.black38),
                          ),
                          child: Icon(
                            Icons.close,
                            size: 30,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        width: double.infinity,
                        child: Text(
                          "Cancel Trip",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14),
                        ),
                      )
                    ],
                  )),
            ),

            // Trip Sheet
            Positioned(
              left: 0,
              bottom: 0,
              right: 0,
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black26,
                            blurRadius: 5.0,
                            spreadRadius: 0.5,
                            offset: Offset(
                              0.7,
                              0.7,
                            ))
                      ]),
                  height: 300,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 5,),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(tripStatusDisplay,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: "Brand-Bold",
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 20,),

                      BrandDivider(),

                      SizedBox(height: 20,),

                      Text(driverCarDetails, style: TextStyle(color: BrandColors.colorTextLight),),

                      Text(driverFullName, style: TextStyle(fontSize: 20),),

                      SizedBox(height: 20,),

                      BrandDivider(),

                      SizedBox(height: 20,),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(25)),
                                  border: Border.all(width: 1.0, color: BrandColors.colorTextLight),
                                ),
                                child: Icon(Icons.call),
                              ),

                              SizedBox(height: 10,),

                              Text("Call"),
                            ],
                          ),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(25)),
                                  border: Border.all(width: 1.0, color: BrandColors.colorTextLight),
                                ),
                                child: Icon(Icons.list),
                              ),

                              SizedBox(height: 10,),

                              Text("Details"),
                            ],
                          ),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(25)),
                                  border: Border.all(width: 1.0, color: BrandColors.colorTextLight),
                                ),
                                child: Icon(OMIcons.clear),
                              ),

                              SizedBox(height: 10,),

                              Text("Cancel"),
                            ],
                          ),
                        ],
                      )
                    ],
                  )),
            ),

          ],
        ));
  }

  Future<void> getDirection() async {
    var pickup = Provider.of<AppData>(context, listen: false).pickupAddress;
    var destination =
        Provider.of<AppData>(context, listen: false).destinationAddress;

    var pickLatLng = LatLng(pickup.latitude, pickup.longitude);
    var destinationLatLng = LatLng(destination.latitude, destination.longitude);

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => ProgressDialog(
              status: "Please wait...",
            ));

    var thisDetails =
        await HelperMethod.getDirectionDetails(pickLatLng, destinationLatLng);
    setState(() {
      tripDirectionDetails = thisDetails;
    });

    Navigator.pop(context);

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> results =
        polylinePoints.decodePolyline(thisDetails.encodedPoints);

    polyLineCoordinates.clear();

    if (results.isNotEmpty) {
      results.forEach((PointLatLng points) {
        polyLineCoordinates.add(LatLng(points.latitude, points.longitude));
      });
    }

    _polylines.clear();

    setState(() {
      Polyline polyLine = Polyline(
        polylineId: PolylineId('polyid'),
        color: Color.fromARGB(255, 95, 109, 237),
        points: polyLineCoordinates,
        jointType: JointType.round,
        width: 4,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );

      _polylines.add(polyLine);
    });

    LatLngBounds bounds;

    if (pickLatLng.latitude > destinationLatLng.latitude &&
        pickLatLng.longitude > destinationLatLng.longitude) {
      bounds =
          LatLngBounds(southwest: destinationLatLng, northeast: pickLatLng);
    } else if (pickLatLng.longitude > destinationLatLng.longitude) {
      bounds = LatLngBounds(
          southwest: LatLng(pickLatLng.latitude, destinationLatLng.longitude),
          northeast: LatLng(destinationLatLng.latitude, pickLatLng.longitude));
    } else if (pickLatLng.latitude > destinationLatLng.latitude) {
      bounds = LatLngBounds(
          southwest: LatLng(destinationLatLng.latitude, pickLatLng.longitude),
          northeast: LatLng(pickLatLng.latitude, destinationLatLng.longitude));
    } else {
      bounds =
          LatLngBounds(southwest: pickLatLng, northeast: destinationLatLng);
    }

    mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 70));

    Marker pickupMarker = Marker(
      markerId: MarkerId('pickup'),
      position: pickLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      infoWindow: InfoWindow(title: pickup.placeName, snippet: 'My Location'),
    );

    Marker destinationMarker = Marker(
      markerId: MarkerId('destination'),
      position: destinationLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      infoWindow:
          InfoWindow(title: destination.placeName, snippet: 'Destination'),
    );

    setState(() {
      _Markers.add(pickupMarker);
      _Markers.add(destinationMarker);
    });

    Circle pickupCircle = Circle(
      circleId: CircleId('pickup'),
      strokeColor: Colors.green,
      strokeWidth: 3,
      radius: 12,
      center: pickLatLng,
      fillColor: BrandColors.colorGreen,
    );

    Circle destinationCircle = Circle(
      circleId: CircleId('destination'),
      strokeColor: BrandColors.colorAccentPurple,
      strokeWidth: 3,
      radius: 12,
      center: destinationLatLng,
      fillColor: BrandColors.colorAccentPurple,
    );

    setState(() {
      _Circles.add(pickupCircle);
      _Circles.add(destinationCircle);
    });
  }

  // Tìm vị trí các tài xế gần người dùng
  void startGeofireListener() {
    Geofire.initialize('driversAvailable');
    Geofire.queryAtLocation(
            currentPosition.latitude, currentPosition.longitude, 1)
        .listen((map) {
      if (map != null) {
        var callBack = map['callBack'];

        //latitude will be retrieved from map['latitude']
        //longitude will be retrieved from map['longitude']

        switch (callBack) {
          case Geofire.onKeyEntered:
            NearByDriver nearByDriver = NearByDriver();
            nearByDriver.key = map['key'];
            nearByDriver.latitude = map['latitude'];
            nearByDriver.longitude = map['longitude'];
            FireHelper.nearByDriverList.add(nearByDriver);

            if (nearByDriversKeysLoaded) {
              updateDriversOnMap();
            }

            break;

          case Geofire.onKeyExited:
            FireHelper.removeFromList(map['key']);
            updateDriversOnMap();
            break;

          case Geofire.onKeyMoved:
            // Update your key's location
            NearByDriver nearByDriver = NearByDriver();
            nearByDriver.key = map['key'];
            nearByDriver.latitude = map['latitude'];
            nearByDriver.longitude = map['longitude'];

            FireHelper.updateNearByLocation(nearByDriver);
            updateDriversOnMap();
            break;

          case Geofire.onGeoQueryReady:
            // All initial data is loaded
            nearByDriversKeysLoaded = true;
            updateDriversOnMap();
            break;
        }
      }
    });
  }

  void updateDriversOnMap() {
    setState(() {
      _Markers.clear();
    });

    Set<Marker> tempMarkers = Set<Marker>();
    for (NearByDriver driver in FireHelper.nearByDriverList) {
      LatLng driverPositition = LatLng(driver.latitude, driver.longitude);

      Marker thisMarker = Marker(
        markerId: MarkerId('driver${driver.key}'),
        position: driverPositition,
        icon: nearByIcon,
        rotation: HelperMethod.generateRandomNumber(360),
      );
      tempMarkers.add(thisMarker);
    }
    setState(() {
      _Markers = tempMarkers;
    });
  }

  void createRideRequest() {
    rideRef = FirebaseDatabase.instance.reference().child('rideRequest').push();

    var pickup = Provider.of<AppData>(context, listen: false).pickupAddress;
    var destination =
        Provider.of<AppData>(context, listen: false).destinationAddress;
    Map pickupMap = {
      'latitude': destination.latitude.toString(),
      'longitude': pickup.longitude.toString(),
    };
    Map destinationMap = {
      'latitude': destination.latitude.toString(),
      'longitude': destination.longitude.toString(),
    };
    Map rideMap = {
      'created_at': DateTime.now().toString(),
      'user_name': currentUserInfo.fullName,
      'user_phone': currentUserInfo.phone,
      'pickup_andress': pickup.placeName,
      'destination_address': destination.placeName,
      'location': pickupMap,
      'destination': destinationMap,
      'payment_method': 'card',
      'driver_id': 'wait',
    };
    rideRef.set(rideMap);

    rideSubcription = rideRef.onValue.listen((event) async {
      // Check for null snapshot
      if(event.snapshot.value == null) {
        return;
      }

      // Get car details
      if(event.snapshot.value['car_details'] != null) {
        setState(() {
          driverCarDetails = event.snapshot.value['car_details'].toString();

        });
      }

      // Get driver name
      if(event.snapshot.value['driver_name'] != null) {
        setState(() {
         driverFullName = event.snapshot.value['driver_name'].toString();
        });
      }

      // Get driver phone number
      if(event.snapshot.value['driver_phone'] != null) {
        setState(() {
          driverPhoneNumber = event.snapshot.value['driver_phone'].toString();
        });
      }


      if(event.snapshot.value['status'] != null) {
        status = event.snapshot.value['status'].toString();
      }

      if(status == 'accepted') {
        showTripSheet();
        Geofire.stopListener();
        removeGeofireMarkers();
      }
      
      if(status == "ended") {
        if(event.snapshot.value['fares'] != null) {
          int fares = int.parse(event.snapshot.value["fares"].toString());

          var response = await showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) => CollectPayment(paymentMethod: 'cash', fares: fares,),
          );

          if(response == 'close') {
            rideRef.onDisconnect();
            rideRef = null;
            rideSubcription.cancel();
            rideSubcription = null;
            resetApp();
          }
        }
      }

    });
  }

  void cancelRequest() {
    rideRef.remove();

    setState(() {
      appState = "NORMAL";
    });
  }

  resetApp() {
    setState(() {
      polyLineCoordinates.clear();
      _polylines.clear();
      _Markers.clear();
      _Circles.clear();
      rideDetailsSheetHeight = 0;
      requestingSheetHeight = 0;
      tripSheetHeight = 0;
      searchSheetHeight = 300;
      mapBottomPadding = 10;
      drawerCarOpen = true;

      status = '';
      driverFullName = '';
      driverPhoneNumber = '';
      driverCarDetails = '';
      tripStatusDisplay = 'Driver is arriving';
    });

    setupPositionLocator();
  }

  void noDriverFound() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => NoDriverDialog()
    );
  }

  void findDriver() {
    if(availableDrivers.length == 0){
      cancelRequest();
      resetApp();
      noDriverFound();
      // No driver

      return;
    }

    var driver = availableDrivers[0];

    notifyDriver(driver);

    availableDrivers.removeAt(0);

    print(driver.key);
  }

  void notifyDriver(NearByDriver driver) {
    DatabaseReference driverTripRef = FirebaseDatabase.instance.reference().child("drivers/${driver.key}/newtrip");
    driverTripRef.set(rideRef.key);

    // Get and notify driver using token
    DatabaseReference tokenRef = FirebaseDatabase.instance.reference().child("drivers/${driver.key}/token");

    tokenRef.once().then((DataSnapshot snapshot) {
      if(snapshot.value != null) {
        String token = snapshot.value.toString();

        // Send notification to selected driver
        HelperMethod.sendNotification(token, context, rideRef.key);
      }
      else {
        return;
      }

      const oneSecTick = Duration(seconds: 1);

      var timer = Timer.periodic(oneSecTick, (timer) {
        // Stop timer when ride request is cancelled
        if(appState != "REQUESTING") {
          driverTripRef.set("cancelled");
          driverTripRef.onDisconnect();
          timer.cancel();
          driverRequestTimeOut = 30;
        }

        driverRequestTimeOut --; // vid 92 không hiểu

        // A value event listener for driver accepting trip request
        driverTripRef.onValue.listen((event) {
          // Confirms that driver has clicked accepted for the new trip request
          if(event.snapshot.value.toString() == 'accepted') {
            driverTripRef.onDisconnect();
            timer.cancel();
            driverRequestTimeOut = 30;
          }
        });

        if(driverRequestTimeOut == 0) {
          // Informs diver that ride has timed out
          driverTripRef.set('timeout');
          driverTripRef.onDisconnect();
          driverRequestTimeOut = 30;
          timer.cancel();

          // Select the next closest driver
          findDriver();

        }

      });
    });
  }
  
  void removeGeofireMarkers() {
    setState(() {
      _Markers.removeWhere((m) => m.markerId.value.contains('driver'));
    });
  }
}
