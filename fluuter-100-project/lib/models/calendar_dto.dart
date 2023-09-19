class CalendarDto {
  final String title;

  CalendarDto(
    this.title,
  );

  // instatnce of '클래스명' 뜨는데 toString을 해줘서 내가 입력한 문구 그대로 입력하게하기
  @override
  String toString() => title;
}
