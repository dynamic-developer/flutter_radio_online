import 'package:get/get.dart';
import '../api_service.dart';
import '../api_state.dart';

class GetSubscriptionController extends GetxController {
  final _apiStateStream = ApiState().obs;
  ApiService apiService = ApiService();

  ApiState get state => _apiStateStream.value;

  ///Get Subscription Controller
  getSubscription(String token) async {
    _apiStateStream.value = GetSubscriptionLoading();
    try {
      final getSubscription = await apiService.getSubscription(token);

      if (getSubscription.result != null) {
        if (getSubscription.result == 'failure') {
          print("login data ::::::::: ${getSubscription.data}");
          _apiStateStream.value =
              GetSubscriptionError(getSubscription.message.toString());
        } else {
          _apiStateStream.value =
              GetSubscriptionLoaded(getSubscription: getSubscription);
        }
      }

      print("State:${_apiStateStream.value}");
    } catch (e) {
      _apiStateStream.value = GetSubscriptionFailed([e.toString()]);
    }
  }
}
