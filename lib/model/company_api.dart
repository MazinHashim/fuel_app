import 'package:fuel_app/model/station_api.dart';

class CompanyAPI {
  List<Companys> companys;

  CompanyAPI({this.companys});

  CompanyAPI.fromJson(Map<String, dynamic> json) {
    if (json['Companys'] != null) {
      companys = new List<Companys>();
      json['Companys'].forEach((v) {
        companys.add(new Companys.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.companys != null) {
      data['Companys'] = this.companys.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Companys {
  int cmpId;
  String cmpName;
  String password;
  String email;
  String siteLink;
  bool verified;
  List<Stations> stations;

  Companys(
      {this.cmpId,
      this.cmpName,
      this.password,
      this.email,
      this.siteLink,
      this.verified,
      this.stations});

  Companys.fromJson(Map<String, dynamic> json) {
    cmpId = json['cmpId'];
    cmpName = json['cmpName'];
    password = json['password'];
    email = json['email'];
    siteLink = json['siteLink'];
    verified = json['verified'];
    if (json['stations'] != null) {
      stations = new List<Stations>();
      json['stations'].forEach((v) {
        stations.add(new Stations.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cmpId'] = this.cmpId;
    data['cmpName'] = this.cmpName;
    data['password'] = this.password;
    data['email'] = this.email;
    data['siteLink'] = this.siteLink;
    data['verified'] = this.verified;
    if (this.stations != null) {
      data['stations'] = this.stations.map((v) => v.toJson()).toList();
    }
    return data;
  }
}