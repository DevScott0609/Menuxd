import 'package:menuxd/utils/utils.dart';
import 'package:sqflite/sqflite.dart';
import 'category.dart';

class Dish {
  int id;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;
  String name;
  String description;
  bool available;
  List<String> pictures;
  List<IngredientElement> ingredients;
  int price;
  bool suggested;
  int categoryId;
  Category category;
  int clientId;

  Dish(
      {this.id,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.name,
      this.description,
      this.available,
      this.pictures,
      this.price,
      this.suggested,
      this.categoryId,
      this.category,
      this.clientId,
      this.ingredients});
  static void createTable(Database db) {
    db.rawUpdate(
        "CREATE TABLE photo(_id integer primary key autoincrement, photo text)");
  }

  factory Dish.fromJson(Map<String, dynamic> json) {
    final list = json["pictures"] as List;
    List<String> pictureList = [];
    if (list != null) {
      for (String url in list) {
        if (url.trim().isNotEmpty) {
          pictureList.add(url);
        }
      }
    }

    List ingredients = json["ingredients"];
    List<IngredientElement> ingredientsList = [];
    if (ingredients != null) {
      if (ingredients != null) {
        ingredientsList = ingredients.map(
          (element) {
            return IngredientElement.fromJson(element);
          },
        ).toList();
      }
    }

    return Dish(
        id: json["id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        name: json["name"],
        description: json["description"],
        available: json["available"],
        pictures: pictureList,
        price: json["price"],
        suggested: json["suggested"],
        categoryId: json["category_id"],
        category: json["cateogory"] != null
            ? Category.fromJson(json["category"])
            : null,
        clientId: json["client_id"],
        ingredients: ingredientsList);
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "deleted_at": deletedAt,
        "name": name,
        "description": description,
        "available": available,
        "pictures": pictures == null
            ? null
            : pictures.map((String x) {
                if (x.isNotEmpty) {
                  return x;
                } else {
                  return null;
                }
              }).toList(),
        "price": price,
        "suggested": suggested,
        "category_id": categoryId,
        "ingredients": ingredients != null
            ? ingredients.map((ingredient) {
                return ingredient.toMap();
              }).toList()
            : null,
        "client_id": clientId,
      };

  double total(int count) {
    double t = price?.toDouble() ?? 0.0;
    ingredients.forEach((ingredient) {
      t += ingredient.active ? ingredient.price : 0.0;
    });
    return (t * count).toDouble();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Dish && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return toJson().toString();
  }

  Dish copy() {
    return Dish(
      available: available,
      category: category,
      categoryId: categoryId,
      deletedAt: deletedAt,
      clientId: clientId,
      createdAt: createdAt,
      description: description,
      id: id,
      ingredients: ingredients.map((element) {
        return element.copy();
      }).toList(),
      name: name,
      pictures: pictures,
      price: price,
      suggested: suggested,
      updatedAt: updatedAt,
    );
  }
}

class IngredientElement {
  String name;
  int id;
  String createAt;
  String updatedAt;
  String deleteAt;
  int dishId;
  int price;
  bool active;

  IngredientElement(
      {this.name,
      this.id,
      this.createAt,
      this.updatedAt,
      this.deleteAt,
      this.dishId,
      this.price,
      this.active = true});
  factory IngredientElement.fromJson(Map<String, dynamic> map) {
    return IngredientElement(
        name: camelCase(map["name"]),
        id: map["id"],
        createAt: map["create_at"],
        active: map["active"],
        price: map["price"],
        deleteAt: map["delete_at"],
        dishId: map["dish_id"],
        updatedAt: map["update_at"]);
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "created_at": createAt,
      "updated_at": updatedAt,
      "deleted_at": deleteAt,
      "dish_id": dishId,
      "name": name,
      "active": active,
      "price": price
    };
  }

  IngredientElement copy() {
    return IngredientElement(
        active: active,
        updatedAt: updatedAt,
        price: price,
        name: name,
        id: id,
        createAt: createAt,
        deleteAt: deleteAt,
        dishId: dishId);
  }
}
