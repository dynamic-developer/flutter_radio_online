import 'package:get/get.dart';
import '../api_service.dart';
import '../api_state.dart';

class AuthController extends GetxController {
  final _apiStateStream = ApiState().obs;
  ApiService apiService = ApiService();

  ApiState get state => _apiStateStream.value;

  /// Register Controller
  void register(
      String name,
      String email,
      String countryCode,
      String mobile,
      String password,
      String birthDate,
      String gender,
      String deviceToken,
      String deviceOs) async {
    _apiStateStream.value = UserLoading();
    try {
      final register = await apiService.register(name, email, countryCode,
          mobile, password, birthDate, gender, deviceToken, deviceOs);

      if (register.result == 'failure') {
        _apiStateStream.value = UserError(register.message.toString());
      } else {
        _apiStateStream.value = UserLoaded(user: register);
      }

      print("State:${_apiStateStream.value}");
    } catch (e) {
      _apiStateStream.value = UserFailed([e.toString()]);
    }
  }

  /// Login Controller
  void login(String mobile, String countryCode, String password,
      String deviceToken, String deviceOs) async {
    _apiStateStream.value = UserLoading();
    try {
      final login = await apiService.login(
          mobile, countryCode, password, deviceToken, deviceOs);

      if (login.result != null) {
        if (login.result == 'failure') {
          print("login data ::::::::: ${login.data}");
          _apiStateStream.value = UserError(login.message.toString());
        } else {
          _apiStateStream.value = UserLoaded(user: login);
        }
      }

      print("State:${_apiStateStream.value}");
    } catch (e) {
      _apiStateStream.value = UserFailed([e.toString()]);
    }
  }

  /// Google SignIN Controller
  void googleSignIn(
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
    _apiStateStream.value = GoogleSignInLoading();
    try {
      final googleSignIn = await apiService.googleSignIn(name, email, mobile,
          birth_date, gender, google_id, device_token, device_os, countryCode);

      if (googleSignIn.result == 'failure') {
        _apiStateStream.value =
            GoogleSignInError(googleSignIn.message.toString());
      } else {
        _apiStateStream.value = GoogleSignInLoaded(googleSignIn: googleSignIn);
      }

      print("State:${_apiStateStream.value}");
    } catch (e) {
      _apiStateStream.value = UserFailed([e.toString()]);
    }
  }

  /// Facebook SignIN Controller
  void facebookSignIn(
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
    _apiStateStream.value = FacebookSignInLoading();
    try {
      final facebookSignIn = await apiService.facebookSignIn(
          name,
          email,
          mobile,
          birth_date,
          gender,
          facebook_id,
          device_token,
          device_os,
          countryCode);

      if (facebookSignIn.result == 'failure') {
        _apiStateStream.value =
            FacebookSignInError(facebookSignIn.message.toString());
      } else {
        _apiStateStream.value =
            FacebookSignInLoaded(facebookSignIn: facebookSignIn);
      }

      print("State:${_apiStateStream.value}");
    } catch (e) {}
  }

  void resetState() {
    _apiStateStream.value = ResetState();
  }

  /// Apple SignIN Controller
  void appleSignIn(
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
    _apiStateStream.value = FacebookSignInLoading();
    try {
      final appleSignIn = await apiService.appleSignIn(name, email, mobile,
          birth_date, gender, apple_id, device_token, device_os, countryCode);

      if (appleSignIn.result == 'failure') {
        _apiStateStream.value =
            AppleSignInError(appleSignIn.message.toString());
      } else {
        _apiStateStream.value = AppleSignInLoaded(appleSignIn: appleSignIn);
      }

      print("State:${_apiStateStream.value}");
    } catch (e) {}
  }

  /// Logout Controller
  void logout(String token) async {
    _apiStateStream.value = LogoutLoading();
    try {
      final login = await apiService.logout(token);
      if (login.result != null) {
        if (login.result == 'failure') {
          _apiStateStream.value = LogoutError(login.message.toString());
        } else {
          _apiStateStream.value = LogoutLoaded(user: login);
        }
      }

      print("State:${_apiStateStream.value}");
    } catch (e) {
      _apiStateStream.value = LogoutFailed([e.toString()]);
    }
  }
}
