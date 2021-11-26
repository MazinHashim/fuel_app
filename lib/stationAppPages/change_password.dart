import 'package:flutter/material.dart';
import 'package:fuel_app/locale/locale.dart';
import 'package:fuel_app/model/user_api.dart';
import 'package:fuel_app/controller/api_services.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChgPass extends StatefulWidget {
  final User user;
  ChgPass({Key key, this.user}) : super(key: key);

  @override
  _ChgPassState createState() => _ChgPassState();
}

class _ChgPassState extends State<ChgPass> {
  final formKey = new GlobalKey<FormState>();
  String _newPassword;
  Future<SharedPreferences> _sPref = SharedPreferences.getInstance();
  var path = "veryfy";
  String errorMessage;
  bool showPassword = false;
  bool isLoading = false;
  APIServices get service => GetIt.I<APIServices>();
  get newPassword => this._newPassword;

  @override
  Widget build(BuildContext context) {
    final Locale localectx = Localizations.localeOf(context);
    final AppLocalizations lng = AppLocalizations.of(context);

    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView(
              children: <Widget>[
                SizedBox(height: MediaQuery.of(context).size.height * 0.09),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(
                                  color: Theme.of(context).primaryColor,
                                  width: 0.5),
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 10.0,
                                    color: Theme.of(context)
                                        .accentColor
                                        .withOpacity(0.3))
                              ],
                              color: Colors.white),
                          child: Column(
                            children: <Widget>[
                              Icon(Icons.account_circle,
                                  color: Theme.of(context).primaryColor,
                                  size: 100.0),
                              Text("Wellcome", //lng.usernametxt,
                                  style: TextStyle(
                                      fontWeight: localectx.languageCode == "ar"
                                          ? FontWeight.normal
                                          : FontWeight.bold)),
                              Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("${widget.user.username}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))),
                              TextFormField(
                                obscureText: true,
                                style: TextStyle(fontWeight: FontWeight.bold),
                                decoration: InputDecoration(
                                    border: UnderlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0)),
                                    labelText: lng.currentPasswordtxt,
                                    labelStyle: TextStyle(color: Colors.black),
                                    contentPadding: EdgeInsets.all(15.0),
                                    errorStyle: TextStyle(
                                    fontWeight: localectx.languageCode == "ar"
                                        ? FontWeight.normal
                                        : FontWeight.bold),
                                    prefixIcon:
                                        Icon(Icons.lock, color: Colors.black)),
                                validator: (str) {
                                  if (str.isEmpty) {
                                    return lng.requiredFieldsMessage;
                                  } else if (str.length < 3) {
                                    return lng.len3ErrorMessage;
                                  } else if (str
                                          .compareTo(widget.user.password) !=
                                      0) {
                                    return lng.wrongPass;
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                              TextFormField(
                                obscureText: showPassword,
                                style: TextStyle(fontWeight: FontWeight.bold),
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    labelStyle: TextStyle(color: Colors.black),
                                    contentPadding: EdgeInsets.all(15.0),
                                    labelText: lng.newPasswordtxt,
                                    errorStyle: TextStyle(
                                    fontWeight: localectx.languageCode == "ar"
                                        ? FontWeight.normal
                                        : FontWeight.bold),
                                    suffixIcon: InkWell(
                                        onTap: () {
                                          setState(() {
                                            showPassword = !showPassword;
                                          });
                                        },
                                        child: Icon(
                                            showPassword
                                                ? Icons.visibility
                                                : Icons.visibility_off,
                                            size: 20.0)),
                                    prefixIcon:
                                        Icon(Icons.note, color: Colors.black)),
                                validator: (str) {
                                  if (str.isEmpty) {
                                    return lng.requiredFieldsMessage;
                                  } else if (str.length < 3) {
                                    return lng.len3ErrorMessage;
                                  } else if (str
                                          .compareTo(widget.user.password) ==
                                      0) {
                                    return lng.passIsAlreadyExist;
                                  } else {
                                    return null;
                                  }
                                },
                                onSaved: (str) => _newPassword = str,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 40.0),
                        Container(
                          alignment: Alignment.topRight,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0))),
                          child: RaisedButton(
                            highlightColor: Colors.white,
                            color: Theme.of(context).primaryColor,
                            padding: EdgeInsets.all(15.0),
                            child: Text(
                              lng.submittxt,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            textColor: Colors.white,
                            onPressed: () {
                              onPasswordChange(lng);
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
    );
  }

  Future<void> onPasswordChange(AppLocalizations lng) async {
    var form = formKey.currentState;

    if (form.validate()) {
      form.save();
      setState(() {
        isLoading = true;
      });
      verifingPassword(lng, newPassword);
    }
  }

  void verifingPassword(AppLocalizations lng, String password) async {
    SharedPreferences pref = await _sPref;
    service.customPatchRequest(path, {
      "userId": widget.user.userId,
      "password": password,
      "verified": true
    }).then((response) {
      setState(() {
        isLoading = false;
      });
      if (response.error) {
        errorMessage = response.errorMessage ?? lng.publicError;
        // Show SnackBar Message;
        print("$errorMessage");
      } else {
        widget.user.password = password;
        print(widget.user.password);
        pref.setStringList("user_token", widget.user.toList());
        Navigator.of(context).pushNamedAndRemoveUntil(
            "features", (Route<dynamic> route) => false);
      }
    });
  }
}
