class CloudDocMessageModel {
  String? id;
  String? params;
  CloudDocPermission? permission;

  CloudDocMessageModel({this.id, this.params, this.permission});

  CloudDocMessageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    params = json['params'];
    permission = json['permission'] != null
        ? new CloudDocPermission.fromJson(json['permission'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['params'] = this.params;
    if (this.permission != null) {
      data['permission'] = this.permission!.toJson();
    }
    return data;
  }
}

class CloudDocPermission {
  String? sessionId;
  String? readOnlyUrl;
  String? readOnlyId;
  int? permission;
  String? padUrl;
  String? padId;
  int? padConfigShareType;
  int? padConfigPermission;
  String? title;

  CloudDocPermission(
      {this.sessionId,
      this.readOnlyUrl,
      this.readOnlyId,
      this.permission,
      this.padUrl,
      this.padId,
      this.padConfigShareType,
      this.padConfigPermission,
      this.title});

  CloudDocPermission.fromJson(Map<String, dynamic> json) {
    sessionId = json['session_id'];
    readOnlyUrl = json['read_only_url'];
    readOnlyId = json['read_only_id'];
    permission = json['permission'];
    padUrl = json['pad_url'];
    padId = json['pad_id'];
    padConfigShareType = json['pad_config_share_type'];
    padConfigPermission = json['pad_config_permission'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['session_id'] = this.sessionId;
    data['read_only_url'] = this.readOnlyUrl;
    data['read_only_id'] = this.readOnlyId;
    data['permission'] = this.permission;
    data['pad_url'] = this.padUrl;
    data['pad_id'] = this.padId;
    data['pad_config_share_type'] = this.padConfigShareType;
    data['pad_config_permission'] = this.padConfigPermission;
    data['title'] = this.title;
    return data;
  }
}
