import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber/datamodels/user.dart';

String mapKey="AIzaSyACJE9wrXRvUpCpt3tXi4cGmHRwXiDBe80";
final CameraPosition googleFlex = CameraPosition(
  target: LatLng(37.42796133580664, -122.085749655962),
  zoom: 14.4746,
);
UserInfomation currentUserInfo;
User currentFirebaseUser;