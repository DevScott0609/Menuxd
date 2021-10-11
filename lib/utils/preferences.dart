import 'dart:convert';
import '../service/session.dart';
import '../models/order.dart';
import '../models/restaurant_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  SharedPreferences _prefs;

  String _language;
  String _email;
  String _password;
  Session _session;
  RestaurantClient _restaurantClient;
  Order _order = Order();
  Future<SharedPreferences> get preferences async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
    return _prefs;
  }

  Future<Preferences> init() async {
    final prefs = await preferences;
    final sessionString = prefs.get("session");
    //final clientString = prefs.get("client_json");
    final orderString = prefs.get("orden");
    final restaurantString = prefs.get("restaurant_client");

    _restaurantClient = RestaurantClient();
    if (sessionString != null) {
      _session = Session.fromJson(json.decode(sessionString));
    }
    if (restaurantString != null) {
      _restaurantClient =
          RestaurantClient.fromJson(json.decode(restaurantString));
    }
    if (orderString != null) {
      _order = Order.fromJson(json.decode(orderString));
    }
    if (restaurantString != null) {
      _restaurantClient =
          RestaurantClient.fromJson(json.decode(restaurantString));
    }
    _language = prefs.get("language");
    _email = prefs.get("email");
    _password = prefs.get("password");
    _session = session;
    return this;
  }

  String get language {
    if (_language == null) {
      return "es";
    } else {
      return _language;
    }
  }

  set language(String language) {
    _language = language;
    _prefs.setString("language", _language);
  }

  String get lastEmail {
    if (_email == null) {
      return "";
    } else {
      return _email;
    }
  }

  set lastEmail(String value) {
    _email = value;
    _prefs.setString("email", value);
  }

  String get password {
    return _password;
  }

  set password(String value) {
    _password = value;
    _prefs.setString("password", password);
  }

  Session get session {
    return _session;
  }

  set session(Session value) {
    _session = value;
    _prefs.setString("session", value.toString());
  }

  Order get order => _order;

  set order(Order value) {
    _order = value;
    print("Se agrega a la orden");
    if (value == null) {
      _prefs.setString("orden", null);
    } else {
      try {
        final values = value.toJson();
        final map = json.encode(values);
        _prefs?.setString("orden", map);
      } catch (error) {
        print(error);
      }
    }
  }

  RestaurantClient get restaurantClient => _restaurantClient;

  set restaurantClient(RestaurantClient value) {
    _restaurantClient = value;
    if (value == null) {
      _prefs.setString("restaurant_client", null);
    } else {
      _prefs.setString("restaurant_client", json.encode(value.toJson()));
    }
  }

  @override
  String toString() {
    return 'Preferences{_prefs: $_prefs, _language: $_language, _email: $_email, _password: $_password, _session: $_session}';
  }
}
