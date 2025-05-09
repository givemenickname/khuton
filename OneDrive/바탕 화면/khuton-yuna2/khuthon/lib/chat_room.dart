import 'package:flutter/material.dart';
import 'package:khuthon/calendar_page.dart';
import 'package:khuthon/todo_list_page.dart';

class ChatRoomPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('채팅방'),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('메뉴'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _popupButton(context, '할일 리스트', ToDoListPage()),
                        SizedBox(height: 12),
                        _popupButton(context, '공유 캘린더', CalendarPage()), // 추후 구현
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('닫기'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(10),
              children: [
                _messageBubble('안녕하세요!', isMe: false),
                _messageBubble('네 반가워요~', isMe: true),
              ],
            ),
          ),
          _chatInputField(),
        ],
      ),
    );
  }

  Widget _popupButton(BuildContext context, String label, Widget page) {
    return InkWell(
      onTap: () {
        Navigator.pop(context); // 팝업 먼저 닫기
        Navigator.push(context, MaterialPageRoute(builder: (_) => page));
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.green[50],
          border: Border.all(color: Colors.green),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget _popupBox(String label) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.green[50],
        border: Border.all(color: Colors.green),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _messageBubble(String text, {bool isMe = false}) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isMe ? Colors.green[100] : Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(text),
      ),
    );
  }

  Widget _chatInputField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      color: Colors.green[100],
      child: Row(
        children: [
          Icon(Icons.add),
          SizedBox(width: 8),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: '메시지 입력...',
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}