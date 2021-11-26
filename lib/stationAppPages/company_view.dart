import 'package:flutter/material.dart';
import 'package:fuel_app/locale/locale.dart';
import 'package:fuel_app/model/company_api.dart';
import 'package:fuel_app/model/station_api.dart';
import 'package:fuel_app/model/user_api.dart';
import 'package:get_it/get_it.dart';
import 'package:fuel_app/controller/api_services.dart';
import 'package:fuel_app/stationAppPages/station_view.dart';
import './company_info.dart';

class CompanyView extends StatefulWidget {
  final User user;
  CompanyView({this.user});

  @override
  _CompanyViewState createState() => _CompanyViewState();
}

class _CompanyViewState extends State<CompanyView> {
  var path = "companys";
  var companys;

  APIServices get service => GetIt.I<APIServices>();

  List<Stations> allSts;

  @override
  void initState() {
    super.initState();
    refreshCompanyList();
  }

  @override
  Widget build(BuildContext context) {

    final AppLocalizations lng = AppLocalizations.of(context);

    return Center(
      child: FutureBuilder(
          future: companys,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Text(lng.connErrorMessage),
                SizedBox(height: 20.0),
                FlatButton(
                  color: Colors.grey[300],
                    child: Text(lng.tryText), onPressed: refreshCompanyList)
              ]);
            } else if (snapshot.hasData) {
              List<Companys> companys = snapshot.data;

              return Container(
                color: Colors.white,
                child: Stack(alignment: Alignment.bottomRight, children: [
                  GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2),
                      itemCount: companys.length,
                      itemBuilder: (BuildContext context, index) {
                        Companys company = companys.elementAt(index);
                        return GestureDetector(
                          child: CompanyInfo(company, widget.user),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CompanyStationsView(
                                        company, widget.user)));
                          },
                        );
                      }),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: FloatingActionButton(
                        elevation: 20.0,
                        mini: true,
                        onPressed: () async {
                          refreshCompanyList();
                        },
                        child: Icon(Icons.refresh),
                      ),
                    ),
                  ),
                ]),
              );
            } else {
              return CircularProgressIndicator();
            }
          }),
    );
  }

  Future<Null> refreshCompanyList() async {
    setState(() {
      companys = service.fetchCompanysData(path);
    });

    return null;
  }
}

class CompanyStationsView extends StatelessWidget {
  final Companys company;
  final User user;

  CompanyStationsView(this.company, this.user);

  @override
  Widget build(BuildContext context) {
    var separatedStations = [new List<Stations>(), new List<Stations>()];
    company.stations.forEach((station) {
      station.active
          ? separatedStations[0].add(station)
          : separatedStations[1].add(station);
    });
    return Scaffold(
        appBar: AppBar(
          title: Text("${company.cmpName}"),
        ),
        body: Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: company.stations == null
                ? Center(child: CircularProgressIndicator())
                : StationView(
                    cmpStations: separatedStations[0],
                    user: user,
                  )));
  }
}
