import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:radio_online/api_calling/models/country.dart';
import 'package:radio_online/api_calling/models/get_subscription.dart';
import 'package:radio_online/api_calling/models/notification.dart';
import 'package:radio_online/api_calling/models/radio_list.dart';
import 'api_provider.dart';
import 'models/add_subscription.dart';
import 'models/get_pages.dart';
import 'models/get_radio.dart';
import 'models/user.dart';

List<Map<String, String>> countryCodes = [];

class ApiService extends GetxController {
  /// Register
  Future<UserAuth> register(
      String name,
      String email,
      String countryCode,
      String mobile,
      String password,
      String birthDate,
      String gender,
      String deviceToken,
      String deviceOs) async {
    var map = <String, dynamic>{};
    map["name"] = name;
    map["email"] = email;
    map["country_code"] = countryCode;
    map["mobile"] = mobile;
    map["password"] = password;
    map["birth_date"] = birthDate;
    map["gender"] = gender;
    map["device_token"] = deviceToken;
    map["device_os"] = deviceOs;
    print("REGISTER PARAMETER: $map");
    var res = await ApiProvider().postRegister(map);
    print("REGISTER STATUS CODE: ${res.statusCode}");
    print("REGISTER RESPONSE: ${res.body}");
    return UserAuth.fromJson(res.body);
  }

  /// Login
  Future<UserAuth> login(String mobile, String countryCode, String password,
      String deviceToken, String deviceOs) async {
    var map = <String, dynamic>{};
    map["mobile"] = mobile;
    map["country_code"] = countryCode;
    map["password"] = password;
    map["device_token"] = deviceToken;
    map["device_os"] = deviceOs;
    print("LOGIN PARAMETER: $map");
    var res = await ApiProvider().postLogin(map);
    print("LOGIN STATUS CODE: ${res.statusCode}");
    print("LOGIN RESPONSE: ${res.body}");
    return UserAuth.fromJson(res.body);
  }

  /// Google SignIn
  Future<UserAuth> googleSignIn(
    String name,
    String email,
    String mobile,
    String birth_date,
    String gender,
    String google_id,
    String device_token,
    String device_os,
    String countryCode,
  ) async {
    var map = <String, dynamic>{};
    map["name"] = name;
    map["email"] = email;
    map["mobile"] = mobile;
    map["birth_date"] = birth_date;
    map["country_code"] = countryCode;
    map["gender"] = gender;
    map["google_id"] = google_id;
    map["device_token"] = device_token;
    map["device_os"] = device_os;
    print("LOGIN PARAMETER: $map");
    var res = await ApiProvider().postGoogleSignIn(map);
    print("LOGIN STATUS CODE: ${res.statusCode}");
    print("LOGIN RESPONSE: ${res.body}");
    return UserAuth.fromJson(res.body);
  }

  /// Facebook SignIn
  Future<UserAuth> facebookSignIn(
    String name,
    String email,
    String mobile,
    String birth_date,
    String gender,
    String facebook_id,
    String device_token,
    String device_os,
    String countryCode,
  ) async {
    var map = <String, dynamic>{};
    map["name"] = name;
    map["email"] = email;
    map["mobile"] = mobile;
    map["birth_date"] = birth_date;
    map["gender"] = gender;

    map["country_code"] = countryCode;
    map["facebook_id"] = facebook_id;
    map["device_token"] = device_token;
    map["device_os"] = device_os;
    print("LOGIN PARAMETER: $map");
    var res = await ApiProvider().postFacebookSignIn(map);
    print("LOGIN STATUS CODE: ${res.statusCode}");
    print("LOGIN RESPONSE: ${res.body}");
    return UserAuth.fromJson(res.body);
  }

  /// Apple SignIn
  Future<UserAuth> appleSignIn(
    String name,
    String email,
    String mobile,
    String birth_date,
    String gender,
    String apple_id,
    String device_token,
    String device_os,
    String countryCode,
  ) async {
    var map = <String, dynamic>{};
    map["name"] = name;
    map["email"] = email;
    map["mobile"] = mobile;

    map["country_code"] = countryCode;
    map["birth_date"] = birth_date;
    map["gender"] = gender;
    map["apple_id"] = apple_id;
    map["device_token"] = device_token;
    map["device_os"] = device_os;
    print("LOGIN PARAMETER: $map");
    var res = await ApiProvider().postAppleSignIn(map);
    print("LOGIN STATUS CODE: ${res.statusCode}");
    print("LOGIN RESPONSE: ${res.body}");
    return UserAuth.fromJson(res.body);
  }

  /// Forgot Password
  Future<UserAuth> forgotPassword(String countryCode, String mobile) async {
    var map = <String, dynamic>{};
    map["country_code"] = countryCode;
    map["mobile"] = mobile;
    print("Forgot PASSWORD PARAMETER: $map");
    var res = await ApiProvider().postForgotPassword(map);
    // var res = await http.post(
    //   Uri.parse(
    //       'https://swarnimavasyojna.org/public/om-sakthi-music/api/forgot-password'),
    //   body: map,
    // );
    // print("Forgot PASSWORD  STATUS CODE: ${res.statusCode}");
    // print("Forgot PASSWORD  RESPONSE: ${res.body}");
    // final jsonData = jsonDecode(res.body);
    return UserAuth.fromJson(res.body);
  }

  /// Edit Profile
  Future<UserAuth> editProfile(String name, String email, String countryCode,
      String mobile, String birthDate, String gender, String token) async {
    var map = <String, dynamic>{};
    map["name"] = name;
    map["email"] = email;
    map["country_code"] = countryCode;
    map["mobile"] = mobile;
    map["birth_date"] = birthDate;
    map["gender"] = gender;
    print("EDIT PROFILE PARAMETER: $token");
    var res = await ApiProvider().postEditProfile(map, token);
    print("EDIT PROFILE STATUS CODE: ${res.statusCode}");
    print("EDIT PROFILE RESPONSE: ${res.body}");
    return UserAuth.fromJson(res.body);
  }

  /// Change Password
  Future<UserAuth> changePassword(
      String oldPassword, String newPassword, String token) async {
    var map = <String, dynamic>{};
    map["old_password"] = oldPassword;
    map["new_password"] = newPassword;
    print("CHANGE PASSWORD PARAMETER: $map");
    var res = await ApiProvider().postChangePassword(map, token);
    print("CHANGE PASSWORD PARAMETER: STATUS CODE: ${res.statusCode}");
    print("CHANGE PASSWORD PARAMETER: RESPONSE: ${res.body}");
    return UserAuth.fromJson(res.body);
  }

  /// Radio List
  Future<RadioList> radioList(String token) async {
    var map = <String, dynamic>{};
    var res = await ApiProvider().postRadioList(map, token);
    print("RadioList STATUS CODE: ${res.statusCode}");
    print("RadioList: RESPONSE: ${res.body}");
    return RadioList.fromJson(res.body);
  }

  /// Get Radio
  Future<GetRadio> getRadio(String radioId, String token) async {
    var map = <String, dynamic>{};
    map["radio_id"] = radioId;
    var res = await ApiProvider().postGetRadio(map, token);
    print("Radio STATUS CODE: ${res.statusCode}");
    print("Radio: RESPONSE: ${res.body}");
    return GetRadio.fromJson(res.body);
  }

  /// Get Notification
  Future<NotificationList> getNotification(String token) async {
    var map = <String, dynamic>{};
    var res = await ApiProvider().postGetNotification(map, token);
    print("NOTIFICATION STATUS CODE: ${res.statusCode}");
    print("NOTIFICATION RESPONSE: ${res.body}");
    return NotificationList.fromJson(res.body);
  }

  /// Logout
  Future<UserAuth> logout(String token) async {
    var map = <String, dynamic>{};
    var res = await ApiProvider().postLogout(map, token);
    print("LOGOUT STATUS CODE: ${res.statusCode}");
    print("LOGOUT: RESPONSE: ${res.body}");
    return UserAuth.fromJson(res.body);
  }

  /// About Us
  Future<GetPages> getPages(String pageId, String token) async {
    var map = <String, dynamic>{};
    map["page_id"] = pageId;
    var res = await ApiProvider().postGetPages(map, token);
    print("ABOUT US STATUS CODE: ${res.statusCode}");
    print("ABOUT US: RESPONSE: ${res.body}");
    print("ABOUT US: RESPONSE jSON: ${GetPages.fromJson(res.body)}");
    return GetPages.fromJson(res.body);
  }

  Future<Country> getCountry() async {
    var map = <String, dynamic>{};
    var res = await ApiProvider().getCountry(map);

    print("COUNTRY RESPONSE: ${res.statusCode}");
    var country = Country.fromJson(res.body);

    country.data!.forEach((element) {
      var country1 = <String, String>{
        "name": element.countryName.toString(),
        "code": element.countryShortName.toString(),
        "dial_code": element.countryCode.toString(),
      };
      countryCodes.add(country1);
    });
    print("COUNTRY CODE: ${countryCodes.length}");

    return Country.fromJson(res.body);
  }

  /// Get Subscription
  Future<GetSubscription> getSubscription(String token) async {
    var map = <String, dynamic>{};
    var res = await ApiProvider().getSubscription(map, token);
    print("SUBSCRIPTION STATUS CODE: ${res.statusCode}");
    print("SUBSCRIPTION RESPONSE: ${res.body}");
    return GetSubscription.fromJson(res.body);
  }

  /// Add Subscription
  Future<AddSubscriptionModel> addSubscription(
      String token, String countryCurrency, String amount) async {
    var map = <String, dynamic>{};
    map["country_currency"] = countryCurrency;
    map["amount"] = amount;
    var res = await ApiProvider().addSubscription(map, token);
    print("SUBSCRIPTION STATUS CODE: ${res.statusCode}");
    print("SUBSCRIPTION RESPONSE: ${res.body}");
    return AddSubscriptionModel.fromJson(res.body);
  }

  /// Last Login
  Future<UserAuth> lastLogin(String token) async {
    var map = <String, dynamic>{};
    var res = await ApiProvider().getLastLogin(map, token);
    print("LAST LOGIN STATUS CODE: ${res.statusCode}");
    print("LAST LOGIN RESPONSE: ${res.body}");
    return UserAuth.fromJson(res.body);
  }
}
