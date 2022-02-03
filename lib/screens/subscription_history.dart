import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:radio_online/api_calling/api_state.dart';
import 'package:radio_online/api_calling/controllers/get_subscription_controller.dart';
import 'package:radio_online/api_calling/models/get_subscription.dart';
import 'package:radio_online/helper/widgets/player.dart';
import 'package:radio_online/helper/widgets/utils.dart';
import 'package:radio_online/screens/pages.dart';
import 'package:intl/intl.dart';
import '../main.dart';
import 'home-page.dart';
import 'login_page.dart';

class SubscriptionHistory extends StatefulWidget {
  const SubscriptionHistory({Key? key}) : super(key: key);

  @override
  _SubscriptionHistoryState createState() => _SubscriptionHistoryState();
}

class _SubscriptionHistoryState extends State<SubscriptionHistory> {
  final _controller = Get.put(GetSubscriptionController());
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    isPage = false;
    _controller.getSubscription(token);
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
            if (_controller.state is GetSubscriptionFailed) {
              WidgetsBinding.instance!.addPostFrameCallback((_) {
                switch (source.keys.toList()[0]) {
                  case ConnectivityResult.mobile:
                    _controller.getSubscription(token);
                    break;
                  case ConnectivityResult.wifi:
                    _controller.getSubscription(token);
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
            }
            if (_controller.state is GetSubscriptionError) {
              if ((_controller.state as GetSubscriptionError).message ==
                  'data not found') {
                return Center(
                  child: Text(
                    'No subscription available.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Get.theme.errorColor),
                  ),
                );
              } else {
                WidgetsBinding.instance!.addPostFrameCallback((_) {
                  _scaffoldKey.currentState!.showSnackBar(SnackBar(
                    content: Text(
                      (_controller.state as GetSubscriptionError)
                          .message
                          .toString(),
                      textAlign: TextAlign.center,
                    ),
                    duration: Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                  ));

                  if ((_controller.state as GetSubscriptionError).message ==
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
            if (_controller.state is GetSubscriptionLoaded) {
              GetSubscription subscription =
                  (_controller.state as GetSubscriptionLoaded).getSubscription;
              return body(subscription);
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

  AppBar appBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Color(0xFFEFF0F6),
      toolbarHeight: 80,
      title: Center(
          child: Text('SUBSCRIPTION',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF414041)))),
    );
  }

  Widget body(GetSubscription subscription) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 20,
          ),
          Flexible(child: listView(subscription))
        ],
      ),
    );
  }

  Widget listView(GetSubscription subscription) {
    return RefreshIndicator(
      onRefresh: () => _controller.getSubscription(token),
      child: ListView.builder(
          itemCount:
              subscription.data!.length > 0 ? subscription.data!.length : 0,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 8,
                ),
                Text(
                  "Payment Method - [${subscription.data![index].paymentMethod ?? ''}]",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  "Amount",
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
                SizedBox(
                  height: 4,
                ),
                Text("₹ ${subscription.data![index].amount ?? ''}",
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w400)),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Subscription Period",
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                    "${subscription.data![index].subscriptionStartDate ?? ''} to ${subscription.data![index].subscriptionEndDate ?? ''}",
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w400)),
                SizedBox(
                  height: 8,
                ),
                Text(
                  "Subscription Date & Time",
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
                SizedBox(
                  height: 4,
                ),

                Text(
                    "${ Jiffy(subscription.data![index].createdAt ?? '')
                        .format('yyyy-MM-dd hh:mm a')}",
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w400)),
                SizedBox(
                  height: 8,
                ),
                Divider()
              ],
            );
          }),
    );
  }
}
