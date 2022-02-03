import 'package:get/get.dart';
import '../api_service.dart';
import '../api_state.dart';

class EditProfileController extends GetxController {
  final _apiStateStream = ApiState().obs;
  ApiService apiService = ApiService();

  ApiState get state => _apiStateStream.value;

  void resetEditProfile() {
    _apiStateStream.value = ResetState();
  }

  /// Edit Profile Controller
  void editProfile(String name, String email, String countryCode, String mobile,
      String birthDate, String gender, String token) async {
    _apiStateStream.value = EditProfileLoading();
    try {
      final editProfile = await apiService.editProfile(
          name, email, countryCode, mobile, birthDate, gender, token);

      if (editProfile.result == 'failure') {
        _apiStateStream.value =
            EditProfileError(editProfile.message.toString());
      } else {
        _apiStateStream.value = EditProfileLoaded(user: editProfile);
      }

      print("State:${_apiStateStream.value}");
    } catch (e) {
      _apiStateStream.value = EditProfileFailed([e.toString()]);
    }
  }
}
