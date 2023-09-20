import 'package:flutter/material.dart';
import 'package:project/memo.dart';

class MemoList extends StatefulWidget {
  const MemoList({super.key});

  @override
  State<MemoList> createState() => _MemoListState();
}

class _MemoListState extends State<MemoList> {
  List<String> memoList = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
    // memoList.add("발표하기");
    // memoList.add("플러터 공부하기");
    // memoList.add("청소하기");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("메모 리스트"),
        ),
        body: ListView.builder(
          itemBuilder: (context, index) {
            return Card(
              child: InkWell(
                child: Text(
                  memoList[index],
                  style: const TextStyle(fontSize: 30),
                ),
                onTap: () {
                  // Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MyApp(),));
                },
              ),
            );
          },
          itemCount: memoList.length,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _addNavigation(context);
          },
          child: const Icon(Icons.add),
        ));
  }

  void _addNavigation(BuildContext context) async {
    final result = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const Memo()));
    setState(() {
      memoList.add(result as String);
    });
  }
}
