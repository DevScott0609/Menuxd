class RestaurantClient {
  int id;
  String name;
  int userId;
  bool active;
  String picture;
  String expireAt;
  String createdAt;
  String updatedAt;

  RestaurantClient({
    this.id,
    this.name,
    this.userId,
    this.active,
    this.picture,
    this.expireAt,
    this.createdAt,
    this.updatedAt,
  });

  factory RestaurantClient.fromJson(Map<String, dynamic> json) =>
      new RestaurantClient(
        id: json["id"],
        name: json["name"],
        userId: json["user_id"],
        active: json["active"],
        picture: json["picture"],
        expireAt: json["expire_at"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "user_id": userId,
        "active": active,
        "picture": picture,
        "expire_at": expireAt,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
