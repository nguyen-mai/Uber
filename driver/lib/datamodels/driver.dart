import 'package:firebase_database/firebase_database.dart';

<<<<<<< Updated upstream
class Driver{
=======
class Driver {
>>>>>>> Stashed changes
  String fullName;
  String email;
  String phone;
  String id;
  String carModel;
  String carColor;
  String vehicleNumber;
<<<<<<< Updated upstream

=======
  String newtrip;
>>>>>>> Stashed changes
  Driver({
    this.fullName,
    this.email,
    this.phone,
    this.id,
    this.carModel,
    this.carColor,
    this.vehicleNumber,
<<<<<<< Updated upstream
  });

  Driver.fromSnapshot(DataSnapshot snapshot){
    id = snapshot.key;
    phone = snapshot.value['phone'];
    email = snapshot.value['email'];
    fullName = snapshot.value['fullname'];
    carModel = snapshot.value['vehicle_details']['car_model'];
    carColor = snapshot.value['vehicle_details']['car_color'];
    vehicleNumber = snapshot.value['vehicle_details']['vehicle_number'];
=======
    this.newtrip,
});

  Driver.fromSnapShot(DataSnapshot snapshot) {
    id = snapshot.key;
    phone = snapshot.value["phone"];
    email = snapshot.value["email"];
    fullName = snapshot.value["name"];
    carModel = snapshot.value["vehicle_details"]["car_model"];
    carColor = snapshot.value["vehicle_details"]["car_color"];
    vehicleNumber = snapshot.value["vehicle_details"]["vehicle_number"];

>>>>>>> Stashed changes
  }

}