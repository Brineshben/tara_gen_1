class SubEnquirydetailsModel {
  String? status;
  String? message;
  Data? data;

  SubEnquirydetailsModel({this.status, this.message, this.data});

  SubEnquirydetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  String? heading;
  String? description;
  Null image;
  Null otherHeadings;
  Subheading? subheading;

  Data(
      {this.id,
        this.heading,
        this.description,
        this.image,
        this.otherHeadings,
        this.subheading});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    heading = json['heading'];
    description = json['description'];
    image = json['image'];
    otherHeadings = json['other_headings'];
    subheading = json['subheading'] != null
        ? new Subheading.fromJson(json['subheading'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['heading'] = this.heading;
    data['description'] = this.description;
    data['image'] = this.image;
    data['other_headings'] = this.otherHeadings;
    if (this.subheading != null) {
      data['subheading'] = this.subheading!.toJson();
    }
    return data;
  }
}

class Subheading {
  int? id;
  int? enquiry;
  EnquiryDetails? enquiryDetails;
  String? subheading;

  Subheading({this.id, this.enquiry, this.enquiryDetails, this.subheading});

  Subheading.fromJson(Map<String, dynamic> json) {
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