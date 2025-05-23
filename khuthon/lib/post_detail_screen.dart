import 'package:flutter/material.dart';

class PostDetailScreen extends StatefulWidget {
  final String title;

  const PostDetailScreen({required this.title});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  bool isJoined = false;
  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.green[200],
        leading: BackButton(),
        title: Text('식물사랑'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage('assets/profile.png'),
                  radius: 24,
                ),
                SizedBox(width: 10),
                Text('식물사랑', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 16),
            Text(
              widget.title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text(
              '도시농부 두 달 차입니다! 많은 사람들과 정보도 공유하면서 소중한 생명들을 키워보고 싶네요^^ 배추를 키워볼 생각입니다. 많은 참여 부탁드려요!',
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Text("인원 12/20명",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Text("05/08 15:34", style: TextStyle(color: Colors.grey)),
              ],
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    isJoined = !isJoined;
                  });
                },
                child: Text(isJoined ? '신청 취소' : '참가 신청'),
              ),
            ),
            Divider(),
            Text('댓글', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: '댓글을 입력하세요.',
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.all(12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    print("댓글 등록됨: \${_commentController.text}");
                    _commentController.clear();
                  },
                  child: Text('등록'),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
