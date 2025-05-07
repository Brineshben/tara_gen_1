class DescriptionModel {
  String? status;
  List<Data>? data;

  DescriptionModel({this.status, this.data});

  DescriptionModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
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
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  String? timeOfDay;
  String? timeOfDayDisplay;
  String? description;

  Data({this.id, this.timeOfDay, this.timeOfDayDisplay, this.description});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    timeOfDay = json['time_of_day'];
    timeOfDayDisplay = json['time_of_day_display'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['time_of_day'] = this.timeOfDay;
    data['time_of_day_display'] = this.timeOfDayDisplay;
    data['description'] = this.description;
    return data;
  }
}
