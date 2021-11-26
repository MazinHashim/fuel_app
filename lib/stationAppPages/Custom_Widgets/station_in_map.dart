import 'package:flutter/material.dart';
import 'package:fuel_app/locale/locale.dart';
import 'package:fuel_app/model/station_api.dart';
import 'package:fuel_app/controller/api_services.dart';
import 'package:fuel_app/model/sts_serv_api.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class StationGoogleMap extends StatefulWidget {
  final Stations stsInfo;

  StationGoogleMap({@required this.stsInfo});

  @override
  _StationGoogleMapState createState() => _StationGoogleMapState();
}

class _StationGoogleMapState extends State<StationGoogleMap> {
  GoogleMapController controller;
  Set<Marker> _marker = new Set<Marker>();
  Position currentLocation;
  Stations currentStation;
  bool mapProgress = false;
  var path = "stations";
  var companys;
  APIServices get service => GetIt.I<APIServices>();
  PageController _pageController;

  Future<Position> getCurrentLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return position;
  }

  void getUserCurrentLocation() {
    setState(() {
      currentLocation = null;
      getCurrentLocation().then((value) {
        setState(() {
          currentLocation = value;
          mapProgress = true;
          addStationsMarkers();
          _marker.add(Marker(
              markerId: MarkerId("currLoc"),
              infoWindow: InfoWindow(title: "Current Location"),
              position:
                  LatLng(currentLocation.latitude, currentLocation.longitude)));
        });
      });
    });
  }

  addStationsMarkers() {
    service.fetchStationsData(path).then((stations) {
      stations.forEach((station) {
        initMarker(station);
      });
    });
  }

  initMarker(Stations station) {
    _marker.add(new Marker(
        markerId: MarkerId(station.stsId.toString()),
        onTap: (){
          setState(() {
            currentStation = station;
          });
        },
        position: LatLng(station.lat, station.lon),
        infoWindow: InfoWindow(title: station.stsName)));

    _pageController = PageController(initialPage: 1, viewportFraction: 0.8);
  }
  @override
  void initState() {
    super.initState();
    currentStation = widget.stsInfo;
    getUserCurrentLocation();
  }

  _servicesList(int index, AppLocalizations lng) {
    Services serv = currentStation.services.elementAt(index);
    return AnimatedBuilder(
        animation: _pageController,
        builder: (BuildContext context, Widget widget) {
          double value = 1;
          if(_pageController.position.haveDimensions){
            value = _pageController.page - index;
            value = (1 - (value.abs() * 0.3) + 0.6).clamp(0.0, 1.0);
          }
          return Center(
            child: SizedBox(
              height: Curves.easeInOut.transform(value) * 125.0,
              width: Curves.easeInOut.transform(value) * 350.0,
              child: widget,
            )
          );
       },
       child: Stack(
         children: <Widget>[
           Center(
             child: Container(
               margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20.0),
               height: 125.0,
               width: 275.0,
               decoration: BoxDecoration(
                 borderRadius: BorderRadius.circular(10.0),
                 boxShadow: [
                   BoxShadow(
                     color: Colors.black54,
                     offset: Offset(0.0, 4.0),
                     blurRadius: 10.0    
                   )
                 ]
               ),
               child: Container(
                 decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white
                 ),
                 child: Column(children: <Widget>[
                   ExpansionTile(
                      title: Text("${serv.servName}", style: TextStyle(fontWeight: FontWeight.bold)),
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40.0, vertical: 20.0),
                          child: Text(
                              "${serv.description} \n\nThe service price: ${serv.price} SD", style: TextStyle(fontWeight: FontWeight.bold)),
                        )
                      ],
                      subtitle:
                          Text("${serv.description.substring(0, 5)}...",style: TextStyle(fontSize: 8.0, fontWeight: FontWeight.bold)),
                      trailing: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              border: Border.all(width: 1.0)),
                          padding: EdgeInsets.symmetric(
                              horizontal: 6.0, vertical: 4.0),
                          child: Text("${serv.price} ${lng.sdtxt}",
                              style: TextStyle(fontSize: 8.0, fontWeight: FontWeight.bold))),
                      leading: Icon(Icons.room_service),
                    ),
                 ]),
               ),
             )
           )
         ],
       ),
      );
  }

  @override
  Widget build(BuildContext context) {

    final AppLocalizations lng = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.stsInfo.stsName}"),
      ),
      body: mapProgress
          ? Stack(
              children: <Widget>[
                GoogleMap(
                  onMapCreated: onMapCreated,
                  markers: _marker,
                  initialCameraPosition: CameraPosition(
                      target: LatLng(
                          currentLocation.latitude, currentLocation.longitude),
                      zoom: 16.0),
                ),
                Positioned(
                  bottom: 20.0,
                  child: Container(
                    height: 200.0,
                    width: MediaQuery.of(context).size.width,
                    child: PageView.builder(
                        controller: _pageController,
                        itemCount: widget.stsInfo.services.length,
                        itemBuilder: (BuildContext context, int index) {
                          return _servicesList(index,lng);
                        }),
                  ),
                )
              ],
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.gps_fixed,
          color: Colors.black,
        ),
        backgroundColor: Colors.grey[200],
        onPressed: () {
          controller.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(
                  target: LatLng(
                      currentLocation.latitude, currentLocation.longitude),
                  zoom: 16.0)));
        },
      ),
    );
  }

  void onMapCreated(GoogleMapController controller) {
    setState(() {
      this.controller = controller;
    });
  }
}
