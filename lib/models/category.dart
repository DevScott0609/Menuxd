import 'dish.dart';

class Category {
  int id;
  String title;
  String picture;
  bool active;
  int position;
  int suggested1;
  int suggested2;
  int suggested3;
  bool priority;
  int clientId;
  DateTime createdAt;
  DateTime updatedAt;

  List<Dish> dishesList;


  Category({
    this.id,
    this.title,
    this.picture,
    this.active,
    this.position,
    this.suggested1,
    this.suggested2,
    this.suggested3,
    this.priority,
    this.clientId,
    this.createdAt,
    this.updatedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["id"],
    title: json["title"],
    picture: json["picture"],
    active: json["active"],
    position: json["position"],
    suggested1: json["suggested1"],
    suggested2: json["suggested2"],
    suggested3: json["suggested3"],
    priority: json["priority"],
    clientId: json["client_id"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "Title": title,
    "picture": picture,
    "active": active,
    "position": position,
    "suggested1": suggested1,
    "suggested2": suggested2,
    "suggested3": suggested3,
    "priority": priority,
    "client_id": clientId,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}