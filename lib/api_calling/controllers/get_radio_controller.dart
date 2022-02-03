import 'package:get/get.dart';
import '../api_service.dart';
import '../api_state.dart';

class GetRadioController extends GetxController {
  final _apiStateStream = ApiState().obs;
  ApiService apiService = ApiService();

  ApiState get state => _apiStateStream.value;

  void getRadio(String radioId,String token) async {
    _apiStateStream.value = GetRadioLoading();
    try {
      final getRadio = await apiService.getRadio(radioId,token);
      if (getRadio.result == 'failure') {
        _apiStateStream.value = GetRadioError(getRadio.message.toString());
      } else {
        _apiStateStream.value = GetRadioLoaded(getRadio: getRadio);
      }
      print("State:${_apiStateStream.value}");
    } catch (e) {
      _apiStateStream.value = GetRadioFailed([e.toString()]);
    }
  }
}
