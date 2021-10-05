import 'package:flutter/cupertino.dart';
import 'dish.dart';
import 'table.dart';

class Order {
  int id;
  List<OrderItem> items;
  bool canceled;
  RestaurantTable table;
  int clientId;
  String createdAt;
  String updatedAt;

  Order({
    this.id,
    this.items,
    this.canceled,
    this.table,
    this.clientId,
    this.createdAt,
    this.updatedAt,
  }) {
    if (items == null) {
      items = List<OrderItem>();
    }
  }

  factory Order.fromJson(Map<String, dynamic> json) => new Order(
        id: json["id"],
        items: json["items"] == null
            ? []
            : new List<OrderItem>.from(
                json["items"].map((x) => OrderItem.fromJson(x))),
        canceled: json["canceled"],
        table: json["table"] != null
            ? RestaurantTable.fromJson(json["table"])
            : null,
        clientId: json["client_id"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  bool get isSendOrderAvailable {
    return getNewsDishes().isNotEmpty;
  }

  Map<String, dynamic> toJson({bool sendItems = true}) => {
        "id": id,
        "items": items == null
            ? null
            : (sendItems)
                ? items.map((OrderItem x) {
                    if (x != null) {
                      return x.toJson();
                    }
                    return null;
                  }).toList()
                : null,
        "canceled": canceled,
        "table": table == null ? null : table.toJson(),
        "client_id": clientId,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
  double get total {
    double t = 0;
    for (OrderItem item in items) {
      t += item.dish.total(item.mount);
    }
    return t;
  }

  void lockedOrder() {
    for (OrderItem item in items) {
      item.locked = true;
    }
  }

  List getNewsDishes() {
    List list = [];
    items.forEach((item) {
      if (!item.locked) {
        item.orderId = id;
        list.add(item);
      }
    });
    return list;
  }
}

class OrderItem {
  int id;
  int orderId;
  Dish dish;
  int mount;
  bool takeaway;
  String createdAt;
  String updatedAt;
  bool locked;

  OrderItem(
      {this.id,
      this.orderId,
      this.dish,
      this.mount,
      this.takeaway,
      this.createdAt,
      this.updatedAt,
      this.locked}) {
    locked = locked ?? false;
  }

  factory OrderItem.fromJson(Map<String, dynamic> json) => new OrderItem(
      id: json["id"],
      orderId: json["order_id"],
      dish: Dish.fromJson(json["dish"]),
      mount: json["mount"],
      takeaway: json["takeaway"],
      createdAt: json["created_at"],
      updatedAt: json["updated_at"],
      locked: json["locked"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "order_id": orderId,
        "dish": dish != null ? dish.toJson() : null,
        "mount": mount,
        "ingredients": dish != null
            ? dish.ingredients.map((ingredient) {
                return ingredient.toMap();
              }).toList()
            : null,
        "takeaway": takeaway,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "locked": locked
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderItem &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          orderId == other.orderId &&
          dish == other.dish &&
          mount == other.mount &&
          takeaway == other.takeaway &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt &&
          locked == other.locked;

  @override
  int get hashCode =>
      id.hashCode ^
      orderId.hashCode ^
      dish.hashCode ^
      mount.hashCode ^
      takeaway.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      locked.hashCode;
}
