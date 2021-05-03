import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
class NotificationDialog extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),

      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.all(4),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4)
        ),
        child: Column(
          children: <Widget>[
            Row(
              //crossAxisAlignment:,
            )

          ],
        ),
      ),
    );
  }

}