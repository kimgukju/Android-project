import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import 'models/calendar_dto.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  // Datetime
  DateTime selectedDay = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  DateTime focusedDay = DateTime.now();
  // 이벤트 만들기
  Map<DateTime, List<CalendarDto>> events = {};
  late final ValueNotifier<List<CalendarDto>> selectedEvent;
  // 컨트롤러 만들기
  final _eventController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedDay = focusedDay;
    selectedEvent = ValueNotifier(_getEventsDay(selectedDay));
  }

  List<CalendarDto> _getEventsDay(DateTime day) {
    return events[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("달력")),
      body: Column(
        children: [
          TableCalendar<CalendarDto>(
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
                selectedEvent.value = _getEventsDay(selectedDay);
              });
            },
            eventLoader: _getEventsDay,
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

            // eventLoader 해당하는 이벤트가 있으면 마커로 표시구현

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
          const SizedBox(height: 8.0),
          Expanded(
            child: ValueListenableBuilder<List<CalendarDto>>(
              valueListenable: selectedEvent,
              builder: (context, value, _) {
                return ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        onTap: () => debugPrint(""),
                        title: Text('${value[index]}'),
                      ),
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                scrollable: true,
                title: const Text("메모 내용(이벤트)"),
                content: Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextField(
                    controller: _eventController,
                  ),
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      events.addAll({
                        selectedDay: [CalendarDto(_eventController.text)]
                      });
                      Navigator.of(context).pop();
                      selectedEvent.value = _getEventsDay(selectedDay);
                    },
                    child: const Text("확인"),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text("취소"),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
