import 'package:flutter/material.dart';
import 'chat_room.dart';

class PostListPage extends StatelessWidget {
  final List<Map<String, dynamic>> posts = [
    {'title': '○○텃밭에서 같이 배추 재배할 사람들 구해요!', 'members': '12/20'},
    {'title': '□□빌딩 옥상에서 방울토마토 재배해요', 'members': '2/5'},
    {'title': '같이 잘 키워봅시다', 'members': '9/25'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('참가 가능한 채팅 목록')),
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(posts[index]['title']),
            subtitle: Text('인원 ${posts[index]['members']}'),
            trailing: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ChatRoomPage()),
                );
              },
              child: Text('채팅하기'),
            ),
          );
        },
      ),
    );
  }
}
