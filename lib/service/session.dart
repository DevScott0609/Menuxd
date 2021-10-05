import 'dart:convert';

import 'package:menuxd/models/user.dart';

class Session {
  Session({this.accessToken, this.user});

  String accessToken = "";
  User user;

  void setLoginData(String token, User user) {
    this.accessToken = token;
    this.user = user;
  }

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
        accessToken: json["access_token"], user: User.fromJson(json["user"]));
  }

  Map<String, dynamic> toMap() {
    return {"access_token": accessToken, "user": user.toMap()};
  }

  @override
  String toString() {

   return json.encode(toMap());
  }

}
