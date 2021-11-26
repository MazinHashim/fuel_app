import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fuel_app/locale/locale.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<SharedPreferences> _sPref = SharedPreferences.getInstance();
  SharedPreferences pref;
  String username;
  List userInfo;

  Future<String> getUserName() async {
    pref = await _sPref;
    setState(() {
      userInfo = pref.getStringList("user_token");
      if(userInfo != null){
        username = userInfo[1];
      }
    });
    return username;
  }

  @override
  void initState() {
    super.initState();
    Future<String> fuser = getUserName();
    fuser.then((value) {
      username = value;
      return Timer(
          Duration(seconds: 5),
          () => username == null
              ? Navigator.of(context).pushNamedAndRemoveUntil(
                  "login", (Route<dynamic> route) => false)
              : Navigator.of(context).pushNamedAndRemoveUntil(
                  "home", (Route<dynamic> route) => false));
    });
  }

  @override
  Widget build(BuildContext context) {
    print(username);
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      maxRadius: 100.0,
                      backgroundImage: AssetImage(
                        "images/logo6.png",
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: Text(
                        "Facily App",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Lobster",
                            fontWeight: FontWeight.bold,
                            fontSize: 30.0),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircularProgressIndicator(
                        backgroundColor: Colors.white,
                      ),
                      Padding(
                          padding: EdgeInsets.only(top: 20.0),
                          child: Text(
                            AppLocalizations.of(context).splashLoadingText,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          ))
                    ],
                  ))
            ],
          )
        ],
      ),
    );
  }
}
