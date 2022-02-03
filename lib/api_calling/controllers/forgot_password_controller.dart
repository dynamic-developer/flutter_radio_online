import 'package:get/get.dart';
import '../api_service.dart';
import '../api_state.dart';

class ForgotPasswordController extends GetxController {
  final _apiStateStream = ApiState().obs;
  ApiService apiService = ApiService();

  ApiState get state => _apiStateStream.value;

  void resetForgotPassword(){
    _apiStateStream.value = ResetState();
  }

  /// Forgot Password Controller
  void forgotPassword(String countryCode, String mobile) async {
    _apiStateStream.value = ForgotPasswordLoading();
    try {
      final forgotPassword = await apiService.forgotPassword(countryCode,mobile);
      if (forgotPassword.result == 'failure') {
        _apiStateStream.value =
            ForgotPasswordError(forgotPassword.message.toString());
      } else {
        _apiStateStream.value = ForgotPasswordLoaded(user: forgotPassword);
      }
      print("State:${_apiStateStream.value}");
    } catch (e) {
      print("Error:$e");
      _apiStateStream.value = ForgotPasswordFailed([e.toString()]);
    }
  }
}