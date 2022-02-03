import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:radio_online/api_calling/api_state.dart';
import 'package:radio_online/api_calling/controllers/pages_controller.dart';
import 'package:radio_online/helper/network_connectivity.dart';
import 'package:radio_online/screens/pages.dart';
import 'login_page.dart';

class GetPages extends StatefulWidget {
  final pageId;
  final pageTitle;

  const GetPages({Key? key, this.pageId, this.pageTitle}) : super(key: key);

  @override
  _GetPagesState createState() => _GetPagesState(pageId, pageTitle);
}

class _GetPagesState extends State<GetPages> {
  final pageId;
  final pageTitle;
  final _controller = Get.put(GetPagesController());

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Map _source = {ConnectivityResult.none: false};

  final MyConnectivity _connectivity = MyConnectivity.instance;

  _GetPagesState(this.pageId, this.pageTitle);

  @override
  void initState() {
    _controller.getPages(pageId, '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xFFEFF0F6),
      appBar: appBar(context),
      body: Obx(() {
        if (_controller.state is PagesFailed) {
          WidgetsBinding.instance!.addPostFrameCallback((_) {
            switch (_source.keys.toList()[0]) {
              case ConnectivityResult.mobile:
                _controller.getPages(pageId, token);
                break;
              case ConnectivityResult.wifi:
                _controller.getPages(pageId, token);
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
        if (_controller.state is PagesError) {
          WidgetsBinding.instance!.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                (_controller.state as PagesError).message.toString(),
                textAlign: TextAlign.center,
              ),
              duration: Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
            ));

            if ((_controller.state as PagesError).message == 'Login Expired') {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => LoginPage()));
            }
          });
        }
        if (_controller.state is PagesLoaded) {
          ScaffoldMessenger.of(context).clearSnackBars();

          return body((_controller.state as PagesLoaded)
              .getPages
              .data!
              .pageDescription
              .toString());
        }
        return Container(
          child: Center(
            child: CircularProgressIndicator(
              color: Color(0xFFFF2562),
            ),
          ),
        );
      }),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xFFEFF0F6),
      toolbarHeight: 80,
      leading: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Icon(
          Icons.arrow_back,
          size: 30,
          color: Color(0xFF6270A1),
        ),
      ),
      centerTitle: true,
      title: Text(pageTitle,
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF6270A1))),
    );
  }

  Widget body(String text) {
    return SingleChildScrollView(
      child: Container(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
          child: Html(data: text)),
    );
  }
}
