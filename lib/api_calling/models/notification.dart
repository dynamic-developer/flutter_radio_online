/// result : "success"
/// message : "data found"
/// data : [{"id":3,"user_id":"16","title":"New update available, Please Download.","message":"New update available, Please Download.","created_at":"2021-09-15T07:32:47.000000Z","updated_at":"2021-09-15T07:32:47.000000Z"}]

class NotificationList {
  String? _result;
  String? _message;
  List<Data>? _data;

  String? get result => _result;
  String? get message => _message;
  List<Data>? get data => _data;

  NotificationList({
      String? result, 
      String? message, 
      List<Data>? data}){
    _result = result;
    _message = message;
    _data = data;
}

  NotificationList.fromJson(dynamic json) {
    _result = json["result"];
    _message = json["message"];
    if (json["data"] != null) {
      _data = [];
      json["data"].forEach((v) {
        _data?.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["result"] = _result;
    map["message"] = _message;
    if (_data != null) {
      map["data"] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : 3
/// user_id : "16"
/// title : "New update available, Please Download."
/// message : "New update available, Please Download."
/// created_at : "2021-09-15T07:32:47.000000Z"
/// updated_at : "2021-09-15T07:32:47.000000Z"

class Data {
  int? _id;
  String? _userId;
  String? _title;
  String? _message;
  String? _createdAt;
  String? _updatedAt;

  int? get id => _id;
  String? get userId => _userId;
  String? get title => _title;
  String? get message => _message;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Data({
      int? id, 
      String? userId, 
      String? title, 
      String? message, 
      String? createdAt, 
      String? updatedAt}){
    _id = id;
    _userId = userId;
    _title = title;
    _message = message;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
}

  Data.fromJson(dynamic json) {
    _id = json["id"];
    _userId = json["user_id"];
    _title = json["title"];
    _message = json["message"];
    _createdAt = json["created_at"];
    _updatedAt = json["updated_at"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["user_id"] = _userId;
    map["title"] = _title;
    map["message"] = _message;
    map["created_at"] = _createdAt;
    map["updated_at"] = _updatedAt;
    return map;
  }

}