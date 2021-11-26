import 'package:flutter/material.dart';
import 'package:fuel_app/locale/locale.dart';
import 'package:fuel_app/model/station_api.dart';
import 'package:fuel_app/model/user_api.dart';
import 'package:fuel_app/controller/api_services.dart';
import 'package:fuel_app/stationAppPages/station_services.dart';
import 'package:get_it/get_it.dart';

class StationInfoOptions extends StatefulWidget {
  const StationInfoOptions({
    Key key,
    @required this.lng,
    @required this.station,
    @required this.user,
    @required this.scfKey,
    @required this.tbCont,
    @required this.favProgress
  }) : super(key: key);

  final AppLocalizations lng;
  final Stations station;
  final TabController tbCont;
  final Function favProgress;
  final User user;
  final GlobalKey<ScaffoldState> scfKey;

  @override
  _StationInfoOptionsState createState() => _StationInfoOptionsState();
}

class _StationInfoOptionsState extends State<StationInfoOptions> {
  String errorMessage;
  APIServices get service => GetIt.I<APIServices>();

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
        elevation: 20.0,
        onSelected: (String value) {
          if (widget.lng.showServices.compareTo(value) == 0) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    StationServicesWidget(stsInfo: widget.station)));
          } else if (widget.lng.addFavPopup.compareTo(value) == 0) {
            toggleFavorite(
                context, "addFav", widget.user.userId, widget.station);
            if (widget.tbCont != null) {
              if (!widget.tbCont.indexIsChanging) {
                widget.tbCont.animateTo(2);
              }
            }
          } else if (widget.lng.removeFavPopup .compareTo(value) == 0) {
            widget.favProgress(true, null);
            toggleFavorite(
                context, "RemoveFromFav", widget.user.userId, widget.station);
          }
        },
        itemBuilder: (BuildContext context) {
          String toggle = "";
          if (widget.tbCont != null)
            toggle = widget.tbCont.index == 2
                ? widget.lng.removeFavPopup
                : widget.lng.addFavPopup;
          else
            toggle = widget.lng.addFavPopup;
          return <String>[
            toggle,
            widget.lng.showServices
          ].map<PopupMenuItem<String>>((String value) {
            return PopupMenuItem(
              child: Text(value),
              value: value,
              textStyle: TextStyle(
                  fontSize: 15.0,
                  color: Theme.of(context).accentColor,
                  textBaseline: TextBaseline.alphabetic),
            );
          }).toList();
        });
  }

  void toggleFavorite(
      BuildContext context, String process, int uId, Stations station) async {
    service
        .toggleUserFavorite(process, "$process", uId, station.stsId)
        .then((response) {
      if (response.error) {
        errorMessage = response.errorMessage ?? widget.lng.publicError;
        // Show SnackBar Message;
        // ممكن المحطة تكون مضافة إلى المفضلة مسبقا
        widget.scfKey.currentState.showSnackBar(service.showAppMessages("$errorMessage"));
      } else {
        // Show SnackBar Success Message;
        if (process == "addFav") {
          widget.favProgress(false, station);
          widget.scfKey.currentState.showSnackBar(service.showAppMessages(
              "${station.stsName} ${widget.lng.remFavMessage}"));
        } else {
          widget.scfKey.currentState.showSnackBar(service.showAppMessages(
              "${station.stsName} ${widget.lng.addedFavMessage}"));
        }
      }
    });
  }
}
