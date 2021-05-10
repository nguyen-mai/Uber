import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber/datamodels/user.dart';

String serverKey = "key= AAAAkRbFla8:APA91bHzj-cEgEvi160fbdGQ71afIkNZ2Ddq7athIb6sj5OxP6kWgfKE9_InbsuNZTPwdE1RwE6puUfS1fT522NYX9UWXe2lOo97_6Dz_vTIJTh5UUS3vlfPSsPAtLUNsAhI1tzmEmwb";

String mapKey = "AIzaSyACJE9wrXRvUpCpt3tXi4cGmHRwXiDBe80";

// Vị trí ngay tại một thời điểm
final CameraPosition googleFlex = CameraPosition(
  target: LatLng(37.42796133580664, -122.085749655962),
  zoom: 14.4746,
);
UserInformation currentUserInfo;
User currentFirebaseUser;
String userName;
//currentUserInfo= UserInfomation.fromSnapshot(snapshot);