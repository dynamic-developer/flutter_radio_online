import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:collection/collection.dart';

class ProviderModel with ChangeNotifier {
  InAppPurchaseConnection _iap = InAppPurchaseConnection.instance;
  bool available = true;
  late StreamSubscription subscription;
  final String myProductID = 'com.omsakthi.yearlysubscription';
  //final String myProductID = 'testing';
  //final String myProductID = 'com.omshakthi.omshakthimusic';

  bool _isPurchased = false;

  bool get isPurchased => _isPurchased;

  set isPurchased(bool value) {
    _isPurchased = value;
    notifyListeners();
  }

  List _purchases = [];

  List get purchases => _purchases;

  set purchases(List value) {
    _purchases = value;
    notifyListeners();
  }

  List _products = [];

  List get products => _products;

  set products(List value) {
    _products = value;
    notifyListeners();
  }

  void initialize() async {
    available = await _iap.isAvailable();
    print("AVAILABLE:$available");
    if (available) {
      await _getProducts();
      await _getPastPurchases();
      verifyPurchase();
      subscription = _iap.purchaseUpdatedStream.listen((data) {
        print("ADA::: DATA in PurchaseUpdateStream: ${data.first.status}");
        purchases.addAll(data);
        verifyPurchase();
      });
    }
  }

  void verifyPurchase() {
    PurchaseDetails? purchase = hasPurchased(myProductID);
    print(
        "ADA::: PURCHASE RES: ${purchases.length} , STATUS:: ${purchase?.status}");
    if (purchase != null && purchase.status == PurchaseStatus.purchased) {
      if (purchase.pendingCompletePurchase) {
        _iap.completePurchase(purchase);

        if (purchase.status == PurchaseStatus.purchased) {
          isPurchased = true;
        }
      }
    }
    print("PURCHASE:$purchase");
  }

  PurchaseDetails? hasPurchased(String productID) {
    PurchaseDetails? purchaseDetails = purchases
        .firstWhereOrNull((purchase) => purchase.productID == productID);
    print("PURCHASE DETAIL:$purchaseDetails");
    print("ADA:: PURCHASEDETAILS : ${purchaseDetails?.status}");
    return purchaseDetails;
  }

  Future<void> _getProducts() async {
    Set<String> ids = Set.from([myProductID]);
    ProductDetailsResponse response = await _iap.queryProductDetails(ids);
    products = response.productDetails;
    print("PRODUCT:${products}");
  }

  Future<void> _getPastPurchases() async {
    QueryPurchaseDetailsResponse response = await _iap.queryPastPurchases();
    for (PurchaseDetails purchase in response.pastPurchases) {
      if (Platform.isIOS) {
        _iap.consumePurchase(purchase);
      }
    }
    purchases = response.pastPurchases;
    print("PAST PURCHASE:${purchases}");
  }
}
