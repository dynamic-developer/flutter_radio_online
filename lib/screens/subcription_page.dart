import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';
import 'package:radio_online/api_calling/api_state.dart';
import 'package:radio_online/api_calling/controllers/add_subscription_controller.dart';
import 'package:radio_online/api_calling/controllers/last_login_controller.dart';
import 'package:radio_online/helper/providermodel.dart';
import 'package:radio_online/screens/pages.dart';

import 'login_page.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({Key? key}) : super(key: key);

  @override
  _SubscriptionPageState createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  InAppPurchaseConnection _iap = InAppPurchaseConnection.instance;
  final _controller = Get.put(AddSubscriptionController());
  final _lastLoginController = Get.put(LastLoginController());
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    isPage = true;
    var provider = Provider.of<ProviderModel>(context, listen: false);
    provider.initialize();
    provider.verifyPurchase();
    super.initState();
  }

  // @override
  // void dispose() {
  //   var provider = Provider.of<ProviderModel>(context, listen: false);
  //   provider.subscription.cancel();
  //   super.dispose();
  // }

  void _buyProduct(ProductDetails prod, provider) async {
    //TODO: remember to remove sanboxTesting in production build
    final PurchaseParam purchaseParam = PurchaseParam(
      productDetails: prod,
    );
    bool x = await _iap.buyNonConsumable(purchaseParam: purchaseParam);
    print("ADA TEST: PURCHASE COMPLATE : $x");
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ProviderModel>(context);
    if (provider.isPurchased) {
      for (var prod in provider.products)
        _controller.addSubscription(
            token, prod.currencyCode, prod.rawPrice.toString());
    }
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xFFEFF0F6),
      appBar: appBar(),
      body: Obx(() {
        printInfo(info: "_controller.state : ${_controller.state.toString()}");

        if (_controller.state is AddSubscriptionFailed) {
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
        if (_controller.state is AddSubscriptionError) {
          WidgetsBinding.instance!.addPostFrameCallback((_) {
            _scaffoldKey.currentState!.showSnackBar(SnackBar(
              content: Text(
                (_controller.state as AddSubscriptionError).message.toString(),
                textAlign: TextAlign.center,
              ),
              duration: Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
            ));
          });
        }
        if (_controller.state is AddSubscriptionLoaded) {
          WidgetsBinding.instance!.addPostFrameCallback((_) async {
            if ((_controller.state as AddSubscriptionLoaded)
                    .addSubscription
                    .result ==
                "success") {
              _controller.resetSubscription();
              Navigator.pop(context, true);
            }
          });
        }
        return body(provider);
      }),
    );
  }

  AppBar appBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: GestureDetector(
        onTap: () {
          Navigator.pop(context, false);
        },
        child: Icon(
          Icons.arrow_back,
          size: 30,
          color: Color(0xFF6270A1),
        ),
      ),
      backgroundColor: Color(0xFFEFF0F6),
      toolbarHeight: 80,
      centerTitle: true,
      title: Text('SUBSCRIPTION',
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF414041))),
    );
  }

  Widget body(provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var prod in provider.products)
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: Color(0xFFFF2562).withOpacity(0.20),
                      radius: 60,
                      child: CircleAvatar(
                        backgroundColor: Color(0xFFFF2562),
                        radius: 45,
                        child: Text(
                          prod.price,
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 25,
                ),
                Text('Yearly Package',
                    style: TextStyle(
                        fontSize: 20,
                        color: Color(0xFFFF2562),
                        fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 25,
                ),
                Text(
                  'Full aceess to all radio station',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black54,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'HD Music',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black54,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Add Free Streaming',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black54,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Unlimited Skips',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black54,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                subscriptionButton(prod, provider),
              ],
            ),
          ),
      ],
    );
  }

  Widget subscriptionButton(ProductDetails prod, provider) {
    return GestureDetector(
      onTap: () {
        print("PRODUCT Code: ${prod.currencyCode}");
        print("PRODUCT PRICE: ${prod.rawPrice}");
        print("PRODUCT TOKEN: ${token}");
        _buyProduct(prod, provider);
      },
      child: Container(
        width: 200,
        height: 40,
        decoration: BoxDecoration(
          color: Color(0xFFFF2562),
          borderRadius: BorderRadius.all(Radius.circular(80.0)),
        ),
        child: Center(
            child: Text(
          'Subscribe Now',
          style: TextStyle(
              fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
        )),
      ),
    );
  }
}
