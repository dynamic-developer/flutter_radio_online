import 'package:get/get.dart';
import '../api_service.dart';
import '../api_state.dart';

class NotificationController extends GetxController {
  final _apiStateStream = ApiState().obs;
  ApiService apiService = ApiService();

  ApiState get state => _apiStateStream.value;

   notification(String token) async {
    _apiStateStream.value = NotificationLoading();
    try {
      final notification = await apiService.getNotification(token);
      if (notification.result == 'failure') {
        _apiStateStream.value = NotificationError(notification.message.toString());
      } else {
        _apiStateStream.value = NotificationLoaded(notification: notification);
      }
      print("State:${_apiStateStream.value}");
    } catch (e) {
      _apiStateStream.value = NotificationFailed([e.toString()]);
    }
  }
}