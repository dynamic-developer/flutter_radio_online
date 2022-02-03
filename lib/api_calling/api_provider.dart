import 'package:get/get.dart';
import 'package:flutter/foundation.dart';

class ApiProvider extends GetConnect {
  //var baseURL = "http://swarnimavasyojna.org/public/om-sakthi-music/api/";

  var baseURL = kReleaseMode
      ? "https://omsakthimusic.com/api/"
      : "https://dev.omsakthimusic.com/api/";

  /// Register
  Future<Response> postRegister(Map data) => post(
        baseURL + "register",
        data,
        headers: {"Content-Type": "application/json"},
      );

  /// Google SignIn
  Future<Response> postGoogleSignIn(Map data) => post(
        baseURL + "google-login",
        data,
        headers: {"Content-Type": "application/json"},
      );

  /// Facebook SignIn
  Future<Response> postFacebookSignIn(Map data) =>
      post(baseURL + "facebook-login", data,
          headers: {"Content-Type": "application/json"});

  /// Facebook SignIn
  Future<Response> postAppleSignIn(Map data) =>
      post(baseURL + "apple-login", data,
          headers: {"Content-Type": "application/json"});

  Future<Response> postLogin(Map data) => post(
        baseURL + "login",
        data,
        headers: {"Content-Type": "application/json"},
      );

  /// Forgot Password
  Future<Response> postForgotPassword(Map data) => post(
        baseURL + "forgot-password",
        data,
        headers: {"Content-Type": "application/json"},
      );

  /// Edit Profile
  Future<Response> postEditProfile(Map data, String token) => post(
        baseURL + "edit-profile",
        data,
        headers: {"Token": token, "Content-Type": "application/json"},
      );

  /// Change Password
  Future<Response> postChangePassword(Map data, String token) => post(
        baseURL + "change-password",
        data,
        headers: {"Token": token, "Content-Type": "application/json"},
      );

  /// Radio List
  Future<Response> postRadioList(Map data, String token) => post(
        baseURL + "radio-list",
        data,
        headers: {"Token": token, "Content-Type": "application/json"},
      );

  /// Get Radio
  Future<Response> postGetRadio(Map data, String token) => post(
        baseURL + "get-radio",
        data,
        headers: {"Token": token, "Content-Type": "application/json"},
      );

  /// Get Notification
  Future<Response> postGetNotification(Map data, String token) => post(
        baseURL + "get-notification",
        data,
        headers: {"Token": token, "Content-Type": "application/json"},
      );

  /// Logout
  Future<Response> postLogout(Map data, String token) => post(
        baseURL + "logout",
        data,
        headers: {"Token": token, "Content-Type": "application/json"},
      );

  /// About Us
  Future<Response> postGetPages(Map data, String token) => post(
        baseURL + "get-page",
        data,
        headers: {"Token": token, "Content-Type": "application/json"},
      );

  Future<Response> getCountry(Map data) => post(baseURL + "get-country", data);

  /// Get Subscription
  Future<Response> getSubscription(Map data, String token) => post(
        baseURL + "get-subscription",
        data,
        headers: {"Token": token, "Content-Type": "application/json"},
      );

  /// Get Subscription
  Future<Response> addSubscription(Map data, String token) => post(
        baseURL + "add-subscription",
        data,
        headers: {"Token": token, "Content-Type": "application/json"},
      );

  /// Last Login
  Future<Response> getLastLogin(Map data, String token) => post(
        baseURL + "last-login",
        data,
        headers: {"Token": token, "Content-Type": "application/json"},
      );
}
