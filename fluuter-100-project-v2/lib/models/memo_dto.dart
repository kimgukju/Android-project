class MemoDto {
  int? id;
  String content;

  MemoDto({
    this.id,
    required this.content,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "content": content,
    };
  }
}
