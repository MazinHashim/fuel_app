import 'package:fuel_app/model/sts_serv_api.dart';

class StationAPI {
  List<Stations> stations;

  StationAPI({this.stations});

  StationAPI.fromJson(Map<String, dynamic> json) {
    if (json['Stations'] != null) {
      stations = new List<Stations>();
      json['Stations'].forEach((v) {
        stations.add(new Stations.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.stations != null) {
      data['Stations'] = this.stations.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Stations {
  int stsId;
  String stsName;
  String password;
  String address;
  bool isQueueFull;
  bool queuedByUser;
  double distance;
  int vecQ;
  double lon;
  double lat;
  int benzinQ;
  int gasQ;
  bool verified;
  List<Services> services;
  bool active;

  Stations(
      {this.stsId,
      this.stsName,
      this.password,
      this.address,
      this.isQueueFull,
      this.queuedByUser,
      this.distance,
      this.vecQ,
      this.lon,
      this.lat,
      this.benzinQ,
      this.gasQ,
      this.verified,
      this.services,
      this.active});

  Stations.fromJson(Map<String, dynamic> json) {
    print(json["vec_Q"]);
    stsId = json['stsId'];
    stsName = json['stsName'];
    password = json['password'];
    address = json['address'];
    vecQ = json['vec_Q'];
    isQueueFull = json['vec_Q'] >= 200;
    queuedByUser = false;
    lon =  json['lon'];
    lat = json['lat'];
    benzinQ = json['benzinQ'];
    gasQ = json['gasQ'];
    verified = json['verified'];
    if (json['services'] != null) {
      services = new List<Services>();
      json['services'].forEach((v) {
        services.add(new Services.fromJson(v));
      });
    }
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['stsId'] = this.stsId;
    data['stsName'] = this.stsName;
    data['password'] = this.password;
    data['address'] = this.address;
    data['vec_Q'] = this.vecQ;
    data['lon'] = this.lon;
    data['lat'] = this.lat;
    data['benzinQ'] = this.benzinQ;
    data['gasQ'] = this.gasQ;
    data['verified'] = this.verified;
    if (this.services != null) {
      data['services'] = this.services.map((v) => v.toJson()).toList();
    }
    data['active'] = this.active;
    return data;
  }
}
