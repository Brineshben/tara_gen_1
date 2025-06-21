class OfflineBatteryModel {
  String? status;
  Data? data;

  OfflineBatteryModel({this.status, this.data});

  OfflineBatteryModel.fromJson(Map<String, dynamic> json) {
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
  String? batteryStatus;

  Data({this.batteryStatus});

  Data.fromJson(Map<String, dynamic> json) {
    batteryStatus = json['battery_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['battery_status'] = this.batteryStatus;
    return data;
  }
}
