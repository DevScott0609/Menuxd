class Rate {
  int id;
  int score;
  int questionId;
  DateTime createdAt;
  DateTime updatedAt;

  Rate({
    this.id,
    this.score,
    this.questionId,
    this.createdAt,
    this.updatedAt,
  });

  factory Rate.fromJson(Map<String, dynamic> json) => Rate(
        id: json["id"],
        score: json["score"],
        questionId: json["question_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "score": score,
        "question_id": questionId,
        "created_at": null,
        "updated_at": null,
      };
}
