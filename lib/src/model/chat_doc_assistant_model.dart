class ChatDocAssistantModel {
  ChatDocAssistantParams? params;
  String? textDescribe;
  String? type;
  String? action;

  ChatDocAssistantModel({this.params, this.textDescribe, this.type});

  ChatDocAssistantModel.fromJson(Map<String, dynamic> json) {
    params = json['params'] != null
        ? new ChatDocAssistantParams.fromJson(json['params'])
        : null;
    textDescribe = json['text_describe'];
    type = json['type'];
    action = type == "permissionChange" ? "权限变更" : type;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.params != null) {
      data['params'] = this.params!.toJson();
    }
    data['text_describe'] = this.textDescribe;
    data['type'] = this.type;
    return data;
  }
}

class ChatDocAssistantParams {
  String? title;
  String? toImUserId;
  String? toImUserName;
  String? toUrl;
  String? noticeType;
  String? folderCode;
  int? type;

  ChatDocAssistantParams(
      {this.title,
      this.toImUserId,
      this.toImUserName,
      this.toUrl,
      this.noticeType,
      this.folderCode,
      this.type});

  ChatDocAssistantParams.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    toImUserId = json['to_im_user_id'];
    toImUserName = json['to_im_user_name'];
    toUrl = json['to_url'];
    noticeType = json['notice_type'];
    folderCode = json['folder_code'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['to_im_user_id'] = this.toImUserId;
    data['to_im_user_name'] = this.toImUserName;
    data['to_url'] = this.toUrl;
    data['notice_type'] = this.noticeType;
    data['folder_code'] = this.folderCode;
    data['type'] = this.type;
    return data;
  }
}
