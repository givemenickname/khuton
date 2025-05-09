import 'dart:async';
import 'package:flutter/material.dart';
import 'screens/post_detail_screen.dart';
import 'screens/my_post_detail_screen.dart';
import 'post_create.dart';
import 'notification_page.dart';
import 'screens/chat_list_page.dart';
import 'mypage.dart';
import 'search_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '도시텃밭 앱',
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final PageController _pageController = PageController(initialPage: 1000);
  Timer? _timer;
  bool _isMenuOpen = false;

  final List<String> imagePaths = [
    'assets/images/0e2b5241-7944-4f4d-833a-1b103b20eac6.png',
    'assets/images/5dbc0dd3-2415-427a-b27d-96e755229e6b.png',
    'assets/images/256ec655-fcc8-4fca-a4cc-9c5bd84fe622.png',
    'assets/images/img_01.png',
  ];

  final List<Map<String, dynamic>> posts = [
    {
      "title": "○○동 ○○텃밭에서 같이 배추 재배할 사람들 구해요!",
      "people": "12/20명",
      "isMine": false,
      "status": "모집 중"
    },
    {
      "title": "□□빌딩 옥상에서 방울토마토 재배해요",
      "people": "2/5명",
      "isMine": true,
      "status": "모집 중"
    },
    {
      "title": "같이 잘 키워봅시다",
      "people": "9/25명",
      "isMine": false,
      "status": "모집 중"
    }
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
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
          icon: const Icon(Icons.local_florist),
          onPressed: () {
            setState(() {
              _isMenuOpen = true;
            });
          },
        ),
        title: const Text('도시텃밭'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(
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
                  padding: const EdgeInsets.only(bottom: 80),
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: GestureDetector(
                        onTap: () async {
                          final isMine = posts[index]['isMine'] as bool;
                          if (isMine) {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => MyPostDetailScreen(
                                    title: posts[index]['title']),
                              ),
                            );
                            if (result == false) {
                              setState(() {
                                posts[index]['status'] = '모집 마감';
                              });
                            } else if (result == true) {
                              setState(() {
                                posts[index]['status'] = '모집 중';
                              });
                            }
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PostDetailScreen(
                                    title: posts[index]['title']),
                              ),
                            );
                          }
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
                                posts[index]['title'],
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "인원 ${posts[index]['people']}",
                                    style:
                                    TextStyle(color: Colors.grey[700]),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 6),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey.shade400),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      posts[index]['status'],
                                      style: const TextStyle(
                                          fontSize: 13, color: Colors.black87),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SearchPage()),
                    );
                  },
                  child: Icon(Icons.search),
                ),
                FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => PostCreatePage()),
                    );
                  },
                  child: const Icon(Icons.edit),
                ),
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
              child: Container(
                color: Colors.black54,
              ),
            ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            left: _isMenuOpen ? 0 : -menuWidth,
            top: 0,
            bottom: 0,
            child: Container(
              width: menuWidth,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildMenuButton(
                    icon: Icons.comment,
                    tooltip: '댓글',
                    onTap: () {
                      _closeMenuAndNavigate(() {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => PostListPage()),
                        );
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildMenuButton(
                    icon: Icons.notifications,
                    tooltip: '알림',
                    onTap: () {
                      _closeMenuAndNavigate(() {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const NotificationPage()),
                        );
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildMenuButton(
                    icon: Icons.person,
                    tooltip: '프로필',
                    onTap: () {
                      _closeMenuAndNavigate(() {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const ProfilePage()),
                        );
                      });
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

  Widget _buildMenuButton(
      {required IconData icon,
        required String tooltip,
        required VoidCallback onTap}) {
    return IconButton(
      icon: Icon(icon),
      iconSize: 30,
      tooltip: tooltip,
      onPressed: () {
        _closeMenuAndNavigate(onTap);
      },
    );
  }

  void _closeMenuAndNavigate(VoidCallback navigate) {
    setState(() {
      _isMenuOpen = false;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => navigate());
  }
}
