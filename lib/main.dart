import 'package:connectivity/connectivity.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';
import 'package:radio_online/api_calling/controllers/country_controller.dart';
import 'package:radio_online/helper/shared_pref.dart';
import 'package:radio_online/screens/home-page.dart';
import 'package:radio_online/screens/login_page.dart';
import 'package:radio_online/screens/notification_page.dart';
import 'package:radio_online/screens/pages.dart';
import 'api_calling/api_service.dart';
import 'api_calling/api_state.dart';
import 'api_calling/models/user.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'helper/network_connectivity.dart';
import 'helper/providermodel.dart';

String deviceId = "";
UserAuth userLoad = UserAuth();
Map source = {ConnectivityResult.none: false};
final MyConnectivity _connectivity = MyConnectivity.instance;
const AndroidNotificationChannel channel = AndroidNotificationChannel(
    "id", "name", "description",
    importance: Importance.high, playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('A background message just shoes up : ${message.messageId}');
}

Future<void> main() async {
  InAppPurchaseConnection.enablePendingPurchases();

  runApp(ChangeNotifierProvider(
      create: (context) => ProviderModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MyApp(),
      )));
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // await flutterLocalNotificationsPlugin
  //     .resolvePlatformSpecificImplementation<
  //         AndroidFlutterLocalNotificationsPlugin>()
  //     ?.createNotificationChannel(channel);
  // await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
  //   alert: true,
  //   badge: true,
  //   sound: true,
  // );
  // FirebaseMessaging.instance.getToken().then((token) {
  //   deviceId = token!;
  //   print("Device Token:$token");
  // });
  _connectivity.initialise();
  _connectivity.myStream.listen((sources) {
    source = sources;
  });
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  SharedPref sharedPref = SharedPref();
  final _controller = Get.put(CountryController());
  late final FirebaseMessaging _messaging;

  void registerNotification() async {
    // 1. Initialize the Firebase app
    await Firebase.initializeApp();

    // 2. Instantiate Firebase Messaging
    _messaging = FirebaseMessaging.instance;

    // 3. On iOS, this helps to take the user permissions
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );
    FirebaseMessaging.instance.getToken().then((token) {
      deviceId = token!;
      print("Device Token:$token");
    });
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');

      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);

//TODO:IOS notification creation
      // For handling the received notifications
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        flutterLocalNotificationsPlugin.show(
            message.notification.hashCode,
            message.notification?.title,
            message.notification?.body,
            NotificationDetails(
                android: AndroidNotificationDetails(
                    channel.id, channel.name, channel.description,
                    color: Colors.blue,
                    playSound: true,
                    icon: '@mipmap/ic_launcher')));
        print(
            'Message title: ${message.notification?.title}, body: ${message.notification?.body}, data: ${message.data}');
      });

      FirebaseMessaging.instance
          .getInitialMessage()
          .then((RemoteMessage? message) async {
        print("FirebaseMessaging.getInitialMessage");
        if (message != null) {
          UserAuth user = UserAuth.fromJson(await sharedPref.read("user"));
          userLoad = user;
          Get.to(Pages(
            page: NotificationPage(),
            index: 2,
          ));
        }
      });

      FirebaseMessaging.onMessageOpenedApp
          .listen((RemoteMessage message) async {
        print("onMessageOpenedApp: $message");
        UserAuth user = UserAuth.fromJson(await sharedPref.read("user"));
        userLoad = user;
        Get.to(Pages(
          page: NotificationPage(),
          index: 2,
        ));
      });
    } else {
      print('User declined or has not accepted permission');
    }
    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    //   print("onMessageOpenedApp: $message");
    //   Get.to(Pages(
    //     page: NotificationPage(),
    //     index: 2,
    //   ));
    // });
  }

  Future loadSharedPrefs() async {
    try {
      UserAuth user = UserAuth.fromJson(await sharedPref.read("user"));
      userLoad = user;
      return user;
    } catch (e) {
      // do something
    }
  }

  @override
  void initState() {
    registerNotification();
    _controller.country();
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   RemoteNotification? notification = message.notification;
    //   AndroidNotification? android = message.notification?.android;
    //   if (notification != null && android != null) {
    //     // flutterLocalNotificationsPlugin.show(
    //     //     notification.hashCode,
    //     //     notification.title,
    //     //     notification.body,
    //     //     NotificationDetails(
    //     //         android: AndroidNotificationDetails(
    //     //             channel.id, channel.name, channel.description,
    //     //             color: Colors.blue,
    //     //             playSound: true,
    //     //             icon: '@mipmap/ic_launcher')));
    //   }
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Radio App',
      home: Scaffold(
        key: _scaffoldKey,
        body: Obx(() {
          if (_controller.state is CountryFailed) {
            WidgetsBinding.instance!.addPostFrameCallback((_) {
              switch (source.keys.toList()[0]) {
                case ConnectivityResult.mobile:
                  _controller.country();
                  break;
                case ConnectivityResult.wifi:
                  _controller.country();
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
          if (_controller.state is CountryLoaded) {
            return body();
          }
          return Container(
            color: Color(0xFFEFF0F6),
            child: Center(
              child: CircularProgressIndicator(
                color: Color(0xFFFF2562),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget body() {
    print("RELEASE MODE: $kReleaseMode , DEBUG MODE: $kDebugMode");
    return FutureBuilder<dynamic>(
      future: loadSharedPrefs(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return snapshot.data == null
              ? LoginPage()
              : Pages(
                  page: HomePage(),
                  index: 0,
                );
        } else {
          return Container(
            color: Color(0xFFEFF0F6),
            child: Center(
              child: CircularProgressIndicator(
                color: Color(0xFFFF2562),
              ),
            ),
          );
        }
      },
    );
  }
}
