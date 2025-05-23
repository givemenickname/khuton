import 'dart:async';
import 'package:flutter/material.dart';
import 'package:khuthon/post_create.dart';
import 'post_detail_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final PageController _pageController = PageController(initialPage: 1000);
  Timer? _timer;
  bool _isMenuOpen = false;

  final List<String> imagePaths = [
    'assets/0e2b5241-7944-4f4d-833a-1b103b20eac6.png',
    'assets/5dbc0dd3-2415-427a-b27d-96e755229e6b.png',
    'assets/256ec655-fcc8-4fca-a4cc-9c5bd84fe622.png',
    'assets/img_01.png',
  ];

  /*final List<Map<String, String>> posts = [
    {"title": "○○동 ○○텃밭에서 같이 배추 재배할 사람들 구해요!", "people": "12/20명"},
    {"title": "□□빌딩 옥상에서 방울토마토 재배해요", "people": "2/5명"},
    {"title": "같이 잘 키워봅시다", "people": "9/25명"},
  ];*/

  List<Map<String, dynamic>> _posts = [];

  Future<void> fetchPosts() async {
    final url = Uri.parse("http://172.21.110.186:5000/posts"); // IP 수정!
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final postData = data['data'] as Map<String, dynamic>;
        setState(() {
          _posts = postData.entries.map((entry) {
            return {
              "id": entry.key,
              "title": entry.value['title'],
              "people": entry.value['people'],
            };
          }).toList().reversed.toList(); // 최신 글이 위에
        });
      } else {
        print("불러오기 실패: ${response.body}");
      }
    } catch (e) {
      print("에러 발생: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchPosts();
    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double menuWidth = MediaQuery.of(context).size.width / 3;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.local_florist),
          onPressed: () {
            setState(() {
              _isMenuOpen = true;
            });
          },
        ),
        title: Text('도시텃밭'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 200,
                child: PageView.builder(
                  controller: _pageController,
                  itemBuilder: (context, index) {
                    final path = imagePaths[index % imagePaths.length];
                    return Image.asset(path, fit: BoxFit.cover);
                  },
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _posts.length,
                  itemBuilder: (context, index) {
                    final post = _posts[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PostDetailScreen(title: post['title']),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                post['title'],
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "인원 ${post['people']}",
                                    style: TextStyle(color: Colors.grey[700]),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey.shade400),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      "모집 중",
                                      style: TextStyle(fontSize: 13, color: Colors.black87),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                )
              ),
            ],
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FloatingActionButton(
                  onPressed: () {},
                  child: Icon(Icons.search),
                ),
                FloatingActionButton(onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PostCreatePage()),
                  );

                  if (result == true) {
                    fetchPosts();  // ✅ 다시 게시글 불러오기
                  }
                }, child: Icon(Icons.edit)),
              ],
            ),
          ),
          if (_isMenuOpen)
            GestureDetector(
              onTap: () {
                setState(() {
                  _isMenuOpen = false;
                });
              },
              child: Container(color: Colors.black54),
            ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 300),
            left: _isMenuOpen ? 0 : -menuWidth,
            top: 0,
            bottom: 0,
            child: Container(
              width: menuWidth,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.comment),
                    iconSize: 30,
                    tooltip: '댓글',
                    onPressed: () {
                      print('댓글 아이콘 클릭됨');
                    },
                  ),
                  SizedBox(height: 20),
                  IconButton(
                    icon: Icon(Icons.notifications),
                    iconSize: 30,
                    tooltip: '알림',
                    onPressed: () {
                      print('알림 아이콘 클릭됨');
                    },
                  ),
                  SizedBox(height: 20),
                  IconButton(
                    icon: Icon(Icons.person),
                    iconSize: 30,
                    tooltip: '마이페이지',
                    onPressed: () {
                      print('마이페이지 아이콘 클릭됨');
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
