/// result : "success"
/// message : "data found"
/// data : [{"id":1,"user_id":"1","amount":"10.00","transaction_id":"1","payment_method":"In App","subscription_start_date":"2021-09-30","subscription_end_date":"2022-09-30","created_at":"2021-09-30T13:08:47.000000Z","updated_at":"2021-09-30T13:08:47.000000Z"},{"id":3,"user_id":"3","amount":"10.00","transaction_id":null,"payment_method":"Cash","subscription_start_date":"2021-09-30","subscription_end_date":"2022-09-30","created_at":"2021-09-30T16:27:07.000000Z","updated_at":"2021-09-30T16:27:07.000000Z"},{"id":4,"user_id":"3","amount":"10.00","transaction_id":null,"payment_method":"Cash","subscription_start_date":"2021-09-30","subscription_end_date":"2022-09-30","created_at":"2021-09-30T16:44:36.000000Z","updated_at":"2021-09-30T16:44:36.000000Z"}]

class GetSubscription {
  String? _result;
  String? _message;
  List<Data>? _data;

  String? get result => _result;

  String? get message => _message;

  List<Data>? get data => _data;

  GetSubscription({String? result, String? message, List<Data>? data}) {
    _result = result;
    _message = message;
    _data = data;
  }

  GetSubscription.fromJson(dynamic json) {
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
/// user_id : "1"
/// amount : "10.00"
/// transaction_id : "1"
/// payment_method : "In App"
/// subscription_start_date : "2021-09-30"
/// subscription_end_date : "2022-09-30"
/// created_at : "2021-09-30T13:08:47.000000Z"
/// updated_at : "2021-09-30T13:08:47.000000Z"

class Data {
  int? _id;
  String? _userId;
  String? _amount;
  String? _transactionId;
  String? _paymentMethod;
  String? _subscriptionStartDate;
  String? _subscriptionEndDate;
  String? _createdAt;
  String? _updatedAt;

  int? get id => _id;

  String? get userId => _userId;

  String? get amount => _amount;

  String? get transactionId => _transactionId;

  String? get paymentMethod => _paymentMethod;

  String? get subscriptionStartDate => _subscriptionStartDate;

  String? get subscriptionEndDate => _subscriptionEndDate;

  String? get createdAt => _createdAt;

  String? get updatedAt => _updatedAt;

  Data(
      {int? id,
      String? userId,
      String? amount,
      String? transactionId,
      String? paymentMethod,
      String? subscriptionStartDate,
      String? subscriptionEndDate,
      String? createdAt,
      String? updatedAt}) {
    _id = id;
    _userId = userId;
    _amount = amount;
    _transactionId = transactionId;
    _paymentMethod = paymentMethod;
    _subscriptionStartDate = subscriptionStartDate;
    _subscriptionEndDate = subscriptionEndDate;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  Data.fromJson(dynamic json) {
    _id = json["id"];
    _userId = json["user_id"];
    _amount = json["amount"];
    _transactionId = json["transaction_id"];
    _paymentMethod = json["payment_method"];
    _subscriptionStartDate = json["subscription_start_date"];
    _subscriptionEndDate = json["subscription_end_date"];
    _createdAt = json["created_at"];
    _updatedAt = json["updated_at"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["user_id"] = _userId;
    map["amount"] = _amount;
    map["transaction_id"] = _transactionId;
    map["payment_method"] = _paymentMethod;
    map["subscription_start_date"] = _subscriptionStartDate;
    map["subscription_end_date"] = _subscriptionEndDate;
    map["created_at"] = _createdAt;
    map["updated_at"] = _updatedAt;
    return map;
  }
}
