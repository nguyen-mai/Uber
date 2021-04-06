import 'dart:io';

import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:provider/provider.dart';
import 'package:uber/DataProvider/appdata.dart';
import 'package:uber/Helper/RequestHelper.dart';
import 'package:uber/brand_colors.dart';
import 'package:uber/datamodels/prediction.dart';
import 'package:uber/globevariable.dart';
import 'package:uber/datamodels/address.dart';

class PredictionTile extends StatelessWidget {

  final Prediction prediction;
  PredictionTile({this.prediction});
  void getPlaceDetails(String placeID, context) async {
    var url = Uri.parse('https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeID&key=$mapKey');
    // String url = 'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeID&fields=name,rating,formatted_phone_number&key=$mapKey';
    var response = await RequestHelper.getRequest(url);

    if (response == 'failed') {
      return;
    }

    if (response['status'] == 'OK') {
      Address thisPlace = Address();
      thisPlace.placeName = response['result']['name'];
      thisPlace.placeId = placeID;
      thisPlace.latitude = response['result']['geometry']['location']['lat'];
      thisPlace.longitude = response['result']['geometry']['location']['lng'];

      Provider.of<Appdata>(context, listen: false).updateDestinationAddress(thisPlace);
      print(thisPlace.placeName);

      Navigator.pop(context, 'getDirection');

    }
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        getPlaceDetails(prediction.placeId, context);
      },
      padding: EdgeInsets.all(0),
      child: Container(
        child: Column(
          children: <Widget>[
            SizedBox(height: 8,),
            Row(
              children: <Widget>[
                Icon(OMIcons.locationOn, color: BrandColors.colorDimText,),
                SizedBox(width: 12,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(prediction.mainText, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 16),),
                      SizedBox(height: 2,),
                      Text(prediction.secondaryText, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12, color: BrandColors.colorDimText),),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(height: 8,),
          ],
        ),
      ),
    );
  }
}
