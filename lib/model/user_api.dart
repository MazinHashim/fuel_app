class User {
  int userId;
  String username;
  String token;
  String password;
  String email;
  bool inQ;
  bool verified;

  User(
      {this.userId,
      this.username,
      this.token,
      this.password,
      this.email,
      this.inQ,
      this.verified});

  User.fromJson(Map<String, dynamic> json) {
    userId = json['id'];
    username = json['name'];
    token = json['token'];
    password = json['password'];
    email = json['email'];
    inQ = json['in_Q'];
    verified = json['verified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.userId;
    data['name'] = this.username;
    data['token'] = this.token;
    data['password'] = this.password;
    data['email'] = this.email;
    data['in_Q'] = this.inQ;
    data['verified'] = this.verified;
    return data;
  }

  List<String> toList() {
    List<String> data = new List<String>();
    data.add(this.userId.toString());
    data.add(this.username);
    data.add(this.token);
    data.add(this.password);
    data.add(this.email);
    data.add(this.inQ.toString());
    data.add(this.verified.toString());

    return data;
  }
}
