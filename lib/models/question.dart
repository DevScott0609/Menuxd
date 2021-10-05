class Question {
  int id;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;
  String text;
  int clientId;

  Question({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.text,
    this.clientId,
  });

  factory Question.fromJson(Map<String, dynamic> json) => Question(
        id: json["id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        text: json["text"],
        clientId: json["client_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "deleted_at": deletedAt,
        "text": text,
        "client_id": clientId,
      };
}
