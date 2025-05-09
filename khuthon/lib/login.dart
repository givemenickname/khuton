import 'package:flutter/material.dart';
import 'register.dart';
import 'main_page.dart';
import 'package:firebase_database/firebase_database.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController idController = TextEditingController();
  final TextEditingController pwController = TextEditingController();

  // Firebase Realtime Database 인스턴스
  final FirebaseDatabase database = FirebaseDatabase.instance;

  LoginPage({super.key});

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
                  ElevatedButton(
                    onPressed: () async {
                      String inputId = idController.text;
                      String inputPw = pwController.text;

                      DatabaseReference ref = database.ref("users");

                      try {
                        DatabaseEvent event = await ref.once();
                        Map<dynamic, dynamic>? users = event.snapshot.value as Map?;

                        bool loginSuccess = false;

                        if (users != null) {
                          users.forEach((key, value) {
                            if (value["id"] == inputId && value["pw"] == inputPw) {
                              loginSuccess = true;
                            }
                          });
                        }

                        if (loginSuccess) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => MainScreen()),
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: Text("로그인 실패"),
                              content: Text("아이디 또는 비밀번호가 올바르지 않습니다."),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text("확인"),
                                ),
                              ],
                            ),
                          );
                        }
                      } catch (e) {
                        print("로그인 오류: $e");
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
