class MemoDto {
  String content;

  MemoDto({
    required this.content,
  });

  Map<String, dynamic> toMap() {
    return {
      "content" : content,
    };
  }
}
