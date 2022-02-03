import 'package:get/get.dart';
import '../api_service.dart';
import '../api_state.dart';

class GetPagesController extends GetxController {
  final _apiStateStream = ApiState().obs;
  ApiService apiService = ApiService();

  ApiState get state => _apiStateStream.value;

  void resetPagesState(){
    _apiStateStream.value = ResetState();
  }

  /// Get Pages Controller
  void getPages(String pageId, String token) async {
    _apiStateStream.value = PagesLoading();
    try {
      final getPages = await apiService.getPages(pageId, token);
      if (getPages.result != null) {
        if (getPages.result == 'failure') {
          _apiStateStream.value = PagesError(getPages.message.toString());
        } else {
          _apiStateStream.value = PagesLoaded(getPages: getPages);
        }
      }
      print("State:${_apiStateStream.value}");
    } catch (e) {
      _apiStateStream.value = PagesFailed([e.toString()]);
    }
  }
}
