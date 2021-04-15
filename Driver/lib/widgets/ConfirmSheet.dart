import 'package:driver/brand_colors.dart';
import 'package:driver/widgets/TaxiButton.dart';
import 'package:driver/widgets/TaxiOutlineButton.dart';
import 'package:flutter/material.dart';

class ConfirmSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 15.0, // Soften the shadow
            spreadRadius: 0.5, // Extend the shadow
            offset: Offset(
              0.7, // Move to right 10 horizontally
              0.7, // Move to bottom 10 horizontally
            )
          )
        ],
      ),
      height: 220,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        child: Column(
          children: <Widget>[
            SizedBox(height: 10,),

            Text(
              'GO ONLINE',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontFamily: 'Brand-Bold', color: BrandColors.colorText),
            ),

            SizedBox(height: 20,),

            Text(
              'You are about to become available to receive trip requests',
              textAlign: TextAlign.center,
              style: TextStyle(color: BrandColors.colorTextLight),
            ),

            SizedBox(height: 24,),

            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    child: TaxiOutlineButton(
                      title: 'BACK',
                      color: BrandColors.colorLightGrayFair,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),

                SizedBox(height: 20,),

                Expanded(
                    child: Container(
                      child: TaxiButton(
                        onPressed: () {

                        },
                        color: BrandColors.colorGreen,
                        title: 'CONFIRM',
                      ),
                    ),
                ),

              ],
            )
          ],
        ),
      ),
    );
  }
}
