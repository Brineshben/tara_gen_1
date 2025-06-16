class CustomerDetailsModel {
  String? status;
  String? message;
  Data? data;

  CustomerDetailsModel({this.status, this.message, this.data});

  CustomerDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  String? username;
  String? sessionId;
  String? gender;
  String? timeStamp;
  String? purpose;
  Robot? robot;
  String? summery;

  Data(
      {this.id,
        this.username,
        this.sessionId,
        this.gender,
        this.timeStamp,
        this.purpose,
        this.robot,
        this.summery});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    sessionId = json['session_id'];
    gender = json['gender'];
    timeStamp = json['time_stamp'];
    purpose = json['purpose'];
    robot = json['robot'] != null ? new Robot.fromJson(json['robot']) : null;
    summery = json['summery'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['session_id'] = this.sessionId;
    data['gender'] = this.gender;
    data['time_stamp'] = this.timeStamp;
    data['purpose'] = this.purpose;
    if (this.robot != null) {
      data['robot'] = this.robot!.toJson();
    }
    data['summery'] = this.summery;
    return data;
  }
}

class Robot {
  int? id;
  String? roboName;
  String? roboId;
  bool? activeStatus;
  String? batteryStatus;
  String? workingTime;
  String? position;
  bool? subscription;
  String? language;
  String? image;
  String? voltage;
  String? current;
  String? power;
  String? energy;

  Robot(
      {this.id,
        this.roboName,
        this.roboId,
        this.activeStatus,
        this.batteryStatus,
        this.workingTime,
        this.position,
        this.subscription,
        this.language,
        this.image,
        this.voltage,
        this.current,
        this.power,
        this.energy});

  Robot.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    roboName = json['robo_name'];
    roboId = json['robo_id'];
    activeStatus = json['active_status'];
    batteryStatus = json['battery_status'];
    workingTime = json['working_time'];
    position = json['position'];
    subscription = json['subscription'];
    language = json['language'];
    image = json['image'];
    voltage = json['voltage'];
    current = json['current'];
    power = json['power'];
    energy = json['energy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['robo_name'] = this.roboName;
    data['robo_id'] = this.roboId;
    data['active_status'] = this.activeStatus;
    data['battery_status'] = this.batteryStatus;
    data['working_time'] = this.workingTime;
    data['position'] = this.position;
    data['subscription'] = this.subscription;
    data['language'] = this.language;
    data['image'] = this.image;
    data['voltage'] = this.voltage;
    data['current'] = this.current;
    data['power'] = this.power;
    data['energy'] = this.energy;
    return data;
  }
}