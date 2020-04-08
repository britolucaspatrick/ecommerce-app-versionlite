import 'package:bertonlite/shared/styles.dart';
import 'package:flutter/material.dart';

class Loading {

  static void dismiss(BuildContext context){
    Navigator.pop(context);
  }

  static void start(BuildContext context, String title){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: Container(
                decoration: boxDecorationContainer,
                height: 300,
                width: 250,
                child: Card(
                  elevation: 0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.green),),
                      SizedBox(width: 10, height: 10,),
                      Padding(
                        padding: EdgeInsets.only(right: 15, left: 15),
                        child: Text(title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.green,
                                fontSize: 15)
                        ),
                      ),
                    ],
                  ),
                )
            ),
          );
        }
    );
  }
}