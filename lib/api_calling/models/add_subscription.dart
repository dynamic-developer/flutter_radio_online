/// result : "success"
/// message : "data found"
/// data : {"user_id":17,"country_currency":"INR","amount":"7","payment_method":"In App","subscription_start_date":"2021-10-21","subscription_end_date":"2022-10-21","updated_at":"2021-10-21T04:50:50.000000Z","created_at":"2021-10-21T04:50:50.000000Z","id":34}

class AddSubscriptionModel {
  String? _result;
  String? _message;
  Data? _data;

  String? get result => _result;
  String? get message => _message;
  Data? get data => _data;

  AddSubscription({
      String? result, 
      String? message, 
      Data? data}){
    _result = result;
    _message = message;
    _data = data;
}

  AddSubscriptionModel.fromJson(dynamic json) {
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

/// user_id : 17
/// country_currency : "INR"
/// amount : "7"
/// payment_method : "In App"
/// subscription_start_date : "2021-10-21"
/// subscription_end_date : "2022-10-21"
/// updated_at : "2021-10-21T04:50:50.000000Z"
/// created_at : "2021-10-21T04:50:50.000000Z"
/// id : 34

class Data {
  int? _userId;
  String? _countryCurrency;
  String? _amount;
  String? _paymentMethod;
  String? _subscriptionStartDate;
  String? _subscriptionEndDate;
  String? _updatedAt;
  String? _createdAt;
  int? _id;

  int? get userId => _userId;
  String? get countryCurrency => _countryCurrency;
  String? get amount => _amount;
  String? get paymentMethod => _paymentMethod;
  String? get subscriptionStartDate => _subscriptionStartDate;
  String? get subscriptionEndDate => _subscriptionEndDate;
  String? get updatedAt => _updatedAt;
  String? get createdAt => _createdAt;
  int? get id => _id;

  Data({
      int? userId, 
      String? countryCurrency, 
      String? amount, 
      String? paymentMethod, 
      String? subscriptionStartDate, 
      String? subscriptionEndDate, 
      String? updatedAt, 
      String? createdAt, 
      int? id}){
    _userId = userId;
    _countryCurrency = countryCurrency;
    _amount = amount;
    _paymentMethod = paymentMethod;
    _subscriptionStartDate = subscriptionStartDate;
    _subscriptionEndDate = subscriptionEndDate;
    _updatedAt = updatedAt;
    _createdAt = createdAt;
    _id = id;
}

  Data.fromJson(dynamic json) {
    _userId = json["user_id"];
    _countryCurrency = json["country_currency"];
    _amount = json["amount"];
    _paymentMethod = json["payment_method"];
    _subscriptionStartDate = json["subscription_start_date"];
    _subscriptionEndDate = json["subscription_end_date"];
    _updatedAt = json["updated_at"];
    _createdAt = json["created_at"];
    _id = json["id"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["user_id"] = _userId;
    map["country_currency"] = _countryCurrency;
    map["amount"] = _amount;
    map["payment_method"] = _paymentMethod;
    map["subscription_start_date"] = _subscriptionStartDate;
    map["subscription_end_date"] = _subscriptionEndDate;
    map["updated_at"] = _updatedAt;
    map["created_at"] = _createdAt;
    map["id"] = _id;
    return map;
  }

}