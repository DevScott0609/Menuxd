class Ad {
  int id;
  bool active;
  String picture;
  String url;
  List<Click> click;
  int clientId;
  String createdAt;
  String updatedAt;

  Ad({
    this.id,
    this.active,
    this.picture,
    this.url,
    this.click,
    this.clientId,
    this.createdAt,
    this.updatedAt,
  });

  factory Ad.fromJson(Map<String, dynamic> json) => Ad(
        id: json["id"],
        active: json["active"],
        picture: json["picture"],
        url: json["url"],
        click: json["click"]?.map((x) => Click.fromJson(x)),
        clientId: json["client_id"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "active": active,
        "picture": picture,
        "url": url,
        "click": List<dynamic>.from(click.map((x) => x.toJson())),
        "client_id": clientId,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}

class Click {
  int id;
  int adId;
  String date;
  String createdAt;
  String updatedAt;

  Click({
    this.id,
    this.adId,
    this.date,
    this.createdAt,
    this.updatedAt,
  });

  factory Click.fromJson(Map<String, dynamic> json) => Click(
        id: json["id"],
        adId: json["ad_id"],
        date: json["date"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "ad_id": adId,
        "date": date,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
