class Services {
  int servId;
  String servName;
  String description;
  int price;

  Services({this.servId, this.servName, this.description, this.price});

  Services.fromJson(Map<String, dynamic> json) {
    servId = json['servId'];
    servName = json['servName'];
    description = json['description'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['servId'] = this.servId;
    data['servName'] = this.servName;
    data['description'] = this.description;
    data['price'] = this.price;
    return data;
  }
}