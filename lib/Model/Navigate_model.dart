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
  String? name;
  String? name1;
  String? description;
  String? video;

  NavigationData(
      {this.id, this.name, this.description, this.video, this.name1});

  NavigationData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    name1 = json['name1'];
    description = json['description'];
    video = json['video'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['name1'] = this.name1;
    data['description'] = this.description;
    data['video'] = this.video;
    return data;
  }
}
