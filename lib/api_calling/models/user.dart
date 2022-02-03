/// result : "success"
/// message : "Get last Login Successfully"
/// data : {"id":5,"name":"vrunda","email":"vrunda.ags@gmail.com","country_code":"+91","mobile":"8980910613","email_verified_at":null,"birth_date":"1997-10-19","gender":"Female","device_token":"12345678","device_os":"android","api_token":"6OHPnsO99Q5MIUf04QOCyyDxw7DBhFaKLMFXCzj5NlO27ZOR6TDKVEBsqIZx","facebook_id":null,"google_id":null,"subscription_start_date":null,"subscription_end_date":null,"status":"1","last_login_at":"2021-10-11 12:21:40","created_at":"2021-10-11T04:55:11.000000Z","updated_at":"2021-10-11T06:51:40.000000Z","is_password_set":1}

class UserAuth {
  String? _result;
  String? _message;
  UserData? _data;

  String? get result => _result;
  String? get message => _message;
  UserData? get data => _data;

  UserAuth({
      String? result, 
      String? message, 
      UserData? data}){
    _result = result;
    _message = message;
    _data = data;
}

  UserAuth.fromJson(dynamic json) {
    _result = json["result"];
    _message = json["message"];
    _data = json["data"] != null ? UserData.fromJson(json["data"]) : null;
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

/// id : 5
/// name : "vrunda"
/// email : "vrunda.ags@gmail.com"
/// country_code : "+91"
/// mobile : "8980910613"
/// email_verified_at : null
/// birth_date : "1997-10-19"
/// gender : "Female"
/// device_token : "12345678"
/// device_os : "android"
/// api_token : "6OHPnsO99Q5MIUf04QOCyyDxw7DBhFaKLMFXCzj5NlO27ZOR6TDKVEBsqIZx"
/// facebook_id : null
/// google_id : null
/// subscription_start_date : null
/// subscription_end_date : null
/// status : "1"
/// last_login_at : "2021-10-11 12:21:40"
/// created_at : "2021-10-11T04:55:11.000000Z"
/// updated_at : "2021-10-11T06:51:40.000000Z"
/// is_password_set : 1

class UserData {
  int? _id;
  String? _name;
  String? _email;
  String? _countryCode;
  String? _mobile;
  dynamic? _emailVerifiedAt;
  String? _birthDate;
  String? _gender;
  String? _deviceToken;
  String? _deviceOs;
  String? _apiToken;
  dynamic? _facebookId;
  dynamic? _googleId;
  dynamic? _subscriptionStartDate;
  dynamic? _subscriptionEndDate;
  String? _status;
  String? _lastLoginAt;
  String? _createdAt;
  String? _updatedAt;
  int? _isPasswordSet;

  int? get id => _id;
  String? get name => _name;
  String? get email => _email;
  String? get countryCode => _countryCode;
  String? get mobile => _mobile;
  dynamic? get emailVerifiedAt => _emailVerifiedAt;
  String? get birthDate => _birthDate;
  String? get gender => _gender;
  String? get deviceToken => _deviceToken;
  String? get deviceOs => _deviceOs;
  String? get apiToken => _apiToken;
  dynamic? get facebookId => _facebookId;
  dynamic? get googleId => _googleId;
  dynamic? get subscriptionStartDate => _subscriptionStartDate;
  dynamic? get subscriptionEndDate => _subscriptionEndDate;
  String? get status => _status;
  String? get lastLoginAt => _lastLoginAt;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  int? get isPasswordSet => _isPasswordSet;

  UserData({
      int? id, 
      String? name, 
      String? email, 
      String? countryCode, 
      String? mobile, 
      dynamic? emailVerifiedAt, 
      String? birthDate, 
      String? gender, 
      String? deviceToken, 
      String? deviceOs, 
      String? apiToken, 
      dynamic? facebookId, 
      dynamic? googleId, 
      dynamic? subscriptionStartDate, 
      dynamic? subscriptionEndDate, 
      String? status, 
      String? lastLoginAt, 
      String? createdAt, 
      String? updatedAt, 
      int? isPasswordSet}){
    _id = id;
    _name = name;
    _email = email;
    _countryCode = countryCode;
    _mobile = mobile;
    _emailVerifiedAt = emailVerifiedAt;
    _birthDate = birthDate;
    _gender = gender;
    _deviceToken = deviceToken;
    _deviceOs = deviceOs;
    _apiToken = apiToken;
    _facebookId = facebookId;
    _googleId = googleId;
    _subscriptionStartDate = subscriptionStartDate;
    _subscriptionEndDate = subscriptionEndDate;
    _status = status;
    _lastLoginAt = lastLoginAt;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _isPasswordSet = isPasswordSet;
}

  UserData.fromJson(dynamic json) {
    _id = json["id"];
    _name = json["name"];
    _email = json["email"];
    _countryCode = json["country_code"];
    _mobile = json["mobile"];
    _emailVerifiedAt = json["email_verified_at"];
    _birthDate = json["birth_date"];
    _gender = json["gender"];
    _deviceToken = json["device_token"];
    _deviceOs = json["device_os"];
    _apiToken = json["api_token"];
    _facebookId = json["facebook_id"];
    _googleId = json["google_id"];
    _subscriptionStartDate = json["subscription_start_date"];
    _subscriptionEndDate = json["subscription_end_date"];
    _status = json["status"].toString();
    _lastLoginAt = json["last_login_at"];
    _createdAt = json["created_at"];
    _updatedAt = json["updated_at"];
    _isPasswordSet = json["is_password_set"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["name"] = _name;
    map["email"] = _email;
    map["country_code"] = _countryCode;
    map["mobile"] = _mobile;
    map["email_verified_at"] = _emailVerifiedAt;
    map["birth_date"] = _birthDate;
    map["gender"] = _gender;
    map["device_token"] = _deviceToken;
    map["device_os"] = _deviceOs;
    map["api_token"] = _apiToken;
    map["facebook_id"] = _facebookId;
    map["google_id"] = _googleId;
    map["subscription_start_date"] = _subscriptionStartDate;
    map["subscription_end_date"] = _subscriptionEndDate;
    map["status"] = _status;
    map["last_login_at"] = _lastLoginAt;
    map["created_at"] = _createdAt;
    map["updated_at"] = _updatedAt;
    map["is_password_set"] = _isPasswordSet;
    return map;
  }

}