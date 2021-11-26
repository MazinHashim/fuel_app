import 'package:flutter/material.dart';
import 'package:fuel_app/locale/locale.dart';
import 'package:fuel_app/model/company_api.dart';
import 'package:fuel_app/model/user_api.dart';
import 'package:fuel_app/controller/api_services.dart';
import 'package:get_it/get_it.dart';

class StationNoteWidget extends StatefulWidget {
  final Companys cmpInfo;
  final User user;
  StationNoteWidget(this.cmpInfo, this.user);

  @override
  _StationNoteWidgetState createState() => _StationNoteWidgetState();
}

class _StationNoteWidgetState extends State<StationNoteWidget> {
  String _desc;

  get desc => this._desc;

  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  var path = "feeds";
  String errorMessage;
  bool isLoading = false;
  APIServices get service => GetIt.I<APIServices>();

  @override
  Widget build(BuildContext context) {
    final Locale locale = Localizations.localeOf(context);
    final AppLocalizations lng = AppLocalizations.of(context);

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(title: Text(widget.cmpInfo.cmpName)),
      body: ListView(
        children: <Widget>[
          SizedBox(height: MediaQuery.of(context).size.height * 0.09),
          isLoading
              ? Center(
                  child: Text(
                  lng.sendLoadingtxt,
                  style: TextStyle(color: Colors.blue, fontSize: 20.0),
                ))
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
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
                                        .withOpacity(0.3)),
                              ],
                              color: Colors.white),
                          child: Column(
                            children: <Widget>[
                              ListTile(
                                title: Text(lng.cmpNametxt, style: TextStyle(fontWeight: locale.languageCode== "ar"?FontWeight.normal:FontWeight.bold),),
                                subtitle: Text("${widget.cmpInfo.cmpName}", style: TextStyle(fontWeight: FontWeight.bold),),
                                leading:
                                    Icon(Icons.business, color: Colors.black),
                              ),
                              TextFormField(
                                style: TextStyle(fontWeight: locale.languageCode== "ar"?FontWeight.normal:FontWeight.bold ),
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    labelStyle: TextStyle(color: Colors.black),
                                    errorStyle: TextStyle(
                                    fontWeight: locale.languageCode == "ar"
                                        ? FontWeight.normal
                                        : FontWeight.bold),
                                    contentPadding: EdgeInsets.all(15.0),
                                    labelText: lng.desctxt,
                                    prefixIcon:
                                        Icon(Icons.note, color: Colors.black)),
                                maxLines: 10,
                                validator: (str) {
                                  if (str.length < 5) {
                                    return lng.len5ErrorMessage;
                                  } else {
                                    return null;
                                  }
                                },
                                onSaved: (str) => _desc = str,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 40.0),
                        Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 10.0,
                                    color: Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.5),
                                    offset: Offset(-5.0, 5.0))
                              ],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              FlatButton.icon(
                                icon: Icon(Icons.send, size: 15.0),
                                highlightColor: Colors.white,
                                padding: EdgeInsets.all(15.0),
                                label: Text(lng.sendtxt, style: TextStyle(fontWeight: locale.languageCode== "ar"?FontWeight.normal:FontWeight.bold),),
                                textColor: Colors.white,
                                onPressed: () {
                                  onFeedbackSend(lng);
                                },
                              ),
                            ],
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

  Future<void> onFeedbackSend(AppLocalizations lng) async {
    var form = formKey.currentState;

    if (form.validate()) {
      form.save();
      setState(() {
        isLoading = true;
      });
      senFeedback(lng);
    }
  }

  void senFeedback(AppLocalizations lng) async {
    service.sendFeedback(path, {
      "desc": desc,
      "cmpId": widget.cmpInfo.cmpId,
      "userId": widget.user.userId
    }).then((response) {
      setState(() {
        isLoading = false;
      });
      if (response.error) {
        errorMessage = response.errorMessage ?? lng.publicError;
        // Show SnackBar Failure Message;
        scaffoldKey.currentState
            .showSnackBar(service.showAppMessages(lng.connErrorMessage));
        print("$errorMessage");
      } else {
        print("${response.data}");
        if (response.data) {
          // Show SnackBar Success Message;
          scaffoldKey.currentState
              .showSnackBar(service.showAppMessages(lng.feedSuccessMessage));
          // Navigator.of(context).pop();
        } else {
          // Show SnackBar Failure Message;
        }
      }
    });
  }
}
