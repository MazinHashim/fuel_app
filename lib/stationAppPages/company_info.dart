import 'package:flutter/material.dart';
import 'package:fuel_app/Animation/fade_animation.dart';
import 'package:fuel_app/locale/locale.dart';
import 'package:fuel_app/model/company_api.dart';
import 'package:fuel_app/model/user_api.dart';
import 'package:fuel_app/stationAppPages/Custom_Widgets/app_card.dart';
import 'package:fuel_app/stationAppPages/Custom_Widgets/info_header.dart';
import 'package:fuel_app/stationAppPages/station_note.dart';
import 'package:url_launcher/url_launcher.dart';

class CompanyInfo extends StatefulWidget {
  final Companys company;
  final User user;
  CompanyInfo(this.company, this.user);
  @override
  _CompanyInfoState createState() => _CompanyInfoState();
}

class _CompanyInfoState extends State<CompanyInfo> {
  List<int> count = [0, 0];

  @override
  void initState() {
    super.initState();

    widget.company.stations.forEach((station) {
      station.active ? count[0]++ : count[1]++;
    });
  }

  @override
  Widget build(BuildContext context) {
    Locale locale = Localizations.localeOf(context);
    AppLocalizations lng = AppLocalizations.of(context);

    return FadeAnimation(
      1000,
      AppCard(
        locale: locale,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            InfoHeader(locale: locale, name: widget.company.cmpName),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                InkWell(
                  child: Icon(Icons.open_in_browser,
                      size: 20.0, color: Theme.of(context).primaryColor),
                  onTap: () async {
                    await canLaunch(widget.company.siteLink)?await launch(widget.company.siteLink):throw "Cannot Open This URL";
                  },
                ),
                InkWell(
                  child: Icon(Icons.feedback,
                      size: 20.0, color: Theme.of(context).primaryColor),
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => StationNoteWidget(
                          widget.company, widget.user))),
                ),
              ],
            ),
            Divider(height: 0.0, color: Theme.of(context).primaryColor),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                tileRecord(
                    "${count[0]} ${lng.activeText}",
                    Icon(Icons.ev_station,
                        size: 20.0, color: Theme.of(context).accentColor),
                    Theme.of(context).accentColor),
                tileRecord("${count[1]} ${lng.inActiveText}",
                    Icon(Icons.ev_station, size: 20.0, color: Colors.black)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  tileRecord(String title, Icon icon, [Color color = Colors.black]) => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          icon,
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold ,fontSize: 10.0, color: color),
          ),
        ],
      );
}
