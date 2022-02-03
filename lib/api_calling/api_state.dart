import 'package:equatable/equatable.dart';
import 'package:radio_online/api_calling/models/add_subscription.dart';
import 'package:radio_online/api_calling/models/country.dart';
import 'package:radio_online/api_calling/models/get_pages.dart';
import 'package:radio_online/api_calling/models/get_radio.dart';
import 'package:radio_online/api_calling/models/get_subscription.dart';
import 'package:radio_online/api_calling/models/radio_list.dart';
import 'models/notification.dart';
import 'models/user.dart';

class ApiState extends Equatable {
  const ApiState();

  @override
  List<Object> get props => [];
}

//// User State
class UserLoading extends ApiState {}

class UserLoaded extends ApiState {
  final UserAuth user;

  UserLoaded({required this.user});

  @override
  List<Object> get props => [user];
}

class UserError extends ApiState {
  final String message;

  UserError(this.message);
}

class UserFailed extends ApiState {
  final List<dynamic> message;

  UserFailed(this.message);
}

/// GoogleSignIn State
class GoogleSignInLoading extends ApiState {}

class GoogleSignInLoaded extends ApiState {
  final UserAuth googleSignIn;

  GoogleSignInLoaded({required this.googleSignIn});

  @override
  List<Object> get props => [googleSignIn];
}

class GoogleSignInError extends ApiState {
  final String message;

  GoogleSignInError(this.message);
}

class GoogleSignInFailed extends ApiState {
  final List<dynamic> message;

  GoogleSignInFailed(this.message);
}

/// FacebookSignIn State
class FacebookSignInLoading extends ApiState {}

class FacebookSignInLoaded extends ApiState {
  final UserAuth facebookSignIn;

  FacebookSignInLoaded({required this.facebookSignIn});

  @override
  List<Object> get props => [facebookSignIn];
}

class FacebookSignInError extends ApiState {
  final String message;

  FacebookSignInError(this.message);
}

class FacebookSignInFailed extends ApiState {
  final List<dynamic> message;

  FacebookSignInFailed(this.message);
}

/// AppleSignIn State
class AppleSignInLoading extends ApiState {}

class AppleSignInLoaded extends ApiState {
  final UserAuth appleSignIn;

  AppleSignInLoaded({required this.appleSignIn});

  @override
  List<Object> get props => [appleSignIn];
}

class AppleSignInError extends ApiState {
  final String message;

  AppleSignInError(this.message);
}

class AppleSignInFailed extends ApiState {
  final List<dynamic> message;

  AppleSignInFailed(this.message);
}

//// Forgot Password State
class ForgotPasswordLoading extends ApiState {}

class ForgotPasswordLoaded extends ApiState {
  final UserAuth user;

  ForgotPasswordLoaded({required this.user});

  @override
  List<Object> get props => [user];
}

class ForgotPasswordError extends ApiState {
  final String message;

  ForgotPasswordError(this.message);
}

class ForgotPasswordFailed extends ApiState {
  final List<dynamic> message;

  ForgotPasswordFailed(this.message);
}

//// Edit Profile State
class ResetState extends ApiState {}

class EditProfileLoading extends ApiState {}

class EditProfileLoaded extends ApiState {
  final UserAuth user;

  EditProfileLoaded({required this.user});

  @override
  List<Object> get props => [user];
}

class EditProfileError extends ApiState {
  final String message;

  EditProfileError(this.message);
}

class EditProfileFailed extends ApiState {
  final List<dynamic> message;

  EditProfileFailed(this.message);
}

//// Change Password State
class ChangePasswordLoading extends ApiState {}

class ChangePasswordLoaded extends ApiState {
  final UserAuth user;

  ChangePasswordLoaded({required this.user});

  @override
  List<Object> get props => [user];
}

class ChangePasswordError extends ApiState {
  final String message;

  ChangePasswordError(this.message);
}

class ChangePasswordFailed extends ApiState {
  final List<dynamic> message;

  ChangePasswordFailed(this.message);
}

//// Radio List State
class RadioListLoading extends ApiState {}

class RadioListLoaded extends ApiState {
  final RadioList radioList;

  RadioListLoaded({required this.radioList});

  @override
  List<Object> get props => [radioList];
}

class RadioListError extends ApiState {
  final String message;

  RadioListError(this.message);
}

class RadioListFailed extends ApiState {
  final List<dynamic> message;

  RadioListFailed(this.message);
}

//// Get Radio State
class GetRadioLoading extends ApiState {}

class GetRadioLoaded extends ApiState {
  final GetRadio getRadio;

  GetRadioLoaded({required this.getRadio});

  @override
  List<Object> get props => [getRadio];
}

class GetRadioError extends ApiState {
  final String message;

  GetRadioError(this.message);
}

class GetRadioFailed extends ApiState {
  final List<dynamic> message;

  GetRadioFailed(this.message);
}

//// Logout State
class LogoutLoading extends ApiState {}

class LogoutLoaded extends ApiState {
  final UserAuth user;

  LogoutLoaded({required this.user});

  @override
  List<Object> get props => [user];
}

class LogoutError extends ApiState {
  final String message;

  LogoutError(this.message);
}

class LogoutFailed extends ApiState {
  final List<dynamic> message;

  LogoutFailed(this.message);
}

/// Pages State
class PagesLoading extends ApiState {}

class PagesLoaded extends ApiState {
  final GetPages getPages;

  PagesLoaded({required this.getPages});

  @override
  List<Object> get props => [getPages];
}

class PagesError extends ApiState {
  final String message;

  PagesError(this.message);
}

class PagesFailed extends ApiState {
  final List<dynamic> message;

  PagesFailed(this.message);
}

/// Notification State
class NotificationLoading extends ApiState {}

class NotificationLoaded extends ApiState {
  final NotificationList notification;

  NotificationLoaded({required this.notification});

  @override
  List<Object> get props => [notification];
}

class NotificationError extends ApiState {
  final String message;

  NotificationError(this.message);
}

class NotificationFailed extends ApiState {
  final List<dynamic> message;

  NotificationFailed(this.message);
}

//// Country State
class CountryLoading extends ApiState {}

class CountryLoaded extends ApiState {
  final Country country;

  CountryLoaded({required this.country});

  @override
  List<Object> get props => [country];
}

class CountryError extends ApiState {
  final String message;

  CountryError(this.message);
}

class CountryFailed extends ApiState {
  final List<dynamic> message;

  CountryFailed(this.message);
}

//// Subscription State
class GetSubscriptionLoading extends ApiState {}

class GetSubscriptionLoaded extends ApiState {
  final GetSubscription getSubscription;

  GetSubscriptionLoaded({required this.getSubscription});

  @override
  List<Object> get props => [getSubscription];
}

class GetSubscriptionError extends ApiState {
  final String message;

  GetSubscriptionError(this.message);
}

class GetSubscriptionFailed extends ApiState {
  final List<dynamic> message;

  GetSubscriptionFailed(this.message);
}

////Add Subscription State
class AddSubscriptionLoading extends ApiState {}

class AddSubscriptionLoaded extends ApiState {
  final AddSubscriptionModel addSubscription;

  AddSubscriptionLoaded({required this.addSubscription});

  @override
  List<Object> get props => [addSubscription];
}

class AddSubscriptionError extends ApiState {
  final String message;

  AddSubscriptionError(this.message);
}

class AddSubscriptionFailed extends ApiState {
  final List<dynamic> message;

  AddSubscriptionFailed(this.message);
}

//// Last Login State
class LastLoginLoading extends ApiState {}

class LastLoginLoaded extends ApiState {
  final UserAuth user;

  LastLoginLoaded({required this.user});

  @override
  List<Object> get props => [user];
}

class LastLoginError extends ApiState {
  final String message;

  LastLoginError(this.message);
}

class LastLoginFailed extends ApiState {
  final List<dynamic> message;

  LastLoginFailed(this.message);
}
