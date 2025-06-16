class QAmodel {
  String? status;
  String? prompt;
  List<Data>? data;

  QAmodel({this.status, this.prompt, this.data});

  QAmodel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    prompt = json['prompt'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['prompt'] = this.prompt;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  int? prompt;
  String? commandPrompt;
  String? question;
  String? answer;

  Data({this.id, this.prompt, this.commandPrompt, this.question, this.answer});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    prompt = json['prompt'];
    commandPrompt = json['command_prompt'];
    question = json['question'];
    answer = json['answer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['prompt'] = this.prompt;
    data['command_prompt'] = this.commandPrompt;
    data['question'] = this.question;
    data['answer'] = this.answer;
    return data;
  }
}
