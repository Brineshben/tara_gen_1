class volume_model {
  String? message;
  String? roboId;
  int? currentVolume;

  volume_model({this.message, this.roboId, this.currentVolume});

  volume_model.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    roboId = json['robo_id'];
    currentVolume = json['current_volume'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['robo_id'] = this.roboId;
    data['current_volume'] = this.currentVolume;
    return data;
  }
}