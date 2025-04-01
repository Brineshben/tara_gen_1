class navigationSubmit {
  List<int>? navigations;

  navigationSubmit({this.navigations});

  navigationSubmit.fromJson(Map<String, dynamic> json) {
    navigations = json['navigations'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['navigations'] = this.navigations;
    return data;
  }
}