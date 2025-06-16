class EnquiryListModel {
  String? status;
  String? message;
  List<Data>? data;

  EnquiryListModel({this.status, this.message, this.data});

  EnquiryListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
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

class Data {
  int? id;
  int? user;
  String? logo;
  String? heading;

  Data({this.id, this.user, this.logo, this.heading});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'];
    logo = json['logo'];
    heading = json['heading'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user'] = this.user;
    data['logo'] = this.logo;
    data['heading'] = this.heading;
    return data;
  }
}