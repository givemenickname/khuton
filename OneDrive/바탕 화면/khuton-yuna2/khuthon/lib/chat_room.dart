import 'package:flutter/material.dart';
import 'package:khuthon/calendar_page.dart';
import 'package:khuthon/todo_list_page.dart';

class ChatRoomPage extends StatefulWidget {
  const ChatRoomPage({super.key});

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  final scrollController = ScrollController();
  final textEditingController = TextEditingController();
  final focusNode = FocusNode();

  List<String> chatList = [];

  void addMessage() {
    final text = textEditingController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      chatList.add(text);
    });
    textEditingController.clear();

    // 스크롤 아래로
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    textEditingController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('채팅방'),
        backgroundColor: const Color(0xFFAED581),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('메뉴'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _popupButton(context, '할일 리스트', const ToDoListPage()),
                        const SizedBox(height: 12),
                        _popupButton(context, '공유 캘린더', const CalendarPage()),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('닫기'),
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
            child: GestureDetector(
              onTap: () => focusNode.unfocus(),
              child: ListView.separated(
                controller: scrollController,
                reverse: true,
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                itemCount: chatList.length,
                itemBuilder: (context, index) {
                  final message = chatList[chatList.length - 1 - index];
                  return Bubble(chat: message);
                },
                separatorBuilder: (_, __) => const SizedBox(height: 12),
              ),
            ),
          ),
          _BottomInputField(
            controller: textEditingController,
            focusNode: focusNode,
            onSubmitted: addMessage,
          ),
        ],
      ),
    );
  }

  Widget _popupButton(BuildContext context, String label, Widget page) {
    return InkWell(
      onTap: () {
        Navigator.pop(context); // 닫기
        Navigator.push(context, MaterialPageRoute(builder: (_) => page));
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.green[50],
          border: Border.all(color: Colors.green),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}

class _BottomInputField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onSubmitted;

  const _BottomInputField({
    required this.controller,
    required this.focusNode,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            const Icon(Icons.add),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                decoration: const InputDecoration(
                  hintText: '메시지를 입력하세요',
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (_) => onSubmitted(),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: onSubmitted,
            ),
          ],
        ),
      ),
    );
  }
}

class Bubble extends StatelessWidget {
  final String chat;
  final bool isMe;

  const Bubble({required this.chat, this.isMe = true});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(vertical: 4),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
        decoration: BoxDecoration(
          color: isMe ? Colors.green[100] : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          chat,
          style: const TextStyle(color: Colors.black87),
        ),
      ),
    );
  }
}
