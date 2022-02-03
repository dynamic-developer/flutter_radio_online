/// result : "success"
/// message : "data found"
/// data : {"id":1,"page_name":"About Us","page_description":"<p>\"Om Sakthi Music\" App,  the online devotional music streaming application, offered for the devotees of Melmaruvathur Adhiparsakthi Siddhar Peedam. We truly believe that for spirituality to come alive, you need to feel it. Over a period of time we plan to add more features and provide more choices.</p>\r\n\r\n<p>We offer a comfortable and friendly user experience with highly evolved music streaming technology at amazing speed and crystal clear sounds. We offer this service in both Andriod and IOS devices and hence available on the Google Play Store and Apple App Store.</p>","status":"1","created_at":null,"updated_at":"2021-09-15T06:47:41.000000Z"}

class GetPages {
  String? _result;
  String? _message;
  Data? _data;

  String? get result => _result;
  String? get message => _message;
  Data? get data => _data;

  GetPages({
      String? result, 
      String? message, 
      Data? data}){
    _result = result;
    _message = message;
    _data = data;
}

  GetPages.fromJson(dynamic json) {
    _result = json["result"];
    _message = json["message"];
    _data = json["data"] != null ? Data.fromJson(json["data"]) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["result"] = _result;
    map["message"] = _message;
    if (_data != null) {
      map["data"] = _data?.toJson();
    }
    return map;
  }

}

/// id : 1
/// page_name : "About Us"
/// page_description : "<p>\"Om Sakthi Music\" App,  the online devotional music streaming application, offered for the devotees of Melmaruvathur Adhiparsakthi Siddhar Peedam. We truly believe that for spirituality to come alive, you need to feel it. Over a period of time we plan to add more features and provide more choices.</p>\r\n\r\n<p>We offer a comfortable and friendly user experience with highly evolved music streaming technology at amazing speed and crystal clear sounds. We offer this service in both Andriod and IOS devices and hence available on the Google Play Store and Apple App Store.</p>"
/// status : "1"
/// created_at : null
/// updated_at : "2021-09-15T06:47:41.000000Z"

class Data {
  int? _id;
  String? _pageName;
  String? _pageDescription;
  String? _status;
  dynamic? _createdAt;
  String? _updatedAt;

  int? get id => _id;
  String? get pageName => _pageName;
  String? get pageDescription => _pageDescription;
  String? get status => _status;
  dynamic? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Data({
      int? id, 
      String? pageName, 
      String? pageDescription, 
      String? status, 
      dynamic? createdAt, 
      String? updatedAt}){
    _id = id;
    _pageName = pageName;
    _pageDescription = pageDescription;
    _status = status;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
}

  Data.fromJson(dynamic json) {
    _id = json["id"];
    _pageName = json["page_name"];
    _pageDescription = json["page_description"];
    _status = json["status"].toString();
    _createdAt = json["created_at"];
    _updatedAt = json["updated_at"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["page_name"] = _pageName;
    map["page_description"] = _pageDescription;
    map["status"] = _status;
    map["created_at"] = _createdAt;
    map["updated_at"] = _updatedAt;
    return map;
  }

}