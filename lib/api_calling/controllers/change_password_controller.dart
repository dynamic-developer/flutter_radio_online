import 'package:get/get.dart';
import '../api_service.dart';
import '../api_state.dart';

class ChangePasswordController extends GetxController {
  final _apiStateStream = ApiState().obs;
  ApiService apiService = ApiService();

  ApiState get state => _apiStateStream.value;

  void resetChangePassword(){
    _apiStateStream.value = ResetState();
  }

  /// Change Password Controller
  void changePassword(String oldPassword, String newPassword,
      String token) async {
    _apiStateStream.value = ChangePasswordLoading();
    try {
      final changePassword =
      await apiService.changePassword(oldPassword, newPassword, token);
      if (changePassword.result == 'failure') {
        _apiStateStream.value =
            ChangePasswordError(changePassword.message.toString());
      } else {
        _apiStateStream.value = ChangePasswordLoaded(user: changePassword);
      }
      print("State:${_apiStateStream.value}");
    } catch (e) {
      _apiStateStream.value = ChangePasswordFailed([e.toString()]);
    }
  }

}