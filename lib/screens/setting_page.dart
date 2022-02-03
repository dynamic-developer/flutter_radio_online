import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:radio_online/api_calling/api_state.dart';
import 'package:radio_online/api_calling/controllers/auth_controller.dart';
import 'package:radio_online/helper/shared_pref.dart';
import 'package:radio_online/helper/widgets/player.dart';
import 'package:radio_online/helper/widgets/utils.dart';
import 'package:radio_online/screens/get_pages.dart';
import 'package:radio_online/screens/change_password_page.dart';
import 'package:radio_online/screens/login_page.dart';
import 'package:radio_online/screens/pages.dart';
import 'package:radio_online/screens/profile_page.dart';
import '../main.dart';
import 'home-page.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool status = false;
  final _controller = Get.put(AuthController());
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  SharedPref sharedPref = SharedPref();

  @override
  void initState() {
    isPage = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          key: _scaffoldKey,
          backgroundColor: Color(0xFFEFF0F6),
          appBar: appBar(),
          body: Obx(() {
            if (_controller.state is LogoutFailed) {
              WidgetsBinding.instance!.addPostFrameCallback((_) {
                _scaffoldKey.currentState!.showSnackBar(SnackBar(
                  content: Text(
                    'Check Your Internet Connection',
                    textAlign: TextAlign.center,
                  ),
                  duration: Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                ));
              });
            }
            if (_controller.state is LogoutError) {
              WidgetsBinding.instance!.addPostFrameCallback((_) {
                _scaffoldKey.currentState!.showSnackBar(SnackBar(
                  content: Text(
                    (_controller.state as LogoutError).message.toString(),
                    textAlign: TextAlign.center,
                  ),
                  duration: Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                ));
              });
            }
            if (_controller.state is LogoutLoaded) {
              WidgetsBinding.instance!.addPostFrameCallback((_) async {
                if (isSubscribe == true) {
                  isSubscribe = false;
                  audioHandler.onTaskRemoved();
                  audioHandler.stop();
                }
                //count = 0;
                await sharedPref.remove("user");
                _scaffoldKey.currentState!.showSnackBar(SnackBar(
                  content: Text(
                    (_controller.state as LogoutLoaded).user.message.toString(),
                  ),
                  duration: Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                ));
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => LoginPage()),
                    (r) => false);
                //TODO: changes by adarsh
                // Navigator.push(
                //     context, MaterialPageRoute(builder: (_) => LoginPage()));
              });
            }
            return body(context);
          }),
        ),
        if (isSubscribe == true)
          ValueListenableBuilder(
            valueListenable: currentlyPlaying,
            builder: (BuildContext context, AudioObject? audioObject,
                    Widget? child) =>
                audioObject != null
                    ? DetailedPlayer(
                        audioObject: audioObject,
                      )
                    : Container(),
          ),
      ],
    );
  }

  AppBar appBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Color(0xFFEFF0F6),
      toolbarHeight: 80,
      title: Center(
          child: Text('SETTINGS',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF414041)))),
    );
  }

  Widget body(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            tileColor: Colors.white,
            title: Text('Profile'),
            trailing: Icon(Icons.navigate_next),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProfilePage(),
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Divider(
              thickness: 0.20,
              height: 0.20,
            ),
          ),
          ListTile(
            tileColor: Colors.white,
            title: Text('Change Password'),
            trailing: Icon(Icons.navigate_next),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChangePasswordPage(),
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Divider(
              thickness: 0.20,
              height: 0.20,
            ),
          ),
          ListTile(
            tileColor: Colors.white,
            title: Text('About Us'),
            trailing: Icon(Icons.navigate_next),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => GetPages(
                            pageId: '1',
                            pageTitle: 'About Us',
                          )));
              // launch(
              //     'https://swarnimavasyojna.org/public/om-sakthi-music/about-us');
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Divider(
              thickness: 0.20,
              height: 0.20,
            ),
          ),
          ListTile(
            tileColor: Colors.white,
            title: Text('Privacy Policy'),
            trailing: Icon(Icons.navigate_next),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => GetPages(
                            pageId: '3',
                            pageTitle: 'Privacy Policy',
                          )));
              // launch(
              //     'https://swarnimavasyojna.org/public/om-sakthi-music/privacy-policy');
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Divider(
              thickness: 0.20,
              height: 0.20,
            ),
          ),
          ListTile(
            tileColor: Colors.white,
            title: Text('Terms & Condition'),
            trailing: Icon(Icons.navigate_next),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => GetPages(
                            pageId: '4',
                            pageTitle: 'Terms And Condition',
                          )));
              // launch(
              //     'https://swarnimavasyojna.org/public/om-sakthi-music/terms-and-condition');
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Divider(
              thickness: 0.20,
              height: 0.20,
            ),
          ),
          ListTile(
            tileColor: Colors.white,
            title: Text('Contact Us'),
            trailing: Icon(Icons.navigate_next),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => GetPages(
                            pageId: '2',
                            pageTitle: 'Contact Us',
                          )));
              // launch(
              //     'https://swarnimavasyojna.org/public/om-sakthi-music/contact-us');
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Divider(
              thickness: 0.20,
              height: 0.20,
            ),
          ),
          ListTile(
            tileColor: Colors.white,
            title: Text('Enable Notification'),
            trailing: Container(
              width: 50,
              child: FlutterSwitch(
                height: 25,
                width: 45,
                toggleSize: 20,
                activeColor: Color(0xFFFF2562),
                //inactiveColor: Color(0xFFEFF0F6),
                onToggle: (bool value) {
                  setState(() {
                    status = value;
                  });
                },
                value: status,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Divider(
              thickness: 0.20,
              height: 0.20,
            ),
          ),
          ListTile(
            tileColor: Colors.white,
            title: Text('Logout'),
            onTap: () {
              showAlert(context);
            },
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'v1.0',
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }

  showAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text("Are you sure you want to Logout?"),
          actions: <Widget>[
            FlatButton(
              child: Text("YES"),
              onPressed: () {
                _controller.logout(token);
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text("NO"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
