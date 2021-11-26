import 'dart:convert';
import 'dart:math' show cos, sqrt, asin;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fuel_app/model/company_api.dart';
import 'package:fuel_app/model/station_api.dart';
import 'package:fuel_app/model/user_api.dart';
import 'package:fuel_app/controller/api_response.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
// import 'package:flutter/services.dart' show rootBundle;

class APIServices {

  static const url = "http://192.168.43.32:8000/api";
  // static const url = "json";

  Future<List<Companys>> fetchCompanysData(String path) async {
    return await http.get(url + "/$path")
    // return rootBundle.loadString(url + "/company.json")
    .then((res) {
      CompanyAPI companyAPI = CompanyAPI.fromJson(jsonDecode('{"Companys":'+res.body+'}'));
      return companyAPI.companys;
    });
  }
  Future<List<Stations>> fetchStationsData(String path, {Map data}) async {
    print(url + "/$path");
    Future<http.Response> method =
        data == null ? http.get(url + "/$path") : http.post(url + "/$path", body: data);
        return method
        // return rootBundle.loadString(url + "/station.json")
        .then((res) {
          
          StationAPI stationAPI = StationAPI.fromJson(jsonDecode('{"Stations":'+res.body+'}'));
          return stationAPI.stations;
        });
  }
  Future<APIResponse<User>> fetchUserData(String path, String email, String password) async {
    return await http.post(url + "/$path", body: {
      "email": email,
      "password": password
    })
    // return rootBundle.loadString(url + "/user.json")
    .then((res) {
      if(res.statusCode == 200){
        User user = User.fromJson(jsonDecode(res.body));
        return APIResponse<User>(data: user);
      }
      return APIResponse<User>(error: true, errorMessage: "An Error Occured");
    }).catchError((_)=> APIResponse<User>(error: true, errorMessage: "An Error Occured"));
  }
  Future<APIResponse<bool>> toggleUserFavorite(String process, String path, int uId, int sId) async {
    print(url + "/$path");
    Future<http.Response> method =
        process == "addFav" ? http.post(url + "/$path/$uId/$sId") : http.delete(url + "/$path/$uId/$sId");
    return await method.then((res) {
      if(res.statusCode == 200){
        return APIResponse<bool>(data: res.body=="true"?true:false);
      }
      return APIResponse<bool>(error: true, errorMessage: "An Error Occured");
    }).catchError((_)=> APIResponse<bool>(error: true, errorMessage: "An Error Occured"));
  }
  Future<APIResponse<bool>> customPatchRequest(String path, Map data) async {
    return await http.put(url + "/$path", headers:{"Content-Type":"application/json"},body: json.encode(data)).then((res) {
      if(res.statusCode == 200){
        return APIResponse<bool>(data: res.body=="true"?true:false);
      }
      return APIResponse<bool>(error: true, errorMessage: "An Error Occured");
    }).catchError((_)=> APIResponse<bool>(error: true, errorMessage: "An Error Occured"));
  }
  Future<APIResponse<bool>> sendFeedback(String path, Map data) async {
    return await http.post(url + "/$path", headers:{"Content-Type":"application/json"},body: json.encode(data)).then((res) {
      if(res.statusCode == 200){
        return APIResponse<bool>(data: res.body=="true"?true:false);
      }
      return APIResponse<bool>(error: true, errorMessage: "An Error Occured");
    }).catchError((_)=> APIResponse<bool>(error: true, errorMessage: "An Error Occured"));
  }

  void sortByNearestStation(
      List<Stations> stations, Position result, User user) {
    stations.removeWhere((station) => station.isQueueFull);

    stations.forEach((station) {
      double distance = calculateDistance(
          station.lat, station.lon, result.latitude, result.longitude);
      station.distance = distance;
      if (user.inQ && station.queuedByUser && station.distance > (300 / 1000)) {
        user.inQ = false;
        station.queuedByUser = false;
        print("${station.distance} ${(60/1000)} ${station.distance > (60 / 1000)}");
      }
    });
    // "lon": 32.544924,
    // "lat": 15.509794,
    stations.sort((a, b) => a.distance.compareTo(b.distance));
  }
  SnackBar showAppMessages(String message){
    return SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.fixed,
      backgroundColor: Color.fromRGBO(18, 35, 100, 1.0).withOpacity(0.5),
    );
  }
  double calculateDistance(lat1, long1, lat2, long2) {
    var p = 0.01745329251;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((long2 - long1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }
}
