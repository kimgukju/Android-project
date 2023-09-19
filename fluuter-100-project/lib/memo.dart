import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'models/memo_dto.dart';

class Memo extends StatefulWidget {
  const Memo({super.key});

  @override
  State<Memo> createState() => _MemoState();
}

class _MemoState extends State<Memo> {
  TextEditingController inputController = TextEditingController();
  String selectedDay = "";
  var value = "";
  var memoContent = "";
  var memoList = [];
  MemoDto getMemo(String content) => MemoDto(
        content: content,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("메모")),
      body: ListView(
        children: [
          Column(
            children: [
              const Text(
                "내용",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // 패딩을 줘서 넓이 조절
              Padding(
                padding: const EdgeInsets.all(20),
                child: GestureDetector(
                  onTap: () => FocusScope.of(context).unfocus(),
                  child: TextField(
                    controller: inputController,
                    decoration: const InputDecoration(
                      // labelText: '메모',
                      // labelStyle: TextStyle(color: Colors.orange),
                      hintText: "내용을 입력하세요",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(width: 3), // ????? 왜 안먹음?
                      ),
                      // 포커싱 됬을때 효과 주기
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: Colors.orange, width: 3),
                      ),
                    ),
                    onChanged: (text) {
                      value = text;
                    },
                    maxLines: 5,
                  ),
                ),
              )
            ],
          ),
          Column(
            children: [
              const Text(
                "달력",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.calendar_month_outlined),
                onPressed: () => selectDay(context),
                iconSize: 150,
                color: Colors.amber,
              ),
              Text(
                "선택한날짜 : $selectedDay",
                style: const TextStyle(fontSize: 17),
              ),
            ],
          ),
          SafeArea(
            child: Container(
              alignment: Alignment.bottomRight,
              margin: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 100,
              ),
              child: SizedBox(
                width: 100,
                height: 50,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop("내용: ${inputController.value.text}\n날짜: $selectedDay");
                      
                    },
                    child: const Text("Save")),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<DateTime?> selectDay(BuildContext context) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.utc(2000, 1, 1),
      lastDate: DateTime.utc(2100, 12, 31),
    );
    if (selected != null) {
      setState(() {
        selectedDay = DateFormat('yy/MM/dd').format(selected);
      });
    }
    // 손안댔을때는 지금 날짜 표현하게 해보기 ㅇ.ㅇ
    // else if (selected == null) {
    //   setState(() {
    //     selectedDay = DateFormat('yy/MM/dd').format(DateTime.now());
    //   });
    // }
    return null;
  }
}
