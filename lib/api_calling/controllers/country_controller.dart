import 'package:get/get.dart';
import '../api_service.dart';
import '../api_state.dart';

class CountryController extends GetxController {
  final _apiStateStream = ApiState().obs;
  ApiService apiService = ApiService();

  ApiState get state => _apiStateStream.value;

  /// Country Controller
  void country() async {
    _apiStateStream.value = CountryLoading();
    try {
      final country = await apiService.getCountry();

      if (country.result != null) {
        if (country.result == 'failure') {
          print("login data ::::::::: ${country.data}");
          _apiStateStream.value = CountryError(country.message.toString());
        } else {
          _apiStateStream.value = CountryLoaded(country: country);
        }
      }

      print("State:${_apiStateStream.value}");
    } catch (e) {
      _apiStateStream.value = CountryFailed([e.toString()]);
    }
  }
}
