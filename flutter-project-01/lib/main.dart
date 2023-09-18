import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:intl/intl.dart';
import 'package:project/my_event.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<StatefulWidget> createState() => _MainPage();
  }

  class _MainPage extends State<MainPage> {
    EventList<Event> markedDateMap = EventList(events: {});
    List<MyEvent> myEvent = List.empty(growable: true);
    
  @override
  Widget build(BuildContext context) {
    markedDateMap = EventList(events: {});

    for (int i =0; i < myEvent.length; i++) {
      MyEvent event = myEvent[i];
      List DateDelim = event.date.split('-');
      DateTime eventDate = DateTime(
        int.parse(DateDelim[0]),
        int.parse(DateDelim[1]),
        int.parse(DateDelim[2]),
      );
      markedDateMap.add(
        eventDate, 
        Event(date: eventDate,
            icon: Container(decoration: const BoxDecoration(color: Colors.red),)
        )
        );
    }


    return Scaffold(
      appBar: AppBar(title: const Text("달력 일정표")),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: CalendarCarousel<Event>(
          thisMonthDayBorderColor: Colors.white,
          weekendTextStyle: const TextStyle(color: Colors.red),
          daysHaveCircularBorder: true,
          markedDatesMap: markedDateMap,
          onDayPressed: (DateTime datetime, List<Event> events) {
            _showAppointments(context, datetime);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
      child: const Icon(Icons.add, color: Colors.pink,),
      onPressed: () async {
        await showDialog(
          context: context, 
          builder: (BuildContext context) {
            TextEditingController dateController = TextEditingController();
            TextEditingController contentController = TextEditingController();
            return AlertDialog(
              title: const Text("날짜입력(yyyy-MM-dd)"),
              content: SizedBox(
                height: 150,
                child: Column(
                children: [
                  TextField(controller: dateController,
                  style: const TextStyle(fontSize: 20),),
                  TextField(controller: contentController,
                  style: const TextStyle(fontSize: 20),),
                ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    String eventDate = dateController.value.text;
                    String eventContent = contentController.value.text;
                    setState(() {
                      myEvent.add(MyEvent(eventDate, eventContent), );
                    });
                    Navigator.of(context).pop();
                  }, 
                  child: const Text("등록")
                  ),
                  TextButton(onPressed: () {
                    Navigator.of(context).pop();
                  }, child: const Text("취소")
                  ),
              ],
            );
          }
          
          );
      },
      ),
    );
  }
  
  void _showAppointments(BuildContext context, DateTime datetime) async{
  
    showModalBottomSheet(
      context: context, 
      builder: (BuildContext context) {
       return Scaffold(
        body: Container(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Text(DateFormat('yyyy-MM-dd').format(datetime),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20),
                ),
                const Divider(),
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      MyEvent event = myEvent[index];
                      String date = '${datetime.year}-${datetime.month.toString().padLeft(2,'0')}-${datetime.day.toString().padLeft(2,'0')}';
                      if(event.date != date) {
                        return Container(height: 0);
                      }
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        color: Colors.grey,
                        child: ListTile(
                          title: Text(
                            event.content,
                            style: const TextStyle(color: Colors.black),),
                        ),
                      );
                    }
                  )
              ,)
              ],
            ),
            ),
        ),
       ); 
      }
     );
   }
  }

  