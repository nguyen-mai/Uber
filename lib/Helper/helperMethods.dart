import 'package:connectivity/connectivity.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uber/Helper/RequestHelper.dart';
import 'package:uber/globevariable.dart';

class HeplerMethod {
  static Future<String> findCordinateAndress(Position position) async {
    String placeAndress = '';
    var connectivityReslut = await Connectivity().checkConnectivity();
    if (connectivityReslut != ConnectivityResult.mobile &&
        connectivityReslut != ConnectivityResult.wifi) {
      return placeAndress;
    }
    var url= Uri.parse('https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=${mapKey}');
    var response = await RequestHelper.getRequest(url);
    if (response != "failed") {
      placeAndress=response['results'][0]['formatted_address'];
    }
    if(response=="failed"){
      return "Unknown";
    }
    return placeAndress;
  }
}
