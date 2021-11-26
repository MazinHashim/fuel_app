// class FuelStaion {
//   List<Companys> companys;

//   FuelStaion({this.companys});

//   FuelStaion.fromJson(Map<String, dynamic> json) {
//     if (json['Companys'] != null) {
//       companys = new List<Companys>();
//       json['Companys'].forEach((v) {
//         companys.add(new Companys.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.companys != null) {
//       data['Companys'] = this.companys.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class Companys {
//   int cmpId;
//   String cmpName;
//   String cmpPassword;
//   String cmpEmail;
//   List<Complaints> complaints;
//   List<Stations> stations;

//   Companys(
//       {this.cmpId,
//       this.cmpName,
//       this.cmpPassword,
//       this.cmpEmail,
//       this.complaints,
//       this.stations});

//   Companys.fromJson(Map<String, dynamic> json) {
//     cmpId = json['cmp_id'];
//     cmpName = json['cmp_name'];
//     cmpPassword = json['cmp_password'];
//     cmpEmail = json['cmp_email'];
//     if (json['complaints'] != null) {
//       complaints = new List<Complaints>();
//       json['complaints'].forEach((v) {
//         complaints.add(new Complaints.fromJson(v));
//       });
//     }
//     if (json['stations'] != null) {
//       stations = new List<Stations>();
//       json['stations'].forEach((v) {
//         stations.add(new Stations.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['cmp_id'] = this.cmpId;
//     data['cmp_name'] = this.cmpName;
//     data['cmp_password'] = this.cmpPassword;
//     data['cmp_email'] = this.cmpEmail;
//     if (this.complaints != null) {
//       data['complaints'] = this.complaints.map((v) => v.toJson()).toList();
//     }
//     if (this.stations != null) {
//       data['stations'] = this.stations.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class Complaints {
//   int compId;
//   String compTitle;
//   String description;
//   int usrId;

//   Complaints({this.compId, this.compTitle, this.description, this.usrId});

//   Complaints.fromJson(Map<String, dynamic> json) {
//     compId = json['comp_id'];
//     compTitle = json['comp_title'];
//     description = json['description'];
//     usrId = json['usr_id'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['comp_id'] = this.compId;
//     data['comp_title'] = this.compTitle;
//     data['description'] = this.description;
//     data['usr_id'] = this.usrId;
//     return data;
//   }
// }

// class Stations {
//   int id;
//   String name;
//   String isActive;
//   String address;
//   double lon;
//   double lat;
//   double distance;
//   int vecQ;
//   // bool inQueue;
//   bool inQueue = false;
//   bool isQueueFull = false;
//   int qBenz;
//   int qGas;
//   int userId;

//   Stations(
//       {this.id,
//       this.name,
//       this.isActive,
//       this.address,
//       this.lon,
//       this.lat,
//       this.distance,
//       this.vecQ,
//       this.inQueue,
//       this.isQueueFull,
//       this.qBenz,
//       this.qGas,
//       this.userId});

//   Stations.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//     isActive = json['is_active'];
//     address = json['address'];
//     lon = json['lon'];
//     vecQ = json['vecQ'];
//     isQueueFull = json['vecQ'] >= 30;
//     lat = json['lat'];
//     qBenz = json['q_benz'];
//     qGas = json['q_gas'];
//     userId = json['user_id'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['name'] = this.name;
//     data['is_active'] = this.isActive;
//     data['address'] = this.address;
//     data['lon'] = this.lon;
//     data['lat'] = this.lat;
//     data['q_benz'] = this.qBenz;
//     data['q_gas'] = this.qGas;
//     data['user_id'] = this.userId;
//     data['vecQ'] = this.vecQ;
//     return data;
//   }
// }
