import 'package:flutter/material.dart';
import 'package:fuel_app/Animation/fade_animation.dart';
import 'package:fuel_app/locale/locale.dart';
import 'package:fuel_app/model/station_api.dart';
import 'package:fuel_app/model/sts_serv_api.dart';

class StationServicesWidget extends StatefulWidget {
  final Stations stsInfo;
  StationServicesWidget({Key key, this.stsInfo}) : super(key: key);

  @override
  _StationServicesWidgetState createState() => _StationServicesWidgetState();
}

class _StationServicesWidgetState extends State<StationServicesWidget> {
  @override
  Widget build(BuildContext context) {
    final Locale locale = Localizations.localeOf(context);
    final AppLocalizations lng = AppLocalizations.of(context);
    
    Stations sts = widget.stsInfo;
    return Scaffold(
      appBar: AppBar(title: Text(sts.stsName)),
      body: ListView.builder(
          itemCount: sts.services.length,
          itemBuilder: (context, index) {
            Services service = sts.services.elementAt(index);

            return FadeAnimation(
              1000,
              Container(
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Theme.of(context).primaryColor, width: 0.5),
                    borderRadius: BorderRadius.circular(7.0),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color:
                              Color.fromRGBO(18, 35, 100, 1.0).withOpacity(0.2),
                          blurRadius: 15.0,
                          offset: locale.languageCode.contains('ar')
                              ? Offset(-3.0, 5.0)
                              : Offset(3.0, 5.0))
                    ]),
                margin: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ExpansionTile(
                      title: Text("${service.servName}", style: TextStyle(fontWeight: FontWeight.bold)),
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40.0, vertical: 20.0),
                          child: Text(
                              "${service.description} \n\nThe service price: ${service.price} SD", style: TextStyle(fontWeight: FontWeight.bold)),
                        )
                      ],
                      subtitle:
                          Text("${service.description.substring(0, 5)}...",style: TextStyle(fontSize: 8.0, fontWeight: FontWeight.bold)),
                      trailing: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              border: Border.all(width: 1.0)),
                          padding: EdgeInsets.symmetric(
                              horizontal: 6.0, vertical: 4.0),
                          child: Text("${service.price} ${lng.sdtxt}",
                              style: TextStyle(fontSize: 8.0, fontWeight: FontWeight.bold))),
                      leading: Icon(Icons.room_service),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
