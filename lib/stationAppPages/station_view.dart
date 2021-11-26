import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fuel_app/locale/locale.dart';
import 'package:fuel_app/model/station_api.dart';
import 'package:fuel_app/model/user_api.dart';
import 'package:get_it/get_it.dart';
import 'package:fuel_app/controller/api_services.dart';
import './station_info.dart';
import 'package:geolocator/geolocator.dart';

class StationView extends StatefulWidget {
  final List<Stations> cmpStations;
  final TabController tbCont;
  final User user;
  final GlobalKey<ScaffoldState> scfKey;
  
  const StationView({this.scfKey, this.cmpStations, Key key, this.tbCont, this.user});

  @override
  _StationViewState createState() => _StationViewState();
}

class _StationViewState extends State<StationView> {
  Geolocator location = new Geolocator();
  Future<List<Stations>> stations;
  APIServices get service => GetIt.I<APIServices>();
  Position current;

  Future<Position> getCurrentLocation() async {
    Position position = await location.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return position;
  }

  void getUserCurrentLocation() {
    setState(() {
      current = null;
      getCurrentLocation().then((value) {
        setState(() {
          current = value;
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.cmpStations == null) {
      refreshStationsList();
    }
    getUserCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations lng = AppLocalizations.of(context);
    
    return widget.cmpStations == null
        ? Center(
            child: FutureBuilder(
                future: stations,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                      Text(lng.connErrorMessage),
                      SizedBox(height: 20.0),
                      FlatButton(
                        color: Colors.grey[300],
                      child: Text(lng.tryText),
                      onPressed: refreshStationsList)
                    ]);
                  } else if (snapshot.hasData) {
                    List<Stations> stations = snapshot.data;
                    var separatedStations = [
                      new List<Stations>(),
                      new List<Stations>()
                    ];
                    stations.forEach((station) {
                      station.active
                          ? separatedStations[0].add(station)
                          : separatedStations[1].add(station);
                    });
                    return stationViewBody(lng, separatedStations[0]);
                  } else {
                    return CircularProgressIndicator();
                  }
                }),
          )
        : stationViewBody(lng, widget.cmpStations);
  }

  Widget stationViewBody(AppLocalizations lng, List<Stations> allSts) {
    User user = widget.user;
    StationInfo stationInfoCard = new StationInfo(allSts, user, widget.scfKey);
    StationInfo favStationInfoCard =
        new StationInfo(allSts, user, widget.scfKey, tbCont: widget.tbCont);

    if (allSts.length <= 0)
      return Center(
          child: Text(
        lng.emptyStationList,
        style: TextStyle(fontSize: 16.0, color: Theme.of(context).accentColor),
      ));
    if (current == null) {
      return Center(child: CircularProgressIndicator());
    }
    service.sortByNearestStation(allSts, current, user);
    return Container(
      color: Colors.white,
      child: Stack(alignment: Alignment.bottomRight, children: [
        widget.tbCont == null ? stationInfoCard : favStationInfoCard,
        Padding(
          padding: const EdgeInsets.all(18.0),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: FloatingActionButton(
              elevation: 20.0,
              mini: true,
              onPressed: () async {
                refreshStationsList();
                getUserCurrentLocation();
              },
              child: Icon(Icons.refresh),
            ),
          ),
        ),
      ]),
    );
  }

  Future<Null> refreshStationsList() async {
    var path = widget.tbCont.index == 2
        ? "stations/${widget.user.userId}"
        : "stations";
    setState(() {
      stations = service.fetchStationsData(path);
      print(stations);
    });
    return null;
  }
}
