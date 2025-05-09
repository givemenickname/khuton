import 'package:flutter/material.dart';
import 'participant_list_screen.dart';

class MyPostDetailScreen extends StatefulWidget {
  final String title;

  const MyPostDetailScreen({required this.title});

  @override
  State<MyPostDetailScreen> createState() => _MyPostDetailScreenState();
}

class _MyPostDetailScreenState extends State<MyPostDetailScreen> {
  bool isRecruiting = true; // 기본 true로 설정
  final TextEditingController _commentController = TextEditingController();

  void _showReportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('신고'),
        content: Text('해당 게시글을 신고하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('취소'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('신고가 접수되었습니다.')),
              );
            },
            child: Text('신고'),
          ),
        ],
      ),
    );
  }

  void _toggleRecruitStatus() {
    setState(() {
      isRecruiting = !isRecruiting;
    });

    // 변경된 상태를 이전 화면으로 전달
    Navigator.pop(context, isRecruiting);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.green[200],
        leading: BackButton(),
        title: Text('식물사랑'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'report') _showReportDialog(context);
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: 'report', child: Text('신고')),
            ],
          )
        ],
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
                  child: Text("인원 12/20명", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Text("05/08 15:34", style: TextStyle(color: Colors.grey)),
              ],
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                  onPressed: _toggleRecruitStatus,
                  child: Text(isRecruiting ? '모집 마감' : '모집 중'),
                ),
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ParticipantListScreen(),
                      ),
                    );
                  },
                  child: Text('참가 신청 목록'),
                ),
              ],
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
                    print("댓글 등록됨: ${_commentController.text}");
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
