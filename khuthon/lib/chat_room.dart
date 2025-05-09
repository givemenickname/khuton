import 'package:flutter/material.dart';

class ChatRoomPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('채팅방'),
        actions: [IconButton(icon: Icon(Icons.more_vert), onPressed: () {})],
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
