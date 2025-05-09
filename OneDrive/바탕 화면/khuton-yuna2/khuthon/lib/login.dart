import 'package:flutter/material.dart';
import 'register.dart';
import 'main_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPage extends StatelessWidget {
  final TextEditingController idController = TextEditingController();
  final TextEditingController pwController = TextEditingController();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    print('✅ LoginPage 실행됨');
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
                    onPressed: () async {
                      final url = Uri.parse('http://172.21.87.83:5000/login');
                      final response = await http.post(
                        url,
                        headers: {'Content-Type': 'application/json'},
                        body: jsonEncode({
                          "id": idController.text,
                          "password": pwController.text,
                        }),
                      );

                      final result = jsonDecode(response.body);
                      if (result['result'] == 'success') {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => MainScreen()),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('로그인 실패')));
                      }
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
