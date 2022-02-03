import 'package:get/get.dart';
import '../api_service.dart';
import '../api_state.dart';

class AddSubscriptionController extends GetxController {
  final _apiStateStream = ApiState().obs;
  ApiService apiService = ApiService();

  ApiState get state => _apiStateStream.value;

  void resetSubscription(){
    _apiStateStream.value = ResetState();
  }

  ///Add Subscription Controller
  addSubscription(String token,String countryCurrency,String amount) async {
    _apiStateStream.value = AddSubscriptionLoading();
    try {
      final addSubscription = await apiService.addSubscription(token,countryCurrency,amount);

      if (addSubscription.result != null) {
        if (addSubscription.result == 'failure') {
          print("login data ::::::::: ${addSubscription.data}");
          _apiStateStream.value =
              AddSubscriptionError(addSubscription.message.toString());
        } else {
          _apiStateStream.value =
              AddSubscriptionLoaded(addSubscription: addSubscription);
        }
      }

      print("State:${_apiStateStream.value}");
    } catch (e) {
      _apiStateStream.value = AddSubscriptionFailed([e.toString()]);
    }
  }
}
