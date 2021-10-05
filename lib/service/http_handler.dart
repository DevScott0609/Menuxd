import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import './session.dart';
import '../models/ad.dart';
import '../models/category.dart';
import '../models/dish.dart';
import '../models/order.dart';
import '../models/promotion.dart';
import '../models/question.dart';
import '../models/rate.dart';
import '../models/restaurant_client.dart';
import '../models/table.dart';
import '../models/user.dart';
import '../models/waiter.dart';

const API_SERVER = "http://104.248.75.235:5000/api/v1";

class HttpHandler {
  Session session;
  RestaurantClient restaurantClient;
  static final HttpHandler _instance = HttpHandler._();
  HttpHandler._();
  factory HttpHandler() => _instance;

  Future<Session> login(String user, String password) async {
    final url = "$API_SERVER/login";

    try {
      http.Response response = await http.post(url,
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.acceptHeader: 'application/json',
          },
          body: json.encode({"email": user, "password": password}));

      if (response.statusCode == 200) {
        final jsonData = json.decode(utf8.decode(response.bodyBytes));

        session = Session()
          ..setLoginData(jsonData["token"], User.fromJson(jsonData["user"]));
        return session;
      } else {
        return null;
      }
    } catch (ex) {
      return null;
    }
  }

  Future<List> getRestaurantsClients() async {
    final url = "$API_SERVER/clients/user/${session.user.id}";

    final headers = getHeader();
    try {
      final response = await http.get(url, headers: headers);
      print(utf8.decode(response.bodyBytes));
      if (response.statusCode == 200) {
        final jsonArray = json.decode(utf8.decode(response.bodyBytes));
        List list = jsonArray.map((element) {
          return RestaurantClient.fromJson(element);
        }).toList();
        return list;
      }
    } catch (error) {
      print(error);
    }
    return [];
  }

  Future<List<Category>> getCategories() async {
    final url = "$API_SERVER/categories/client/${restaurantClient.id}";

    http.Response response = await http.get(
      url,
      headers: getHeader(),
    );

    if (response.statusCode == 200) {
      final jsonList = json.decode(utf8.decode(response.bodyBytes)) as List;
      return jsonList.map((value) {
        return Category.fromJson(value);
      }).toList();
    }
    return [];
  }

  Future<List<Ad>> getAds() async {
    final url = "$API_SERVER/ads/client/${restaurantClient.id}";
    http.Response response = await http.get(
      url,
      headers: getHeader(),
    );
    if (response.statusCode == 200) {
      final jsonList = json.decode(utf8.decode(response.bodyBytes)) as List;
      return jsonList.map((value) {
        return Ad.fromJson(value);
      }).toList();
    }
    return [];
  }

  Future<List<Promotion>> getPromotions() async {
    final url = "$API_SERVER/promotions/client/${restaurantClient.id}";

    http.Response response = await http.get(
      url,
      headers: getHeader(),
    );

    if (response.statusCode == 200) {
      final jsonList = json.decode(utf8.decode(response.bodyBytes)) as List;
      return jsonList.map((value) {
        return Promotion.fromJson(value);
      }).toList();
    }
    return [];
  }

  Future<List<Question>> getQuestions() async {
    final url = "$API_SERVER/questions/client/${restaurantClient.id}";

    http.Response response = await http.get(
      url,
      headers: getHeader(),
    );
    List<Question> list = [];
    if (response.statusCode == 200) {
      final jsonList = json.decode(utf8.decode(response.bodyBytes)) as List;
      list = jsonList.map((value) {
        return Question.fromJson(value);
      }).toList();
    }
    if (list.isEmpty) {
      list = [
        Question(
            text: "No se encontro ninguna pregunta en el servidor",
            id: -1,
            clientId: -1)
      ];
    }

    return list;
  }

  Future<bool> sendPromotionClick(Promotion promotion) async {
    final url = "$API_SERVER/promotions/add-click/${promotion.id}";

    http.Response response = await http.post(
      url,
      headers: getHeader(),
    );
    print(utf8.decode(response.bodyBytes));
    return response.statusCode == 200;
  }

  Future<bool> sendAdClick(Ad ad) async {
    final url = "$API_SERVER/ads/add-click/${ad.id}";

    http.Response response = await http.post(
      url,
      headers: getHeader(),
    );
    print(utf8.decode(response.bodyBytes));

    return response.statusCode == 200;
  }

  Future<List<RestaurantTable>> getTables() async {
    final url = "$API_SERVER/tables/client/${restaurantClient.id}";

    http.Response response = await http.get(
      url,
      headers: getHeader(),
    );

    if (response.statusCode == 200) {
      final jsonList = json.decode(utf8.decode(response.bodyBytes)) as List;
      return jsonList.map((value) {
        return RestaurantTable.fromJson(value);
      }).toList();
    }
    return [];
  }

  Future<List<Dish>> getDishes(Category category) async {
    final url = "$API_SERVER/dishes/category/${category.id}";
    //
    http.Response response = await http.get(
      url,
      headers: getHeader(),
    );

    if (response.statusCode == 200) {
      final jsonList = json.decode(utf8.decode(response.bodyBytes)) as List;
      return jsonList.map((value) {
        return Dish.fromJson(value);
      }).toList();
    }
    return [];
  }

  Future<Dish> getDish(int id) async {
    final url = "$API_SERVER/dishes/$id";
    //
    http.Response response = await http.get(
      url,
      headers: getHeader(),
    );

    if (response.statusCode == 200) {
      final jsonList = json.decode(utf8.decode(response.bodyBytes));
      return Dish.fromJson(jsonList);
    }
    return null;
  }

  Future<Waiter> checkWaiterCode(String code) async {
    final url = "$API_SERVER/waiters/client/${restaurantClient.id}";

    http.Response response = await http.get(url, headers: getHeader());

    final list = json.decode(utf8.decode(response.bodyBytes)) as List;
    Waiter waiterLogged;
    final list2 = list.map((element) {
      return Waiter.fromJson(element);
    });
    for (Waiter waiter in list2) {
      if (waiter.pin == code) {
        waiterLogged = waiter;
        break;
      }
    }

    return waiterLogged;
  }

  Map<String, String> getHeader() {
    return {
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.authorizationHeader: "Bearer ${session.accessToken}"
    };
  }

  /// se envia el ratings
  Future<bool> sendRating(Rate rating) async {
    final url = "$API_SERVER/ratings/";
    final body = json.encode(rating.toJson());
    http.Response response = await http.post(
      url,
      body: body,
      headers: getHeader(),
    );

    return response.statusCode == 201;
  }

  /// se inicia una nueva orden
  Future<int> sendOrder(Order order) async {
    order.clientId = restaurantClient.id;
    final url = "$API_SERVER/orders";
    final body = json.encode(order.toJson(sendItems: false));
    print(body);
    http.Response response = await http.post(
      url,
      body: body,
      headers: getHeader(),
    );

    if (response.statusCode == 201) {
      final orderJson = json.decode(utf8.decode(response.bodyBytes));
      print(orderJson);
      final id = orderJson["id"];
      order.id = id;
      addToOrder(order);
      return id;
    } else {
      return null;
    }
  }

  Future<bool> addToOrder(Order order) async {
    final url =
        "$API_SERVER/orders/add/${order.id}/client/${restaurantClient.id}";
    final news = order.getNewsDishes();
    final jsonData = json.encode(news);

    print(jsonData);
    http.Response response = await http.put(
      url,
      body: jsonData,
      headers: getHeader(),
    );
    return response.statusCode == 200;
  }

  Future<bool> callWaiter(Order order) async {
    final url = "$API_SERVER/orders/call/${order.table.id}/waiter";
    http.Response response = await http.get(
      url,
      headers: getHeader(),
    );

    final state = response.statusCode == 200;
    print("call waiter $state ${response.statusCode}");
    return state;
  }

  Future<bool> callBill(Order order) async {
    final url = "$API_SERVER/orders/call/${order.table.id}/bill";
    http.Response response = await http.get(
      url,
      headers: getHeader(),
    );

    final state = response.statusCode == 200;
    print("call bill $state ${response.statusCode} $url");
    return state;
  }

  void sendStay(DateTime init) async {
    final url = "$API_SERVER/stay";
    final body = json.encode(
        {"time": init.millisecondsSinceEpoch, "clientId": restaurantClient.id});
    http.Response response = await http.post(
      url,
      body: body,
      headers: getHeader(),
    );
    print(utf8.decode(response.bodyBytes));
  }
}
