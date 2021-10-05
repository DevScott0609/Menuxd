import 'dart:convert';

class User {
  final String id;
  final String email;
  final String role;
  final String imageUrl;
  final bool confirmed;
  final String createdAt;
  final String updatedAt;

  User(
      {this.id,
      this.email,
      this.role,
      this.imageUrl,
      this.confirmed,
      this.createdAt,
      this.updatedAt});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json["id"].toString(),
        email: json["email"],
        role: json["role"],
        imageUrl: json["image_url"],
        confirmed: json["confirmed"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"]);
  }
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "email": email,
      "role": role,
      "image_url": imageUrl,
      "confirmed": confirmed,
      "created_at": createdAt,
      "updated_at": createdAt
    };
  }

  @override
  String toString() {
    return json.encode(toMap());
  }

}
