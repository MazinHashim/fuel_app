import 'package:flutter/material.dart';
import 'package:fuel_app/locale/locale.dart';
import 'package:fuel_app/main.dart';
import 'package:fuel_app/model/user_api.dart';
import 'package:fuel_app/controller/api_services.dart';
import 'package:fuel_app/stationAppPages/change_password.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email, _password;
  Future<SharedPreferences> _sPref = SharedPreferences.getInstance();
  var path = "login";
  String errorMessage;
  bool isLoading = false;
  bool showPassword = false;
  User user;
  APIServices get service => GetIt.I<APIServices>();

  get password => this._password;
  get email => this._email;

  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  void getUserByEmailAndPassword(
      AppLocalizations lng, String email, String password) async {
    SharedPreferences pref = await _sPref;
    service.fetchUserData(path,email,password).then((response) {
      // service.fetchUserData(path).then((response) {
      setState(() {
        isLoading = false;
      });
      if (response.error) {
        errorMessage = response.errorMessage ?? lng.publicError;
      }
      user = response.data;
      if (user != null) {
        if (user.verified) {
          pref.setStringList("user_token", user.toList());
          Navigator.of(context).pushNamedAndRemoveUntil(
              "features", (Route<dynamic> route) => false);
        } else {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => ChgPass(user: user)));
        }
      } else {
        scaffoldKey.currentState
            .showSnackBar(service.showAppMessages(lng.loginFailMessage));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations lng = AppLocalizations.of(context);
    final Locale localectx = Localizations.localeOf(context);

    void changeLanguage(Locale loc) {
      Locale temp;
      switch (loc.languageCode) {
        case "en":
          temp = Locale("ar", "SU");
          break;
        case "ar":
          temp = Locale("en", "US");
          break;
        default:
          temp = Locale("en", "US");
      }

      MyApp.setLocale(context, temp);
    }

    return Scaffold(
      key: scaffoldKey,
      body: Stack(
        children: <Widget>[
          ListView(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("images/login.png"),
                        fit: BoxFit.fill)),
                height: MediaQuery.of(context).size.height * 0.3,
                child: Container(
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                        spreadRadius: 30.0,
                        blurRadius: 70.0,
                        color: Theme.of(context).primaryColor.withOpacity(0.6))
                  ]),
                  padding: const EdgeInsets.only(
                      bottom: 25.0, left: 10.0, right: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Icon(Icons.account_circle,
                          size: 50.0, color: Colors.white),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        lng.loginHeaderText,
                        textAlign: TextAlign.start,
                        style: TextStyle(color: Colors.white, fontSize: 40.0),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 100.0),
              isLoading
                  ? Center(
                      child: Text(
                      lng.loadingtxt,
                      style: TextStyle(color: Colors.blue, fontSize: 20.0, fontWeight: FontWeight.bold,),
                    ))
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      child: Form(
                        key: formKey,
                        child: Column(
                          children: <Widget>[
                            DecoratedBox(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 10.0,
                                      color: Theme.of(context)
                                          .accentColor
                                          .withOpacity(0.3),
                                    ),
                                  ],
                                  color: Colors.white),
                              child: Column(
                                children: <Widget>[
                                  TextFormField(
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                        border: UnderlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0)),
                                        labelText: lng.hintEmailText,
                                        labelStyle: TextStyle(color: Colors.black),
                                        errorStyle: TextStyle(
                                        fontWeight: localectx.languageCode == "ar"
                                            ? FontWeight.normal
                                            : FontWeight.bold),
                                        contentPadding: EdgeInsets.all(15.0),
                                        prefixIcon: Icon(
                                          Icons.person,
                                          color: Colors.black,
                                        )),
                                    validator: (str) {
                                      if (str.isEmpty) {
                                        return lng.requiredFieldsMessage;
                                      } else if (str.length < 3) {
                                        return lng.len3ErrorMessage;
                                      } else if (!str.trim().contains("@")) {
                                        return lng.emailValidErrorMessage;
                                      } else {
                                        return null;
                                      }
                                    },
                                    onSaved: (str) => _email = str,
                                  ),
                                  TextFormField(
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                    decoration: InputDecoration(
                                        suffixIcon: InkWell(
                                            onTap: () {
                                              setState(() {
                                                showPassword = !showPassword;
                                              });
                                            },
                                            child: Icon(
                                                showPassword
                                                    ? Icons.visibility_off
                                                    : Icons.visibility,
                                                size: 20.0)),
                                        border: InputBorder.none,
                                        labelStyle: TextStyle(color: Colors.black),
                                        contentPadding: EdgeInsets.all(15.0),
                                        labelText: lng.hintPassText,
                                        errorStyle: TextStyle(
                                        fontWeight: localectx.languageCode == "ar"
                                            ? FontWeight.normal
                                            : FontWeight.bold),
                                        prefixIcon: Icon(Icons.lock,
                                            color: Colors.black)),
                                    obscureText: !showPassword,
                                    validator: (str) {
                                      if (str.isEmpty) {
                                        return lng.requiredFieldsMessage;
                                      } else if (str.length < 5) {
                                        return lng.len5ErrorMessage;
                                      } else {
                                        return null;
                                      }
                                    },
                                    onSaved: (str) => _password = str,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 80.0),
                            Container(
                              width: 200.0,
                              decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0))),
                              child: FlatButton(
                                highlightColor: Colors.white,
                                color: Colors.transparent.withOpacity(0.0),
                                padding: EdgeInsets.all(20.0),
                                child: Text(lng.loginButtonText,
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: localectx.languageCode == "ar"
                                          ? FontWeight.normal
                                          : FontWeight.bold,
                                    )),
                                textColor: Colors.white,
                                onPressed: () {
                                  onLoginBtnPressed(lng);
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
            ],
          ),
          Positioned(
              top: 40.0,
              left: localectx.languageCode.contains('ar') ? 10.0 : 280.0,
              right: localectx.languageCode.contains('ar') ? 270.0 : 10.0,
              child: InkWell(
                onTap: () => changeLanguage(localectx),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 5.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(width: 0.5, color: Colors.white)),
                  child: Text(
                    localectx.languageCode.contains('ar')
                        ? "English"
                        : "العربية",
                    style: TextStyle(color: Colors.white, fontSize: 17.0),
                    textAlign: TextAlign.center,
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Future<void> onLoginBtnPressed(AppLocalizations lng) async {
    var form = formKey.currentState;

    if (form.validate()) {
      form.save();
      setState(() {
        isLoading = true;
      });
      getUserByEmailAndPassword(lng, email, password);
    }
  }
}
