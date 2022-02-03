/// result : "success"
/// message : "data found"
/// data : [{"id":1,"country_name":"India","country_short_name":"IN","country_code":"+91","status":"1","created_at":"2021-09-28T22:33:30.000000Z","updated_at":"2021-09-28T22:33:30.000000Z"},{"id":2,"country_name":"United States of America","country_short_name":"USA","country_code":"+1","status":"1","created_at":"2021-09-28T22:33:59.000000Z","updated_at":"2021-09-29T22:58:11.000000Z"}]

class Country {
  String? _result;
  String? _message;
  List<Data>? _data;

  String? get result => _result;

  String? get message => _message;

  List<Data>? get data => _data;

  Country({String? result, String? message, List<Data>? data}) {
    _result = result;
    _message = message;
    _data = data;
  }

  Country.fromJson(dynamic json) {
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

/// id : 1
/// country_name : "India"
/// country_short_name : "IN"
/// country_code : "+91"
/// status : "1"
/// created_at : "2021-09-28T22:33:30.000000Z"
/// updated_at : "2021-09-28T22:33:30.000000Z"

class Data {
  int? _id;
  String? _countryName;
  String? _countryShortName;
  String? _countryCode;
  String? _countryCurrency;
  String? _status;
  String? _createdAt;
  String? _updatedAt;

  int? get id => _id;

  String? get countryName => _countryName;

  String? get countryShortName => _countryShortName;

  String? get countryCode => _countryCode;

  String? get countryCurrency => _countryCurrency;

  String? get status => _status;

  String? get createdAt => _createdAt;

  String? get updatedAt => _updatedAt;

  Data(
      {int? id,
      String? countryName,
      String? countryShortName,
      String? countryCode,
      String? countryCurrency,
      String? status,
      String? createdAt,
      String? updatedAt}) {
    _id = id;
    _countryName = countryName;
    _countryShortName = countryShortName;
    _countryCode = countryCode;
    _countryCurrency = countryCurrency;
    _status = status;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  Data.fromJson(dynamic json) {
    _id = json["id"];
    _countryName = json["country_name"];
    _countryShortName = json["country_short_name"];
    _countryCode = json["country_code"];
    _countryCurrency = json["country_currency"];
    _status = json["status"].toString();
    _createdAt = json["created_at"];
    _updatedAt = json["updated_at"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["country_name"] = _countryName;
    map["country_short_name"] = _countryShortName;
    map["country_code"] = _countryCode;
    map["country_currency"] = _countryCurrency;
    map["status"] = _status;
    map["created_at"] = _createdAt;
    map["updated_at"] = _updatedAt;
    return map;
  }
}
