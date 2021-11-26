import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fuel_app/Animation/fade_animation.dart';
import 'package:fuel_app/locale/locale.dart';
import 'package:fuel_app/model/station_api.dart';
import 'package:fuel_app/model/user_api.dart';
import 'package:fuel_app/controller/api_services.dart';
import 'package:fuel_app/stationAppPages/Custom_Widgets/app_card.dart';
import 'package:fuel_app/stationAppPages/Custom_Widgets/station_in_map.dart';
import 'package:fuel_app/stationAppPages/StationsInfoSubPages/fuel_quantity.dart';
import 'package:fuel_app/stationAppPages/Custom_Widgets/info_header.dart';
import 'package:fuel_app/stationAppPages/StationsInfoSubPages/info_options.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:map_launcher/map_launcher.dart';

class StationInfo extends StatefulWidget {
  final List<Stations> stations;
  final TabController tbCont;
  final User user;
  final GlobalKey<ScaffoldState> scfKey;

  StationInfo(this.stations, this.user, this.scfKey, {this.tbCont});
  @override
  _StationInfoState createState() => _StationInfoState();
}

class _StationInfoState extends State<StationInfo> {
  StreamSubscription subscription;
  List<Stations> allSts;
  User user;
  Geolocator location = new Geolocator();
  APIServices get service => GetIt.I<APIServices>();
  var path = "Quing";
  String errorMessage;
  bool isLoading = false;
  bool favProgress = false;

  Future<Position> getCurrentLocation() async {
    Position position = await location.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return position;
  }

  void favProgressChange(value, station) {
    setState(() {
      favProgress = value;
      if (station != null) {
        allSts.remove(station);
      }
    });
  }

  @override
  void initState() {
    super.initState();

    allSts = widget.stations;
    user = widget.user;

    if (subscription != null) {
      subscription.cancel();
    }

    subscription =
        location.getPositionStream().distinct().listen((Position position) {
      setState(() {
        service.sortByNearestStation(allSts, position, user);
      });
    });
  }

  @override
  void dispose() {
    if (subscription != null) {
      subscription.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Locale locale = Localizations.localeOf(context);
    final AppLocalizations lng = AppLocalizations.of(context);

    return favProgress
        ? Container(
            height: 200.0, child: Center(child: CircularProgressIndicator()))
        : ListView.builder(
            itemCount: allSts.length,
            itemBuilder: (context, index) {
              Stations station = allSts.elementAt(index);

              return FadeAnimation(
                1000,
                AppCard(
                  locale: locale,
                  margin: EdgeInsets.only(
                      top: 20.0,
                      bottom: 20.0,
                      left: 20.0,
                      right: 20.0), // left: 5.0
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          InfoHeader(
                              locale: locale,
                              name: station.stsName,
                              margin: EdgeInsets.only(top: 20.0)),
                          StationInfoOptions(
                              lng: lng,
                              favProgress: favProgressChange,
                              station: station,
                              scfKey: widget.scfKey,
                              tbCont: widget.tbCont,
                              user: widget.user),
                        ],
                      ),
                      GestureDetector(
                        onTap: () async {
                          await openMapsSheet(context, station);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(top: 10.0, bottom: 5.0),
                          padding: const EdgeInsets.all(10.0),
                          height: 130.0,
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  tileRecord(
                                      "${station.address}", Icons.location_on),
                                  station.distance < 1.0
                                      ? distancesContainer(
                                          "${(station.distance * 1000).toStringAsFixed(0)} m")
                                      : distancesContainer(
                                          "${station.distance.toStringAsFixed(2)} km")
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(right: 10.0),
                                        child: Icon(Icons.directions_car,
                                            size: 25.0),
                                      ),
                                      Text(
                                          "${AppLocalizations.of(context).vehicQ}: ",
                                          style: TextStyle(
                                              fontSize: 12.0,
                                              fontWeight:
                                                  locale.languageCode == "ar"
                                                      ? FontWeight.normal
                                                      : FontWeight.bold)),
                                      Text("${station.vecQ}",
                                          style: TextStyle(
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  Container(
                                    width: 100.0,
                                    height: 25.0,
                                    child: !user.inQ &&
                                            station.distance <= (60 / 1000)
                                        ? FlatButton.icon(
                                            color: Colors.green,
                                            textColor: Colors.white,
                                            onPressed: () {
                                              setState(() {
                                                isLoading = true;
                                                getCurrentLocation()
                                                    .then((value) {
                                                  double ds =
                                                      service.calculateDistance(
                                                          value.latitude,
                                                          value.longitude,
                                                          station.lat,
                                                          station.lon);
                                                  print(ds);
                                                  int nofv = (ds * 1000) ~/ 2;
                                                  changevecQ(
                                                      lng, station, nofv);
                                                  widget.scfKey.currentState
                                                      .showSnackBar(service
                                                          .showAppMessages(lng
                                                              .queuingMessage));
                                                });
                                              });
                                            },
                                            icon: Icon(
                                                !isLoading
                                                    ? Icons.check_circle
                                                    : Icons.bubble_chart,
                                                color: Colors.white,
                                                size: 11.0),
                                            label: Text(
                                                !isLoading
                                                    ? lng.confirmQtxt
                                                    : lng.loadingtxt,
                                                style: TextStyle(
                                                    fontSize: 10.0,
                                                    fontWeight:
                                                        locale.languageCode ==
                                                                "ar"
                                                            ? FontWeight.normal
                                                            : FontWeight.bold)))
                                        : Icon(Icons.check_circle,
                                            color: Colors.grey, size: 15.0),
                                  ),
                                ],
                              ),
                              Divider(
                                  height: 0.0,
                                  color: Theme.of(context).primaryColor),
                              Padding(
                                  padding: locale.languageCode.contains('ar')
                                      ? const EdgeInsets.only(
                                          left: 50.0, right: 7.0)
                                      : const EdgeInsets.only(
                                          right: 50.0, left: 7.0),
                                  child: FuelQuantitysWidget(
                                      locale: locale,
                                      lng: lng,
                                      station: station))
                            ],
                          ),
                        ),
                        // contentPadding: EdgeInsets.all(10.0)
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }

  void changevecQ(AppLocalizations lng, Stations sts, int nofv) async {
    service.customPatchRequest(path, {"stsId": sts.stsId, "Vec_Q": nofv}).then(
        (response) {
      if (response.error) {
        errorMessage = response.errorMessage ?? lng.publicError;
        // Show SnackBar Message;
        print("$errorMessage");
      } else {
        sts.queuedByUser = true;
        sts.vecQ = nofv;
        user.inQ = true;
        // subscription.cancel();

        print("${response.data}");
      }
      setState(() {
        isLoading = false;
      });
    });
  }

  Future openMapsSheet(BuildContext context, Stations station) async {
    try {
      final availableMaps = await MapLauncher.installedMaps;
      availableMaps.add(AvailableMap(
          mapType: MapType.google,
          mapName: "Facily Map",
          icon: AssetImage("images/logo.png")));

      showModalBottomSheet(
          context: context,
          builder: (BuildContext context) => SafeArea(
                child: SingleChildScrollView(
                  child: Container(
                    child: Wrap(
                      children: availableMaps
                          .map((map) => ListTile(
                              onTap: () {
                                map.mapName == "Facily Map"
                                    ? Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                StationGoogleMap(
                                                    stsInfo: station)))
                                    : map.showDirections(
                                        destination:
                                            Coords(station.lat, station.lon),
                                        destinationTitle: station.stsName);
                              },
                              title: Text(map.mapName,
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              leading: Image(
                                  image: map.icon, height: 40.0, width: 40.0)))
                          .toList(),
                    ),
                  ),
                ),
              ));
    } catch (e) {
      print(e);
    }
  }

  Container distancesContainer(String text) => Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(width: 1.0)),
        padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
        child: Text(text,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10.0)),
      );
  Row tileRecord(String title, IconData icon) => Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: Icon(icon, size: 25.0),
          ),
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0),
          ),
        ],
      );
}
