import 'package:flutter/material.dart';
import 'package:fuel_app/locale/locale.dart';

class FeatPage extends StatelessWidget {
  static const kImg = <String>[
    "images/cards.png",
    "images/find_map.png",
    "images/find_sts.png",
    "images/short_path.png",
    "images/fav.png",
    "images/mob_msg.png",
  ];
  @override
  Widget build(BuildContext context) {
    final Locale locale = Localizations.localeOf(context);
    return Scaffold(
      body: DefaultTabController(
        length: kImg.length,
        child: Builder(
          builder: (BuildContext context) => Padding(
            padding: EdgeInsets.only(top: 40.0, bottom: 20.0),
            child: Column(
              children: <Widget>[
                TabPageSelector(),
                Expanded(
                  child: TabBarView(
                    children: <Widget>[
                      buildFeatPages(context, kImg[0],
                          "View station and amout of fuel and Choose the nearest gas station",
                          top: 80.0, left: 180.0),
                      buildFeatPages(context, kImg[1],
                          "View the station and its location in the map",
                          top: 70.0, left: 40.0, right: 50.0),
                      buildFeatPages(context, kImg[2],
                          "The nearest station is known by your current location",
                          top: 30.0, right: 150.0),
                      buildFeatPages(context, kImg[3],
                          "Knowing the shortest path to the station",
                          left: 150.0),
                      buildFeatPages(context, kImg[4],
                          "You can add station to Favorites to notify when it is Refueled",
                          top: 10.0, right: 140.0),
                      buildFeatPages(context, kImg[5],
                          "Sharing your feedbacks and comments to our services for improvement",
                          top: 350.0, right: 120.0),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    buildRaisedButton(context, locale, AppLocalizations.of(context).skipButton, () {
                      final TabController controller =
                          DefaultTabController.of(context);
                      if (!controller.indexIsChanging) {
                        controller.animateTo(kImg.length - 1);
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            "home", (Route<dynamic> route) => false);
                      }
                    }),
                    buildRaisedButton(context, locale, AppLocalizations.of(context).nextButton, () {
                      final TabController controller =
                          DefaultTabController.of(context);
                      if (controller.index == kImg.length - 1)
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            "home", (Route<dynamic> route) => false);
                      else
                        controller.animateTo(controller.index + 1);
                    })
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  RaisedButton buildRaisedButton(
      BuildContext context,Locale locale, String text, Function onPressed) {
    return RaisedButton(
      color: Theme.of(context).accentColor,
      textColor: Colors.white,
      child: Text(text, style: TextStyle(fontWeight: locale.languageCode== "ar"?FontWeight.normal:FontWeight.bold),),
      elevation: 10.0,
      onPressed: onPressed,
    );
  }

  Container buildFeatPages(BuildContext context, String path, String text,
      {top = 0.0, bottom = 0.0, left = 0.0, right = 0.0}) {
    return Container(
      padding: EdgeInsets.all(30.0),
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage(path), fit: BoxFit.fill),
      ),
      child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                blurRadius: 50.0,
                color: Theme.of(context).primaryColor.withOpacity(0.2),
              )
            ],
          ),
          child: Stack(
            children: <Widget>[
              Positioned(
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold),
                  ),
                  top: top,
                  bottom: bottom,
                  left: left,
                  right: right)
            ],
          )),
    );
  }
}
