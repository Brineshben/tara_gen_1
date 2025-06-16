class BatteryofflineModel {
  String? status;
  Data? data;

  BatteryofflineModel({this.status, this.data});

  BatteryofflineModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  RB3? rB3;

  Data({this.rB3});

  Data.fromJson(Map<String, dynamic> json) {
    rB3 = json['RB3'] != null ? new RB3.fromJson(json['RB3']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.rB3 != null) {
      data['RB3'] = this.rB3!.toJson();
    }
    return data;
  }
}

class RB3 {
  String? batteryStatus;

  RB3({this.batteryStatus});

  RB3.fromJson(Map<String, dynamic> json) {
    batteryStatus = json['battery_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['battery_status'] = this.batteryStatus;
    return data;
  }
}