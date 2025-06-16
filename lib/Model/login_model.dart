class LoginModel {
  String? status;
  String? message;
  String? refreshToken;
  String? accessToken;
  String? expiresIn;
  User? user;

  LoginModel(
      {this.status,
        this.message,
        this.refreshToken,
        this.accessToken,
        this.expiresIn,
        this.user});

  LoginModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    refreshToken = json['refresh_token'];
    accessToken = json['access_token'];
    expiresIn = json['expires_in'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['refresh_token'] = this.refreshToken;
    data['access_token'] = this.accessToken;
    data['expires_in'] = this.expiresIn;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  String? username;
  String? email;
  String? profilePic;
  String? role;
  int? phoneNo;
  int? secretKey;

  User(
      {this.id,
        this.username,
        this.email,
        this.profilePic,
        this.role,
        this.phoneNo,
        this.secretKey});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    profilePic = json['profile_pic'];
    role = json['role'];
    phoneNo = json['phone_no'];
    secretKey = json['secret_key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['email'] = this.email;
    data['profile_pic'] = this.profilePic;
    data['role'] = this.role;
    data['phone_no'] = this.phoneNo;
    data['secret_key'] = this.secretKey;
    return data;
  }
}