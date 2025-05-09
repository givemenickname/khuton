import 'package:flutter/material.dart';
import 'register.dart';
import 'main_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class LoginPage extends StatelessWidget {
  final TextEditingController idController = TextEditingController();
  final TextEditingController pwController = TextEditingController();

  LoginPage({super.key});

  Future<void> attemptLogin(BuildContext context) async {
    final id = idController.text.trim();
    final pw = pwController.text.trim();

    final url = Uri.parse("http://172.21.110.186:5000/login"); // ← 너의 PC IP 주소로 변경
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "id": id,
          "password": pw,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final uid = data['uid'];
        print("로그인 성공: UID = $uid");

        // 메인 화면으로 이동
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => MainScreen()),
        );
      } else {
        print("로그인 실패: ${response.body}");
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text("로그인 실패"),
            content: Text("아이디 또는 비밀번호를 확인하세요."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("확인"),
              )
            ],
          ),
        );
      }
    } catch (e) {
      print("오류 발생: $e");
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("에러"),
          content: Text("서버에 연결할 수 없습니다."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("확인"),
            )
          ],
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD7EEC6),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '같이농장',
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              width: 300,
              child: Column(
                children: [
                  customTextField('아이디', idController),
                  SizedBox(height: 12),
                  customTextField('비밀번호', pwController, obscure: true),
                  SizedBox(height: 12),
/*                  ElevatedButton(
                    onPressed: () {
                      print('로그인: ${idController.text}');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightGreen[200],
                      minimumSize: Size.fromHeight(40),
                    ),
                    child: Text('로그인'),
                  ),*/
                  ElevatedButton(
                    onPressed: () {
                      // 로그인 검증 로직 추가 가능
                      attemptLogin(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightGreen[200],
                      minimumSize: Size.fromHeight(40),
                    ),
                    child: Text('로그인'),
                  ),
                  SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => RegisterPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightGreen[200],
                      minimumSize: Size.fromHeight(40),
                    ),
                    child: Text('회원가입'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget customTextField(
    String hint,
    TextEditingController controller, {
    bool obscure = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.lightGreen[100],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

