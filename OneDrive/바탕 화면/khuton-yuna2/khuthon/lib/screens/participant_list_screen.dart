import 'package:flutter/material.dart';

class ParticipantListScreen extends StatefulWidget {
  @override
  _ParticipantListScreenState createState() => _ParticipantListScreenState();
}

class _ParticipantListScreenState extends State<ParticipantListScreen> {
  final List<Map<String, String>> participants = [
    {
      'name': '○○○',
      'profile': 'assets/profile.png',
      'location': '서울시 마포구',
      'age': '29세',
      'gender': '여성',
      'mbti': 'INFJ',
      'favorite': '방울토마토'
    },
  ];

  final List<String> statuses = ["none"];

  void _showProfileDialog(BuildContext context, Map<String, String> user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${user['name']} 님의 정보'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('거주지: ${user['location']}'),
            Text('나이: ${user['age']}'),
            Text('성별: ${user['gender']}'),
            Text('MBTI: ${user['mbti']}'),
            Text('선호 작물: ${user['favorite']}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('닫기'),
          )
        ],
      ),
    );
  }

  void _showReportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('신고'),
        content: Text('이 화면을 신고하시겠습니까?'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.green[200],
        title: Text('참가 신청 목록'),
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
      body: ListView.builder(
        itemCount: participants.length,
        itemBuilder: (context, index) {
          final user = participants[index];
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => _showProfileDialog(context, user),
                    child: CircleAvatar(
                      backgroundImage: AssetImage(user['profile']!),
                      radius: 30,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${user['name']} 님으로부터\n참가 신청이 들어왔습니다.'),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            OutlinedButton(
                              onPressed: () {
                                setState(() {
                                  statuses[index] = "accepted";
                                });
                              },
                              style: OutlinedButton.styleFrom(
                                backgroundColor: statuses[index] == "accepted"
                                    ? Colors.green[100]
                                    : null,
                              ),
                              child: Text('참가 수락'),
                            ),
                            SizedBox(width: 8),
                            OutlinedButton(
                              onPressed: () {
                                setState(() {
                                  statuses[index] = "rejected";
                                });
                              },
                              style: OutlinedButton.styleFrom(
                                backgroundColor: statuses[index] == "rejected"
                                    ? Colors.red[100]
                                    : null,
                              ),
                              child: Text('참가 거절'),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
