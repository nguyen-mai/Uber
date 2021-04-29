import 'package:driver/globalvariables.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService {
  final FirebaseMessaging fcm = FirebaseMessaging.instance;

  Future initialize() async {
    // Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
      // If you're going to use other Firebase services in the background, such as Firestore,
      // make sure you call `initializeApp` before using other Firebase services.
      await Firebase.initializeApp();

      RemoteMessage message;

      print("Handling a background message: ${message}");
    // }
    // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  Future<String> getToken() async {
    String token = await fcm.getToken();
    print('token: $token');

    DatabaseReference tokenRef = FirebaseDatabase.instance.reference().child('drivers/${currentFirebaseUser.uid}');
    tokenRef.set(token);

    fcm.subscribeToTopic('alldrivers');
    fcm.subscribeToTopic('allusers');

  }


}