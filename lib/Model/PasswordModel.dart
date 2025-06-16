class PasswordModel {
  String? status;
  String? message;
  int? userId;
  String? role;

  PasswordModel({this.status, this.message, this.userId, this.role});

  PasswordModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    userId = json['user_id'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['user_id'] = this.userId;
    data['role'] = this.role;
    return data;
  }
}