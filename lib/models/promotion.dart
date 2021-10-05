import 'dish.dart';

class Promotion {
  int id;
  String title;
  String description;
  int dishId;
  String picture;
  Dish dish;
  int clientId;
  String startAt;
  String endAt;
  List<String> days;
  String createdAt;
  String updatedAt;

  Promotion(
      {this.id,
      this.title,
      this.description,
      this.dishId,
      this.dish,
      this.clientId,
      this.startAt,
      this.endAt,
      this.days,
      this.createdAt,
      this.updatedAt,
      this.picture});

  factory Promotion.fromJson(Map<String, dynamic> json) => new Promotion(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        dishId: json["dish_id"],
        dish: Dish.fromJson(json["dish"]),
        picture: json["picture"],
        clientId: json["client_id"],
        startAt: json["start_at"],
        endAt: json["end_at"],
        days: new List<String>.from(json["days"].map((x) => x)),
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "dish_id": dishId,
        "client_id": clientId,
        "start_at": startAt,
        "end_at": endAt,
        "days": new List<dynamic>.from(days.map((x) => x)),
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
