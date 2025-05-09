import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final idController = TextEditingController();
  final pwController = TextEditingController();
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final cropController = TextEditingController();

  String gender = '';
  String year = '2000';
  String month = '1';
  String day = '1';

  String mbti1 = '';
  String mbti2 = '';
  String mbti3 = '';
  String mbti4 = '';

  String get fullMBTI => mbti1 + mbti2 + mbti3 + mbti4;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD7EEC6),
      appBar: AppBar(
        backgroundColor: Color(0xFFD7EEC6),
        elevation: 0,
        title: Text('회원가입', style: TextStyle(color: Colors.black)),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildField('아이디', idController),
            buildField('비밀번호', pwController, obscure: true),
            buildField('닉네임', nameController),
            SizedBox(height: 16),
            Text('성별'),
            Row(
              children: [
                choiceChip('남성', gender, (v) => gender = v),
                SizedBox(width: 10),
                choiceChip('여성', gender, (v) => gender = v),
              ],
            ),
            SizedBox(height: 16),
            Text('생년월일'),
            Row(
              children: [
                dropdown(
                  year,
                  List.generate(100, (i) => (1925 + i).toString()),
                  (v) => setState(() => year = v),
                ),
                SizedBox(width: 10),
                dropdown(
                  month,
                  List.generate(12, (i) => (i + 1).toString()),
                  (v) => setState(() => month = v),
                ),
                SizedBox(width: 10),
                dropdown(
                  day,
                  List.generate(31, (i) => (i + 1).toString()),
                  (v) => setState(() => day = v),
                ),
              ],
            ),
            SizedBox(height: 16),
            buildField('주소', addressController),
            SizedBox(height: 16),
            Text('MBTI'),
            Wrap(
              spacing: 6,
              children:
                  [
                    'E',
                    'I',
                  ].map((e) => choiceChip(e, mbti1, (v) => mbti1 = v)).toList(),
            ),
            Wrap(
              spacing: 6,
              children:
                  [
                    'N',
                    'S',
                  ].map((e) => choiceChip(e, mbti2, (v) => mbti2 = v)).toList(),
            ),
            Wrap(
              spacing: 6,
              children:
                  [
                    'F',
                    'T',
                  ].map((e) => choiceChip(e, mbti3, (v) => mbti3 = v)).toList(),
            ),
            Wrap(
              spacing: 6,
              children:
                  [
                    'P',
                    'J',
                  ].map((e) => choiceChip(e, mbti4, (v) => mbti4 = v)).toList(),
            ),
            SizedBox(height: 16),
            buildField('선호 농작물', cropController),
            SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  final id = idController.text.trim();
                  final pw = pwController.text.trim();
                  final name = nameController.text.trim();
                  final address = addressController.text.trim();
                  final plant = cropController.text.trim();
                  final birth = "$year-$month-$day";

                  final url = Uri.parse("http://172.21.110.186:5000/signin");

                  final response = await http.post(
                    url,
                    headers: {"Content-Type": "application/json"},
                    body: jsonEncode({
                      "id": id,
                      "password": pw,
                      "name": name,
                      "gender": gender,
                      "birth": birth,
                      "address": address,
                      "mbti": fullMBTI,
                      "plant": plant,
                    }),
                  );

                  final result = jsonDecode(response.body);
                  if (response.statusCode == 200 && result["result"] == "success") {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text("회원가입 성공"),
                        actions: [
                          TextButton(
                            child: Text("확인"),
                            onPressed: () {
                              Navigator.pop(context);       // dialog 닫기
                              Navigator.pop(context);       // 회원가입 페이지 닫고 로그인으로
                            },
                          ),
                        ],
                      ),
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text("오류"),
                        content: Text(result["message"] ?? "회원가입 실패"),
                        actions: [
                          TextButton(
                            child: Text("확인"),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    );
                  }
                },

                child: Text('완료'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildField(
    String label,
    TextEditingController controller, {
    bool obscure = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.green[100],
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget choiceChip(
    String label,
    String groupValue,
    void Function(String) onSelected,
  ) {
    return ChoiceChip(
      label: Text(label),
      selected: groupValue == label,
      onSelected: (_) => setState(() => onSelected(label)),
    );
  }

  Widget dropdown(
    String value,
    List<String> items,
    ValueChanged<String> onChanged,
  ) {
    return DropdownButton<String>(
      value: items.contains(value) ? value : null,
      items:
          items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: (v) {
        if (v != null) onChanged(v);
      },
    );
  }
}
