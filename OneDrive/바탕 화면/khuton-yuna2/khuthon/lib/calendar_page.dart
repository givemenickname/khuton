// calendar_page.dart

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'database_helper.dart'; // ✅ DB 클래스 가져오기

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final TextEditingController _memoController = TextEditingController();

  List<Map<String, dynamic>> _dayMemos = [];

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _loadMemosForDay(_selectedDay!);
  }

  Future<void> _loadMemosForDay(DateTime date) async {
    final formattedDate = date.toIso8601String().split("T")[0];
    final data = await DatabaseHelper.instance.readMemosByDate(formattedDate);
    setState(() {
      _dayMemos = data;
    });
  }

  Future<void> _saveMemo() async {
    final memo = _memoController.text.trim();
    if (memo.isEmpty || _selectedDay == null) return;

    final date = _selectedDay!.toIso8601String().split("T")[0];
    await DatabaseHelper.instance.createTodo(date, memo);

    _memoController.clear();
    _loadMemosForDay(_selectedDay!);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('[$date] 메모가 저장되었습니다')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('공유 캘린더')),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selected, focused) {
              setState(() {
                _selectedDay = selected;
                _focusedDay = focused;
              });
              _loadMemosForDay(selected);
            },
          ),
          const SizedBox(height: 10),
          if (_selectedDay != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '선택된 날짜: ${_selectedDay!.toIso8601String().split("T")[0]}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _memoController,
                    decoration: InputDecoration(
                      labelText: '메모를 입력하세요',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.green[50],
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: _saveMemo,
                    child: const Text('메모 저장'),
                  ),
                  const SizedBox(height: 8),
                  if (_dayMemos.isNotEmpty)
                    const Text("📌 저장된 메모들:", style: TextStyle(fontWeight: FontWeight.bold)),
                  ..._dayMemos.map((item) => ListTile(
                    title: Text(item['content']),
                  )),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
