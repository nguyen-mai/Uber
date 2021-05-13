import 'dart:convert';

<<<<<<< Updated upstream
import 'package:http/http.dart' as http;

class RequestHelper{


  static Future<dynamic> getRequest(String url) async {
    http.Response response = await http.get(url);

    try{
      if(response.statusCode == 200){
        String data = response.body;
        var decodedData = jsonDecode(data);
        return decodedData;
      }
      else{
        return 'failed';
      }
    }
    catch(e){
      return 'failed';
    }


  }

}
=======
//import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RequestHelper {
  static Future<dynamic> getRequest(var url) async {
    http.Response response = await http.get(url);
    try {
      if (response.statusCode == 200) {
        String data = response.body;
        var decodeData = jsonDecode(data);
        return decodeData;
      } else {
        return "failed";
      }
    } catch (e) {
      return "failed";
    }
  }
}
>>>>>>> Stashed changes
