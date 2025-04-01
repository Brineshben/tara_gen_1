class BackgroundModel {
  String? status;
  int? userId;
  String? backgroundImage;

  BackgroundModel({this.status, this.userId, this.backgroundImage});

  BackgroundModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    userId = json['user_id'];
    backgroundImage = json['background_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['user_id'] = this.userId;
    data['background_image'] = this.backgroundImage;
    return data;
  }
}