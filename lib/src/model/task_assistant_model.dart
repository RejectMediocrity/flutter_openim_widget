class TaskAssistantModel {
  String? imUserId;
  String? sourceName;
  String? title;
  int? type;
  String? userName;
  String? expire_time;

  TaskAssistantModel(
      {this.imUserId, this.sourceName, this.title, this.type, this.userName,this.expire_time});

  TaskAssistantModel.fromJson(Map<String, dynamic> json) {
    imUserId = json['im_user_id'];
    sourceName = json['source_name'];
    title = json['title'];
    type = json['type'];
    userName = json['user_name'];
    expire_time = json['expire_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['im_user_id'] = this.imUserId;
    data['source_name'] = this.sourceName;
    data['title'] = this.title;
    data['type'] = this.type;
    data['user_name'] = this.userName;
    data['expire_time'] = this.expire_time;
    return data;
  }
}

