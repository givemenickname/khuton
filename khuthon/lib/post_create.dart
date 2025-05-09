import 'package:flutter/material.dart';
import 'main_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class PostCreatePage extends StatelessWidget {
  const PostCreatePage({super.key});

  void _showDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("확인"),
          )
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    final maxPeopleController = TextEditingController();

    return Scaffold(
      backgroundColor: const Color(0xFFD7EEC6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFD7EEC6),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "제목",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
                hintText: "제목을 입력하세요.",
              ),
            ),
            const Divider(height: 32),
            const Text("본문을 입력하세요."),
            const SizedBox(height: 12),
            TextField(
              controller: contentController,
              maxLines: 4,
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 32),
            const Text("최대 인원 설정",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: maxPeopleController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () async {
                  final title = titleController.text.trim();
                  final contents = contentController.text.trim();
                  final capacity = maxPeopleController.text.trim();

                  final prefs = await SharedPreferences.getInstance();
                  final uid = prefs.getString('uid');
              

                  final url = Uri.parse("http://172.21.110.186:5000/write"); // 실제 Flask 서버 IP로 변경
                  try {
                    final response = await http.post(
                      url,
                      headers: {"Content-Type": "application/json"},
                      body: json.encode({
                        "uid": uid,
                        "title": title,
                        "contents": contents,
                        "capacity": capacity,
                        "state": "open",
                        "people": "0/$capacity명",
                      }),
                    );

                    if (response.statusCode == 200) {
                      print("✅ 글 작성 성공: ${response.body}");
                      Navigator.pop(context, true); // 글 작성 후 이전 화면으로 돌아가기
                    } else {
                      print("❌ 글 작성 실패: ${response.body}");
                      _showDialog(context, "등록 실패", "입력값을 다시 확인해주세요.");
                    }
                  } catch (e) {
                    print("🚨 네트워크 에러: $e");
                    _showDialog(context, "에러", "서버에 연결할 수 없습니다.");
                  }
                },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    elevation: 2,
                  ),
                  child:
                      const Text("등록", style: TextStyle(color: Colors.black)),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
