


class RestaurantTable {
  int id;
  int number;
  bool available;
  List<Customer> customers;
  int clientId;
  String createdAt;
  String updatedAt;
  String type;

  RestaurantTable({
    this.id,
    this.number,
    this.available,
    this.customers,
    this.clientId,
    this.createdAt,
    this.updatedAt,
    this.type
  });

  factory RestaurantTable.fromJson(Map<String, dynamic> json) => new RestaurantTable(
    id: json["id"],
    number: json["number"],
    available: json["available"],
    //customers: new List<Customer>.from(json["customers"].map((x) => Customer.fromJson(x))),
    clientId: json["clientid"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
    type: json["type"]
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "number": number,
    "available": available,
    "customers": customers == null?null:customers.map((x) => x.toJson()).toList(),
    "client_id": clientId,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is RestaurantTable &&
              runtimeType == other.runtimeType &&
              number == other.number &&
              type == other.type;

  @override
  int get hashCode =>
      number.hashCode ^
      type.hashCode;





}

class Customer {
  Customer();

  factory Customer.fromJson(Map<String, dynamic> json) => new Customer(
  );

  Map<String, dynamic> toJson() => {

  };
}