class BatteryModel {
  String? status;
  List<Data>? data;

  BatteryModel({this.status, this.data});

  BatteryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    final dataList = json['data'] as List?;
    if (dataList == null || dataList.isEmpty) {
      throw Exception('No data found');
    } else {
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
  Robot? robot;
  User? user;
  String? date;
  String? endDate;
  String? maintenanceHours;

  Data(
      {this.id,
      this.robot,
      this.user,
      this.date,
      this.endDate,
      this.maintenanceHours});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    robot = json['robot'] != null ? new Robot.fromJson(json['robot']) : null;
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    date = json['date'];
    endDate = json['end_date'];
    maintenanceHours = json['maintenance_hours'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.robot != null) {
      data['robot'] = this.robot!.toJson();
    }
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['date'] = this.date;
    data['end_date'] = this.endDate;
    data['maintenance_hours'] = this.maintenanceHours;
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
  Null? image;
  String? voltage;
  String? current;
  String? power;
  String? energy;
  String? quality;
  bool? map;
  bool? emergencyStop;
  bool? motorBrakeReleased;
  bool? readyToNavigate;
  bool? charging;
  String? dockingStatus;

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
      this.energy,
      this.quality,
      this.map,
      this.emergencyStop,
      this.motorBrakeReleased,
      this.readyToNavigate,
      this.charging,
      this.dockingStatus});

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
    quality = json['quality'];
    map = json['map'];
    emergencyStop = json['emergency_stop'];
    motorBrakeReleased = json['motor_brake_released'];
    readyToNavigate = json['ready_to_navigate'];
    charging = json['charging'];
    dockingStatus = json['dockingStatus'];
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
    data['quality'] = this.quality;
    data['map'] = this.map;
    data['emergency_stop'] = this.emergencyStop;
    data['motor_brake_released'] = this.motorBrakeReleased;
    data['ready_to_navigate'] = this.readyToNavigate;
    data['charging'] = this.charging;
    data['dockingStatus'] = this.dockingStatus;
    return data;
  }
}

class User {
  int? id;
  String? username;
  String? email;
  int? phoneNumber;
  String? profilePic;
  String? role;
  int? secretKey;

  User(
      {this.id,
      this.username,
      this.email,
      this.phoneNumber,
      this.profilePic,
      this.role,
      this.secretKey});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    phoneNumber = json['phone_number'];
    profilePic = json['profile_pic'];
    role = json['role'];
    secretKey = json['secret_key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['email'] = this.email;
    data['phone_number'] = this.phoneNumber;
    data['profile_pic'] = this.profilePic;
    data['role'] = this.role;
    data['secret_key'] = this.secretKey;
    return data;
  }
}
