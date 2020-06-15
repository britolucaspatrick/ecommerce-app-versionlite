import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:bertonlite/business/auth.dart';
import 'package:bertonlite/screen/loginpage.dart';
import 'package:bertonlite/screen/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  List<String> nameList = List();

  @override
  void initState() {
    super.initState();
    nameList.add('Sua MARCA');
    nameList.add('Seus VALORES');
    nameList.add('Sua MISSÃO');
    nameList.add('Sua VISÃO');

    SystemChrome.setEnabledSystemUIOverlays([]);
    Future.delayed(Duration(seconds: 7), changeScreen);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(left: 40.0, right: 40.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              AnimatedOpacity(
                opacity: 1.0,
                duration: Duration(seconds: 3),
                child: Image.asset('assets/welcome.png', width: 200, height: 200),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  RotateAnimatedTextKit(
                    text: nameList,
                    textStyle: TextStyle(
                      fontSize: 25.0,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w900,
                      color: Theme.of(context).accentColor,
                    ),
                  )
                ],
              )

            ],
          ),
        ),
      ),
    );
  }

  changeScreen() async {
    Auth.getCurrentFirebaseUser().then((onValue){
      if (onValue != null){
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context){
              return SearchScreen();
            },
          ),
        );
      }else{
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context){
              return LoginPage();
            },
          ),
        );
      }
    }).timeout(Duration(seconds: 7), onTimeout: () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context){
            return LoginPage();
          },
        ),
      );
    });
  }

}
