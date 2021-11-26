import 'package:flutter/material.dart';
import 'package:fuel_app/locale/locale.dart';
import 'package:fuel_app/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './logo_container.dart';

class LogoAppBar extends StatelessWidget {
  final Future<SharedPreferences> _sPref = SharedPreferences.getInstance();

  @override
  Widget build(BuildContext context) {
    AppLocalizations lng = AppLocalizations.of(context);
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

    return SliverAppBar(
      pinned: true,
      floating: true,
      elevation: 0.0,
      expandedHeight: MediaQuery.of(context).size.height * 0.20,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        background: new LogoContainer(),
        centerTitle: true,
        title: Container(
          width: 130.0,
          alignment: Alignment.bottomCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text("Facily App", style: TextStyle(fontFamily: "Lobster")),
              Icon(Icons.ev_station, size: 25.0, color: Colors.white),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        PopupMenuButton<String>(
          elevation: 20.0,
          icon: Icon(Icons.more_vert, color: Colors.black),
          offset: Offset(4.0, 40.0),
          onSelected: (String value) async {
            if (value.compareTo(lng.logoutButton) == 0) {
              SharedPreferences pref = await _sPref;
              pref.remove("user_token");
              pref.clear();
              Navigator.of(context).pushNamedAndRemoveUntil(
                  "login", (Route<dynamic> route) => false);
            } else if (value.compareTo("English") == 0 ||
                value.compareTo("العربية") == 0) {
              changeLanguage(localectx);
            }
          },
          itemBuilder: (BuildContext context) => <String>[
            localectx.languageCode.contains('ar') ? "English" : "العربية",
            lng.logoutButton
          ].map<PopupMenuItem<String>>((String value) {
            return PopupMenuItem(
              child: Text(value),
              value: value,
              height: 30.0,
              textStyle: TextStyle(
                  fontSize: 15.0,
                  color: Theme.of(context).accentColor,
                  textBaseline: TextBaseline.alphabetic),
            );
          }).toList(),
        )
      ],
    );
  }
}
