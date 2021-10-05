import 'package:flutter/cupertino.dart';
import '../service/http_handler.dart';
import '../models/ad.dart';
import '../models/order.dart';
import '../models/promotion.dart';
import '../models/question.dart';
import '../models/rate.dart';
import '../models/table.dart';
import '../models/waiter.dart';
import '../utils/preferences.dart';

class OrdersProvider extends ChangeNotifier {
  Waiter _waiter;
  Order _order = Order();
  HomePopup _homePopup;
  Preferences _preferences;
  bool payBillCalled = false;
  bool _callingWaiter = false;
  List<Question> questions;
  List<Promotion> _promotions;
  List<Promotion> notifications = [];
  OrdersProvider();
  bool payed = false;
  DateTime init;
  get callingWaiter {
    return _callingWaiter;
  }

  void setTable(RestaurantTable table, {bool resetOrder = true}) {
    if (resetOrder) {
      reset();
    }
    _order.table = table;
    notifyListeners();
  }

  RestaurantTable get table => _order.table;

  set waiter(Waiter waiter) {
    _waiter = waiter;
  }

  void reset() {
    //Se resetea las ordenes
    _order = Order(table: this.table);
    notifyListeners();
    _preferences.order = _order;
  }

  Waiter get waiter => _waiter;

  void addOrder(OrderItem orderToAdd) {
    orderToAdd.orderId = this.order.id;
    for (OrderItem order in _order.items) {
      if (order.dish == orderToAdd.dish && !order.locked) {
        order.mount += orderToAdd.mount;
        _preferences.order = _order;
        notifyListeners();
        return;
      }
    }
    payed = false;
    _order.items.add(orderToAdd);
    notifyListeners();
    _preferences.order = _order;
  }

  void updateOrder(OrderItem orderItem, int index) {
    orderItem.orderId = this.order.id;
    _order.items[index] = orderItem;
    payed = false;
    notifyListeners();
    _preferences.order = _order;
  }

  void delete(OrderItem order) {
    _order.items.remove(order);
    notifyListeners();
    _preferences.order = _order;
  }

  bool get availablePayNow {
    final available = (_order != null && _order.getNewsDishes().isEmpty);
    return available && _order.items.isNotEmpty && !payed;
  }

  Order get order => _order;
  set order(Order value) {
    _order = value;
    _preferences.order = _order;
    notifyListeners();
  }

  HomePopup get homePopup {
    return _homePopup;
  }

  set homePopup(HomePopup value) {
    _homePopup = value;
    notifyListeners();
  }

  void orderNow() async {
    if (_order.id == null) {
      HttpHandler().sendStay(init);
      _order.id = await HttpHandler().sendOrder(_order);
    } else {
      HttpHandler().addToOrder(order);
    }

    _order.lockedOrder();
    _preferences.order = _order;
    notifyListeners();
  }

  void callWaiter() async {
    HttpHandler().callWaiter(_order);
    _callingWaiter = true;
    notifyListeners();
    await Future.delayed(Duration(seconds: 20));
    _callingWaiter = false;
    notifyListeners();
  }

  void callWaiter2() {
    _callingWaiter = false;
    notifyListeners();
  }

  void payTheBill() {
    HttpHandler().callBill(_order);
    payed = true;
  }

  void rateExperience(Rate rating) {
    HttpHandler().sendRating(rating);
  }

  Preferences get preferences => _preferences;

  set preferences(Preferences value) {
    _preferences = value;
    order = _preferences.order;
  }

  List<Promotion> get promotions {
    return _promotions ?? [];
  }

  set promotions(List<Promotion> value) {
    _promotions = value;
    Future.delayed(Duration(seconds: 50)).then((value) {
      notifications = _promotions;
      notifyListeners();
    });
  }
}

enum HomePopup { ORDERS, LANGUAGE, NOTIFICATIONS, ORDER_ADDED }

class HomeAlertDialog {
  HomeAlertDialog(this.alertWidget);
  final Widget alertWidget;
}

final DEFAULT_PROMOTIONS = [
  Promotion(
      title: "Promoción por defecto 1",
      picture: "http://104.248.75.235:5000/public/promotion-default-01.png",
      id: -1),
  Promotion(
      title: "Promoción por defecto 2",
      picture: "http://104.248.75.235:5000/public/promotion-default-02.png",
      id: -1),
];
final DEFAULT_ADS = [
  Ad(
      id: -1,
      picture: "http://104.248.75.235:5000/public/ad-default-01.png",
      url: "http://104.248.75.235:5000/public/ad-default-01.png"),
  Ad(
      id: -2,
      picture: "http://104.248.75.235:5000/public/ad-default-02.png",
      url: "http://104.248.75.235:5000/public/ad-default-02.png"),
];
