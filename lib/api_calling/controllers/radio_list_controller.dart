import 'package:get/get.dart';
import '../api_service.dart';
import '../api_state.dart';

class RadioListController extends GetxController {
  final _apiStateStream = ApiState().obs;
  ApiService apiService = ApiService();

  ApiState get state => _apiStateStream.value;

  void resetRadioList(){
    _apiStateStream.value = ResetState();
  }

  void radioList(String token) async {
    _apiStateStream.value = RadioListLoading();
    try {
      final radioList = await apiService.radioList(token);
      if (radioList.result == 'failure') {
        _apiStateStream.value = RadioListError(radioList.message.toString());
      } else {
        _apiStateStream.value = RadioListLoaded(radioList: radioList);
      }
      print("State:${_apiStateStream.value}");
    } catch (e) {
      _apiStateStream.value = RadioListFailed([e.toString()]);
    }
  }
}
