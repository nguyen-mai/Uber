import 'package:firebase_database/firebase_database.dart';

class UserInfomation {
  String fullName;
  String email;
  String phone;
  String id;

  UserInfomation({this.email, this.fullName, this.phone, this.id});

  UserInfomation.fromSnapshot(DataSnapshot snapshot){
    id=snapshot.key;
    phone=snapshot.value["phone"];
    email=snapshot.value['email'];
    fullName=snapshot.value['name'];
  }
}
