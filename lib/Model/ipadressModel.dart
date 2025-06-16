class ipAddressModel {
  String? currectIp;
  String? enteredIp;

  ipAddressModel({this.currectIp, this.enteredIp});

  ipAddressModel.fromJson(Map<String, dynamic> json) {
    currectIp = json['Currect_ip'];
    enteredIp = json['Entered_ip'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Currect_ip'] = this.currectIp;
    data['Entered_ip'] = this.enteredIp;
    return data;
  }
}