class NavigationListModel {
  String? status;
  String? message;
  List<NavigationData>? data;

  NavigationListModel({this.status, this.message, this.data});

  NavigationListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <NavigationData>[];
      json['data'].forEach((v) {
        data!.add(new NavigationData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NavigationData {
  int? id;
  int? user;
  String? navId;
  String? name;

  NavigationData({this.id, this.user, this.navId, this.name});

  NavigationData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'];
    navId = json['nav_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user'] = this.user;
    data['nav_id'] = this.navId;
    data['name'] = this.name;
    return data;
  }
}