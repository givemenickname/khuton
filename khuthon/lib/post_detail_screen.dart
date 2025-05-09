import 'package:flutter/material.dart';

class PostDetailScreen extends StatefulWidget {
  final String title;
  final String content;
  final int maxPeople;

  const PostDetailScreen({
    super.key,
    required this.title,
    required this.content,
    required this.maxPeople,
  });

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  bool isJoined = false;
  final TextEditingController _commentController = TextEditingController();
  final List<String> _comments = [];
  int joinedPeople = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.green[200],
        leading: BackButton(),
        title: Text('식물사랑'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
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
                Text(widget.content, style: TextStyle(fontSize: 15)),
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
                      child: Text(
                        "인원 $joinedPeople/${widget.maxPeople}명",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
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
                        joinedPeople += isJoined ? 1 : -1;
                      });
                    },
                    child: Text(isJoined ? '신청 취소' : '참가 신청'),
                  ),
                ),
                Divider(),
                Text('댓글', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                for (var comment in _comments)
                  Container(
                    margin: EdgeInsets.only(bottom: 8),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(comment),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
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
                    if (_commentController.text.trim().isNotEmpty) {
                      setState(() {
                        _comments.add(_commentController.text.trim());
                        _commentController.clear();
                      });
                    }
                  },
                  child: Text('등록'),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
