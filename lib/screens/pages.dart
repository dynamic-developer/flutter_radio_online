import 'package:flutter/material.dart';
import 'package:radio_online/screens/home-page.dart';
import 'package:radio_online/screens/notification_page.dart';
import 'package:radio_online/screens/setting_page.dart';
import 'package:radio_online/screens/subscription_history.dart';
import '../main.dart';

bool isSubscribe = false;
String token = "";

class Pages extends StatefulWidget {
  final page;
  final index;

  const Pages({Key? key, this.page, this.index}) : super(key: key);

  @override
  _PagesState createState() => _PagesState(page,index);
}

class _PagesState extends State<Pages> {
  //final _lastLoginController = Get.put(LastLoginController());
  final Widget page;
  final index;
  late int _currentIndex = index;
  late Widget currentPage = page;

  _PagesState(this.page, this.index);

  @override
  void initState() {
    token = userLoad.data!.apiToken!;
    print("CUREENT PAGE :${currentPage} and index:${_currentIndex}");
    //_lastLoginController.lastLogin(token);
    super.initState();
  }

  void _selectTab(int tabItem) {
    setState(() {
      switch (tabItem) {
        case 0:
          currentPage = HomePage();
          break;
        case 1:
          currentPage = SubscriptionHistory();
          break;
        case 2:
          currentPage = NotificationPage();
          break;
        case 3:
          currentPage = SettingPage();
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentPage,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Color(0xFFFF2562),
        unselectedItemColor: Color(0xFF414041),
        selectedFontSize: 14,
        unselectedFontSize: 14,
        onTap: (value) {
          _currentIndex = value;
          _selectTab(_currentIndex);
        },
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.subscriptions),
            label: 'Subscription',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications_none_outlined),
              label: 'Notification'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Setting')
        ],
      ),
    );
  }
}
