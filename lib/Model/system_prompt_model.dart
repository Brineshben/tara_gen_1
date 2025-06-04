// class SystemPromptModel {
//   String? status;
//   List<Data>? data;

//   SystemPromptModel({this.status, this.data});

//   SystemPromptModel.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     if (json['data'] != null) {
//       data = <Data>[];
//       json['data'].forEach((v) {
//         data!.add(new Data.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['status'] = this.status;
//     if (this.data != null) {
//       data['data'] = this.data!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class Data {
//   int? id;
//   String? commandPrompt;

//   Data({this.id, this.commandPrompt});

//   Data.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     commandPrompt = json['command_prompt'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['command_prompt'] = this.commandPrompt;
//     return data;
//   }
// }
