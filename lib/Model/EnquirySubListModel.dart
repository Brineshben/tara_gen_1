class EnquirySubListModel {
  int? id;
  int? enquiry;
  EnquiryDetails? enquiryDetails;
  String? subheading;

  EnquirySubListModel(
      {this.id, this.enquiry, this.enquiryDetails, this.subheading});

  EnquirySubListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    enquiry = json['enquiry'];
    enquiryDetails = json['enquiry_details'] != null
        ? new EnquiryDetails.fromJson(json['enquiry_details'])
        : null;
    subheading = json['subheading'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['enquiry'] = this.enquiry;
    if (this.enquiryDetails != null) {
      data['enquiry_details'] = this.enquiryDetails!.toJson();
    }
    data['subheading'] = this.subheading;
    return data;
  }
}

class EnquiryDetails {
  int? id;
  int? user;
  String? logo;
  String? heading;

  EnquiryDetails({this.id, this.user, this.logo, this.heading});

  EnquiryDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'];
    logo = json['logo'];
    heading = json['heading'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user'] = this.user;
    data['logo'] = this.logo;
    data['heading'] = this.heading;
    return data;
  }
}