class TaskAssistantModel {
  String? imUserId;
  String? sourceName;
  String? title;
  int? type;
  String? userName;

  TaskAssistantModel(
      {this.imUserId, this.sourceName, this.title, this.type, this.userName});

  TaskAssistantModel.fromJson(Map<String, dynamic> json) {
    imUserId = json['im_user_id'];
    sourceName = json['source_name'];
    title = json['title'];
    type = json['type'];
    userName = json['user_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['im_user_id'] = this.imUserId;
    data['source_name'] = this.sourceName;
    data['title'] = this.title;
    data['type'] = this.type;
    data['user_name'] = this.userName;
    return data;
  }
}

