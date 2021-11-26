import 'package:fuel_app/model/company_api.dart';
import 'package:fuel_app/model/user_api.dart';

class FeedbackAPI {
  int feedId;
  String title;
  String description;
  User user;
  Companys company;

  FeedbackAPI(
      {this.feedId, this.title, this.description, this.user, this.company});

  FeedbackAPI.fromJson(Map<String, dynamic> json) {
    feedId = json['feedId'];
    title = json['title'];
    description = json['description'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    company =
        json['company'] != null ? new Companys.fromJson(json['company']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['feedId'] = this.feedId;
    data['title'] = this.title;
    data['description'] = this.description;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    if (this.company != null) {
      data['company'] = this.company.toJson();
    }
    return data;
  }
}
