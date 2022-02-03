import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:radio_online/api_calling/api_state.dart';
import 'package:radio_online/api_calling/controllers/last_login_controller.dart';
import 'package:radio_online/api_calling/controllers/radio_list_controller.dart';
import 'package:radio_online/api_calling/models/radio_list.dart';
import 'package:radio_online/api_calling/models/user.dart';
import 'package:radio_online/helper/shared_pref.dart';
import 'package:radio_online/helper/widgets/player.dart';
import 'package:radio_online/helper/widgets/utils.dart';
import 'package:radio_online/screens/login_page.dart';
import 'package:radio_online/screens/pages.dart';
import 'package:radio_online/screens/profile_page.dart';
import 'package:radio_online/screens/subcription_page.dart';

import '../main.dart';

late AudioPlayerHandler audioHandler;
ValueNotifier<AudioObject?> currentlyPlaying = ValueNotifier(null);
List<Data>? radioData = [];
const double playerMinHeight = 76;
//const double playerMaxHeight = 370;
const miniplayerPercentageDeclaration = 0.2;
int count = 0;

int apiCount = 0;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = Get.put(RadioListController());
  final _lastLoginController = Get.put(LastLoginController());
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  SharedPref sharedPref = SharedPref();

  audioServiceInitialize() async {
    audioHandler = await AudioService.init(
      builder: () => AudioPlayerHandlerImpl(),
      config: const AudioServiceConfig(
        androidNotificationChannelId: 'com.ryanheise.myapp.channel.audio',
        androidNotificationChannelName: 'Audio playback',
        androidNotificationOngoing: true,
      ),
    );
    currentlyPlaying.value = AudioObject(
      radioData![0].radioName.toString(),
      radioData![0].radioName.toString(),
      radioData![0].radioStreamUrl.toString(),
    );
    await audioHandler.play();
  }

  @override
  void initState() {
    Future.delayed(Duration(seconds: 1), () {
      lastLoginApi();
    });

    super.initState();
  }

  lastLoginApi() async {
    await _lastLoginController.lastLogin(token).whenComplete(() async {
      if (_lastLoginController.state is LastLoginLoaded) {
        UserAuth userSave =
            (_lastLoginController.state as LastLoginLoaded).user;
        await sharedPref.save("user", userSave);
        print("IN DATE STATE:${userSave.result}");
      }
      userLoad = UserAuth.fromJson(await sharedPref.read("user"));
      print("IN INIT STATE :${userLoad.data!.subscriptionStartDate}");
      if (userLoad.data!.status != null) {
        if (int.parse(userLoad.data!.status.toString()) != 1) {
          await sharedPref.remove("user");
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (_) => LoginPage()), (r) => false);
        }
      }
      if (userLoad.data!.subscriptionStartDate != null &&
          userLoad.data!.subscriptionEndDate != null) {
        DateTime startDate =
            DateTime.parse(userLoad.data!.subscriptionStartDate);
        DateTime endDate = DateTime.parse(userLoad.data!.subscriptionEndDate);
        DateTime now = DateTime.now();
        print('now: $now');
        print('startDate: $startDate');
        print('endDate: $endDate');
        print(startDate.isBefore(now));
        print(endDate.isAfter(now));
        if (startDate.isBefore(now) == true && endDate.isAfter(now) == true) {
          print("ALL VALID!");
          isSubscribe = true;
          if (mounted) {
            setState(() {});
          }
        } else {
          print("NOT VALID!");
          if (isSubscribe == true) {
            audioHandler.pause();
            audioHandler.onNotificationDeleted();
          }
          isSubscribe = false;
          if (mounted) {
            setState(() {});
          }
        }
      } else {
        if (isSubscribe == true) {
          audioHandler.pause();
          audioHandler.onNotificationDeleted();
        }
        isSubscribe = false;
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print("CHECK SUBSCRIPTION:${isSubscribe}");
    return WillPopScope(
        onWillPop: () async => false,
        child: Stack(
          children: [
            Scaffold(
              key: _scaffoldKey,
              backgroundColor: Color(0xFFEFF0F6),
              appBar: appBar(),
              body: Obx(() {
                if (_lastLoginController.state is LastLoginFailed) {
                  WidgetsBinding.instance!.addPostFrameCallback((_) {
                    switch (source.keys.toList()[0]) {
                      case ConnectivityResult.mobile:
                        _lastLoginController.lastLogin(token);
                        break;
                      case ConnectivityResult.wifi:
                        _lastLoginController.lastLogin(token);
                        break;
                      case ConnectivityResult.none:
                      default:
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                            'Check Your Internet Connection',
                            textAlign: TextAlign.center,
                          ),
                          duration: Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                        ));
                    }
                  });
                }
                if (_lastLoginController.state is LastLoginError) {
                  WidgetsBinding.instance!.addPostFrameCallback((_) {
                    print("HIIIIIIIIII");
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                        (_lastLoginController.state as LastLoginError)
                            .message
                            .toString(),
                        textAlign: TextAlign.center,
                      ),
                      duration: Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                    ));

                    if ((_lastLoginController.state as LastLoginError)
                            .message ==
                        'Login Expired') {
                      Future.delayed(const Duration(seconds: 2), () {
                        ScaffoldMessenger.of(context).clearSnackBars();
                      });
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (_) => LoginPage()),
                          (r) => false);
                    }
                  });
                }
                if (_lastLoginController.state is LastLoginLoaded) {
                  WidgetsBinding.instance!.addPostFrameCallback((_) async {
                    UserAuth userSave =
                        (_lastLoginController.state as LastLoginLoaded).user;
                    if (apiCount == 0) {
                      if (userSave.data!.name == null ||
                          userSave.data!.countryCode == null ||
                          userSave.data!.mobile == null ||
                          userSave.data!.birthDate == null ||
                          userSave.data!.gender == null) {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => ProfilePage()));
                      }
                      _controller.radioList(token);
                      apiCount = apiCount + 1;
                    }
                  });
                }
                if (_controller.state is RadioListFailed) {
                  WidgetsBinding.instance!.addPostFrameCallback((_) {
                    switch (source.keys.toList()[0]) {
                      case ConnectivityResult.mobile:
                        _controller.radioList(token);
                        break;
                      case ConnectivityResult.wifi:
                        _controller.radioList(token);
                        break;
                      case ConnectivityResult.none:
                      default:
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                            'Check Your Internet Connection',
                            textAlign: TextAlign.center,
                          ),
                          duration: Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                        ));
                    }
                  });
                }
                if (_controller.state is RadioListError) {
                  WidgetsBinding.instance!.addPostFrameCallback((_) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                        (_controller.state as RadioListError)
                            .message
                            .toString(),
                        textAlign: TextAlign.center,
                      ),
                      duration: Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                    ));

                    if ((_controller.state as RadioListError).message ==
                        'Login Expired') {
                      Future.delayed(const Duration(seconds: 2), () {
                        ScaffoldMessenger.of(context).clearSnackBars();
                      });
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (_) => LoginPage()),
                          (s) => false);
                    }
                  });
                }
                if (_controller.state is RadioListLoaded) {
                  ScaffoldMessenger.of(context).clearSnackBars();
                  radioData =
                      (_controller.state as RadioListLoaded).radioList.data;
                  if (userLoad.data!.status == "1") {
                    if (isSubscribe == true) {
                      count = count + 1;
                      if (count == 1) {
                        audioServiceInitialize();
                      } else {
                        print("COUNT: $count");
                        if (isPage == true) {
                          audioHandler.play();
                        }
                      }
                    }
                  }

                  return body((_controller.state as RadioListLoaded).radioList);
                }
                return Container(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFFFF2562),
                    ),
                  ),
                );
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
            if (isSubscribe == false)
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                    color: Colors.white,
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(children: [
                            TextSpan(
                              text: 'You have no subscription - Please ',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF414041),
                                  fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  _navigateAndDisplaySelection(context);
                                  // Navigator.push(
                                  //    context,
                                  //    MaterialPageRoute(
                                  //        builder: (_) => SubscriptionPage()));
                                },
                              text: ' Subscribe',
                              style: TextStyle(
                                  color: Color(0xFFFF2562),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ])),
                    )),
              ),
          ],
        ));
  }

  _navigateAndDisplaySelection(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SubscriptionPage()),
    );

    //below you can get your result and update the view with setState
    //changing the value if you want, i just wanted know if i have to
    //update, and if is true, reload state
    if (result != null) {
      if (result) {
        print("OHH ITS GOOD");
        isSubscribe = true;
        setState(() {});
      }
    }
  }

  AppBar appBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Color(0xFFEFF0F6),
      toolbarHeight: 80,
      title: Center(
          child: Text('RADIO STATION',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF414041)))),
    );
  }

  Widget body(RadioList radioList) {
    return RefreshIndicator(
        onRefresh: () => Future.delayed(Duration(seconds: 5))
            .then((value) => _controller.radioList(token)),
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 80),
          child: ListView.builder(
              // physics: BouncingScrollPhysics(),
              itemCount: radioList.data!.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () async {
                    if (isSubscribe == true) {
                      if (audioHandler.mediaItem.value!.id !=
                          radioList.data![index].radioStreamUrl.toString()) {
                        audioHandler.skipToQueueItem(index);
                      }
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 15.0,
                      top: 12,
                    ),
                    child: Column(
                      children: [
                        Row(children: [
                          CircleAvatar(
                            radius: 38,
                            backgroundColor: Colors.white,
                            backgroundImage: NetworkImage(
                              radioList.data![index].radioImage.toString(),
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            radioList.data![index].radioName.toString(),
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w800),
                          ),
                        ]),
                        // SizedBox(
                        //   height: 10,
                        // )
                      ],
                    ),
                  ),
                );
              }),
        ));
  }

  // ListView listView(RadioList radioList) {
  //   return
  // }
}
