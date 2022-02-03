import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:radio_online/api_calling/api_state.dart';
import 'package:radio_online/api_calling/controllers/notification_controller.dart';
import 'package:radio_online/api_calling/models/notification.dart';
import 'package:radio_online/helper/widgets/player.dart';
import 'package:radio_online/helper/widgets/utils.dart';
import 'package:radio_online/screens/pages.dart';
import '../main.dart';
import 'home-page.dart';
import 'login_page.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final _controller = Get.put(NotificationController());

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    isPage = false;
    _controller.notification(token);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          key: _scaffoldKey,
          backgroundColor: Color(0xFFEFF0F6),
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Color(0xFFEFF0F6),
            toolbarHeight: 80,
            title: Center(
                child: Text('NOTIFICATION',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF414041)))),
          ),
          body: Obx(() {
            if (_controller.state is NotificationFailed) {
              WidgetsBinding.instance!.addPostFrameCallback((_) {
                switch (source.keys.toList()[0]) {
                  case ConnectivityResult.mobile:
                    _controller.notification(token);
                    break;
                  case ConnectivityResult.wifi:
                    _controller.notification(token);
                    break;
                  case ConnectivityResult.none:
                  default:
                    _scaffoldKey.currentState!.showSnackBar(SnackBar(
                      content: Text(
                        'Check Your Internet Connection',
                        textAlign: TextAlign.center,
                      ),
                      duration: Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                    ));
                }
              });

              // return Text(
              //   (_controller.state as RadioListFailed).message.toString(),
              //   textAlign: TextAlign.center,
              //   style: TextStyle(color: Get.theme.errorColor),
              // );
            }
            if (_controller.state is NotificationError) {
              if ((_controller.state as NotificationError).message ==
                  'Data not found.') {
                return Center(
                  child: Text(
                    'No notification available.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Get.theme.errorColor),
                  ),
                );
              } else {
                WidgetsBinding.instance!.addPostFrameCallback((_) {
                  _scaffoldKey.currentState!.showSnackBar(SnackBar(
                    content: Text(
                      (_controller.state as NotificationError)
                          .message
                          .toString(),
                      textAlign: TextAlign.center,
                    ),
                    duration: Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                  ));

                  if ((_controller.state as NotificationError).message ==
                      'Login Expired') {
                    Future.delayed(const Duration(seconds: 2), () {
                      ScaffoldMessenger.of(context).clearSnackBars();
                    });
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (_) => LoginPage()));
                  }
                });
              }
            }
            if (_controller.state is NotificationLoaded) {
              NotificationList notification =
                  (_controller.state as NotificationLoaded).notification;
              return body(notification);
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
          builder:
              (BuildContext context, AudioObject? audioObject, Widget? child) =>
                  audioObject != null
                      ? DetailedPlayer(
                          audioObject: audioObject,
                        )
                      : Container(),
        ),
      ],
    );
  }

  Widget body(NotificationList notification) {
    return SafeArea(
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              Flexible(child: listView(notification))
            ],
          )),
    );
  }

  Widget listView(NotificationList notification) {
    final List<Color> _color = [
      Color(0xFFFF2562),
      Color(0xFF004C6E),
      Color(0xFF07D2E5)
    ];
    return RefreshIndicator(
      onRefresh: () => _controller.notification(token),
      child: ListView.builder(
          itemCount: notification.data!.length,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: [
                GestureDetector(
                  onTap: () {
                    showAlertDialog(
                        context,
                        notification.data![index].title.toString(),
                        notification.data![index].message.toString());
                  },
                  child: Container(
                    child: Row(
                      children: [
                        Flexible(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                notification.data![index].title.toString(),
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w800),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 10,
                                    child: Text(
                                      notification.data![index].message
                                          .toString(),
                                      overflow: TextOverflow.fade,
                                      softWrap: false,
                                      style:
                                          Theme.of(context).textTheme.caption,
                                    ),
                                  ),
                                  Spacer(),
                                  Text(
                                    Jiffy(notification.data![index].createdAt ?? '')
                                        .fromNow(),
                                    overflow: TextOverflow.fade,
                                    softWrap: false,
                                    style: TextStyle(
                                        color: Color(0xFF191E2F),
                                        fontSize: 11,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Divider()
              ],
            );
          }),
    );
  }

  showAlertDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(child: Text(message)),
          actions: [
            FlatButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }
}
