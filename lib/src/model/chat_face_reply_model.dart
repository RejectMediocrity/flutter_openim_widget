import 'dart:convert';

class ChatFaceReplyListModel {
  List<ChatFaceReplyModel> dataList = [];
  ChatFaceReplyListModel({required this.dataList});

  ChatFaceReplyListModel.fromString(String jsonStr) {
    List list = [];
    try {
      list = json.decode(jsonStr);
    } catch (e) {
      print(e.toString());
    }
    list.forEach((element) {
      ChatFaceReplyModel model = ChatFaceReplyModel.fromJson(element);
      dataList.add(model);
    });
  }

  ChatFaceReplyListModel.fromJson(List json) {
    json.forEach((element) {
      ChatFaceReplyModel model = ChatFaceReplyModel.fromJson(element);
      dataList.add(model);
    });
  }

  List<Map<String, dynamic>> toJson() {
    if (this.dataList.length <= 0) return [];
    final List<Map<String, dynamic>> dataList =
        this.dataList.map((e) => e.toJson()).toList();
    return dataList;
  }
}

class ChatFaceReplyModel {
  String? emoji;
  List<User>? user;

  ChatFaceReplyModel({this.emoji, this.user});

  ChatFaceReplyModel.fromJson(Map<String, dynamic> json) {
    emoji = json['emoji'];
    if (json['user'] != null) {
      user = <User>[];
      json['user'].forEach((v) {
        user!.add(new User.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['emoji'] = this.emoji;
    if (this.user != null) {
      data['user'] = this.user!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class User {
  String? id;
  String? name;
  String? avatar;

  User({this.id, this.name, this.avatar});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['avatar'] = this.avatar;
    return data;
  }
}
