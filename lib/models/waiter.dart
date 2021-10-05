
class Waiter {
  int id;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;
  String name;
  String pin;
  int clientId;

  Waiter({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.name,
    this.pin,
    this.clientId,
  });

  factory Waiter.fromJson(Map<String, dynamic> json) => new Waiter(
    id: json["id"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
    name: json["name"],
    pin: json["pin"],
    clientId: json["client_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "deleted_at": deletedAt,
    "name": name,
    "pin": pin,
    "client_id": clientId,
  };

  @override
  String toString() {
    return toJson().toString();
  }

}
