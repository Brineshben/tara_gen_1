class SessionUpdateIdModel {
  String? status;
  String? latestSessionId;

  SessionUpdateIdModel({this.status, this.latestSessionId});

  SessionUpdateIdModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    latestSessionId = json['latest_session_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['latest_session_id'] = this.latestSessionId;
    return data;
  }
}