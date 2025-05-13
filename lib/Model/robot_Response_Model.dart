class RobotResponseModel {
  String? status;
  Data? data;
  String? text;

  RobotResponseModel({this.status, this.data, this.text});

  RobotResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['text'] = this.text;
    return data;
  }
}

class Data {
  bool? listening;
  bool? waiting;
  bool? speaking;

  Data({this.listening, this.waiting, this.speaking});

  Data.fromJson(Map<String, dynamic> json) {
    listening = json['listening'];
    waiting = json['waiting'];
    speaking = json['speaking'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['listening'] = this.listening;
    data['waiting'] = this.waiting;
    data['speaking'] = this.speaking;
    return data;
  }
}
