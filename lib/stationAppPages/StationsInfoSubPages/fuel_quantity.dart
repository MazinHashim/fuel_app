import 'package:flutter/material.dart';
import 'package:fuel_app/locale/locale.dart';
import 'package:fuel_app/model/station_api.dart';

class FuelQuantitysWidget extends StatelessWidget {
  const FuelQuantitysWidget({
    @required this.lng,
    @required this.station,
    @required this.locale,
  });

  final AppLocalizations lng;
  final Locale locale;
  final Stations station;


  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(children: <Widget>[
          Icon(Icons.local_gas_station, size: 25.0),
          Text("${lng.benzinText} :  ",
              style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: locale.languageCode == "ar"
                      ? FontWeight.normal
                      : FontWeight.bold)),
          Text(
              station.benzinQ == 0
                  ? "-EMPTY-"
                  : station.benzinQ == 100 ? "-FULL-" : "${station.benzinQ}%",
              style: TextStyle(
                  color: station.benzinQ >= 50
                      ? Colors.green[800]
                      : Colors.red[800],
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold))
        ]),
        Row(children: <Widget>[
          Text("${lng.gasText} :  ",
              style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: locale.languageCode == "ar"
                      ? FontWeight.normal
                      : FontWeight.bold)),
          Text(
              station.gasQ == 0
                  ? "-EMPTY-"
                  : station.gasQ == 100 ? "-FULL-" : "${station.gasQ}%",
              style: TextStyle(
                  color:
                      station.gasQ >= 50 ? Colors.green[800] : Colors.red[800],
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold))
        ]),
        Container()
      ],
    );
  }
}
