import 'package:flutter/material.dart';

class ToDoListPage extends StatefulWidget {
  const ToDoListPage({super.key});

  @override
  State<ToDoListPage> createState() => _ToDoListPageState();
}

class _ToDoListPageState extends State<ToDoListPage> {
  final List<String> myTasks = ['딸기 물주기', '잡초 제거', '잎 제거'];
  final List<String> otherTasks = ['딸기 물주기', '잡초 제거', '잎 제거'];

  late List<bool> myCheckStates;
  late List<bool> otherCheckStates;

  @override
  void initState() {
    super.initState();
    myCheckStates = List.generate(myTasks.length, (_) => false);
    otherCheckStates = List.generate(otherTasks.length, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('할일 리스트')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _taskSection('나의 할 일', myTasks, myCheckStates, (i, val) {
              setState(() => myCheckStates[i] = val);
            }),
            _taskSectionWithAvatar('○○님의 할 일', otherTasks, otherCheckStates, (i, val) {
              setState(() => otherCheckStates[i] = val);
            }),
          ],
        ),
      ),
    );
  }

  Widget _taskSection(String title, List<String> tasks, List<bool> states, void Function(int, bool) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          color: Color(0xFFD7EEC6),
          padding: EdgeInsets.all(12),
          child: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        ...List.generate(tasks.length, (index) {
          final checked = states[index];
          return ListTile(
            leading: IconButton(
              icon: Icon(
                Icons.check_box,
                color: checked ? Colors.black : Colors.white,
              ),
              onPressed: () => onChanged(index, !checked),
            ),
            title: Text(
              tasks[index],
              style: TextStyle(
                color: checked ? Colors.black : Colors.black87,
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _taskSectionWithAvatar(String title, List<String> tasks, List<bool> states, void Function(int, bool) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          color: Color(0xFFD7EEC6),
          padding: EdgeInsets.all(12),
          child: Row(
            children: [
              CircleAvatar(backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=3')),
              SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ],
          ),
        ),
        ...List.generate(tasks.length, (index) {
          final checked = states[index];
          return ListTile(
            leading: IconButton(
              icon: Icon(
                Icons.check_box,
                color: checked ? Colors.black : Colors.white,
              ),
              onPressed: () => onChanged(index, !checked),
            ),
            title: Text(
              tasks[index],
              style: TextStyle(
                color: checked ? Colors.black : Colors.black87,
              ),
            ),
          );
        }),
      ],
    );
  }
}
