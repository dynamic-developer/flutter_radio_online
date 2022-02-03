import 'package:get/get.dart';
import '../api_service.dart';
import '../api_state.dart';

class LastLoginController extends GetxController {
  final _apiStateStream = ApiState().obs;
  ApiService apiService = ApiService();

  ApiState get state => _apiStateStream.value;

  ///Last Login Controller
  Future lastLogin(String token) async {
    _apiStateStream.value = LastLoginLoading();
    try {
      final lastLogin = await apiService.lastLogin(token);

      if (lastLogin.result != null) {
        if (lastLogin.result == 'failure') {
          print("login data ::::::::: ${lastLogin.message}");
          _apiStateStream.value = LastLoginError(lastLogin.message.toString());
        } else {
          _apiStateStream.value = LastLoginLoaded(user: lastLogin);
        }
      }

      print("State:${_apiStateStream.value}");
    } catch (e) {
      _apiStateStream.value = LastLoginFailed([e.toString()]);
    }
  }
}
