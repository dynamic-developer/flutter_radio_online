/// result : "success"
/// message : "data found"
/// data : [{"id":4,"radio_name":"Radio 2","radio_stream_url":"https://ec3.yesstreaming.net:1825/stream","radio_image":"https://swarnimavasyojna.org/public/om-sakthi-music/storage/radio/5d14283a-5846-4ed2-8a57-1a0e1ea56bab.jpg","status":"1","created_at":"2021-08-24T19:14:36.000000Z","updated_at":"2021-09-07T12:05:53.000000Z"},{"id":3,"radio_name":"Radio 1","radio_stream_url":"https://ec3.yesstreaming.net:1815/stream","radio_image":"https://swarnimavasyojna.org/public/om-sakthi-music/storage/radio/94071ae2-4aec-4b32-8920-a2c29c1fc447.jpg","status":"1","created_at":"2021-08-24T19:04:25.000000Z","updated_at":"2021-09-07T12:06:03.000000Z"}]

class RadioList {
  String? _result;
  String? _message;
  List<Data>? _data;

  String? get result => _result;
  String? get message => _message;
  List<Data>? get data => _data;

  RadioList({
      String? result, 
      String? message, 
      List<Data>? data}){
    _result = result;
    _message = message;
    _data = data;
}

  RadioList.fromJson(dynamic json) {
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

/// id : 4
/// radio_name : "Radio 2"
/// radio_stream_url : "https://ec3.yesstreaming.net:1825/stream"
/// radio_image : "https://swarnimavasyojna.org/public/om-sakthi-music/storage/radio/5d14283a-5846-4ed2-8a57-1a0e1ea56bab.jpg"
/// status : "1"
/// created_at : "2021-08-24T19:14:36.000000Z"
/// updated_at : "2021-09-07T12:05:53.000000Z"

class Data {
  int? _id;
  String? _radioName;
  String? _radioStreamUrl;
  String? _radioImage;
  String? _status;
  String? _createdAt;
  String? _updatedAt;

  int? get id => _id;
  String? get radioName => _radioName;
  String? get radioStreamUrl => _radioStreamUrl;
  String? get radioImage => _radioImage;
  String? get status => _status;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Data({
      int? id, 
      String? radioName, 
      String? radioStreamUrl, 
      String? radioImage, 
      String? status, 
      String? createdAt, 
      String? updatedAt}){
    _id = id;
    _radioName = radioName;
    _radioStreamUrl = radioStreamUrl;
    _radioImage = radioImage;
    _status = status;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
}

  Data.fromJson(dynamic json) {
    _id = json["id"];
    _radioName = json["radio_name"];
    _radioStreamUrl = json["radio_stream_url"];
    _radioImage = json["radio_image"];
    _status = json["status"].toString();
    _createdAt = json["created_at"];
    _updatedAt = json["updated_at"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["radio_name"] = _radioName;
    map["radio_stream_url"] = _radioStreamUrl;
    map["radio_image"] = _radioImage;
    map["status"] = _status;
    map["created_at"] = _createdAt;
    map["updated_at"] = _updatedAt;
    return map;
  }

}