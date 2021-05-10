import 'package:firebase_database/firebase_database.dart';

class UserInformation {
  String fullName;
  String email;
  String phone;
  String id;

  UserInformation({this.email, this.fullName, this.phone, this.id});

  UserInformation.fromSnapshot(DataSnapshot snapshot){
    id=snapshot.key;
    phone=snapshot.value["phone"];
    email=snapshot.value['email'];
    fullName=snapshot.value['name'];
  }
  String getName(){
    return this.fullName;
}
}
