import 'package:flutter/material.dart';
import 'register.dart';
import 'main_page.dart';


class LoginPage extends StatelessWidget {
  final TextEditingController idController = TextEditingController();
  final TextEditingController pwController = TextEditingController();

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
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => MainScreen()),
                      );
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

