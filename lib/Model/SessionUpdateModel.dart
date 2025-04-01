class SessionUpdateModel {
  String? status;
  String? message;
  String? sessionId;

  SessionUpdateModel({this.status, this.message, this.sessionId});

  SessionUpdateModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    sessionId = json['session_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['session_id'] = this.sessionId;
    return data;
  }
}