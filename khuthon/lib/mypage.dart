import 'package:flutter/material.dart';
import 'edit_profile.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFFD7EEC6),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            color: Color(0xFFD7EEC6),
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.account_circle, size: 80),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('닉네임',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => EditProfilePage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightGreen[200],
                        minimumSize: Size.fromHeight(40),
                      ),
                      child: Text('프로필 수정'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          buildInfoItem('성별'),
          buildInfoItem('연령대'),
          buildInfoItem('거주지'),
          buildInfoItem('MBTI'),
          buildInfoItem('선호농작물'),
          SizedBox(height: 40),
          TextButton(
            onPressed: () {
              // TODO: 비밀번호 변경 기능 연결
            },
            child: Text('비밀번호 변경', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }

  Widget buildInfoItem(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        '<$label>',
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}
