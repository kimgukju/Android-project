import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime selectedDay = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  DateTime focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("달력")),
      body: TableCalendar(
        locale: "ko_KR",
        daysOfWeekHeight: 30,
        firstDay: DateTime.utc(2000, 1, 1),
        lastDay: DateTime.utc(2100, 12, 31),
        focusedDay: focusedDay,
        onDaySelected: (DateTime selectedDay, DateTime focusedDay) {
          // 선택된 날짜의 상태를 갱신합니다.
          setState(() {
            this.selectedDay = selectedDay;
            this.focusedDay = focusedDay;
          });
        },
        selectedDayPredicate: (DateTime day) {
          // selectedDay 와 동일한 날짜의 모양을 바꿔줍니다.
          return isSameDay(selectedDay, day);
        },

        // 헤더 커스텀하기
        headerStyle: HeaderStyle(
          titleCentered: true,
          titleTextFormatter: (date, locale) =>
              DateFormat.yMMMMd(locale).format(date),
          formatButtonVisible: false,
          // 타이틀 언어 커스텀
          titleTextStyle: const TextStyle(
            fontSize: 20.0,
            color: Colors.blue,
          ),
          // 왼쪽,오른쪽 넘어가는 버튼 커스텀
          headerPadding: const EdgeInsets.symmetric(vertical: 4.0),
          leftChevronIcon: const Icon(
            Icons.arrow_left,
            size: 40.0,
          ),
          rightChevronIcon: const Icon(
            Icons.arrow_right,
            size: 40.0,
          ),
        ),

        // 캘린더 스타일 커스텀하기
        calendarStyle: const CalendarStyle(
          // 금일 표시하는 버튼 커스텀(색바꾸기)
          todayDecoration: BoxDecoration(
            color: Colors.amber,
            shape: BoxShape.circle,
          ),

          // 셀렉트 하는 버튼 커스텀
          selectedDecoration: BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle,
          ),

          // 다른 달의 날짜 표시 off 하기
          outsideDaysVisible: false,
        ),
      ),
    );
  }
}
