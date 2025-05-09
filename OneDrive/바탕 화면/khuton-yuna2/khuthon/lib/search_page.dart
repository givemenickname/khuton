import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<dynamic> _results = [];

  Future<void> _fetchSearchResults(String keyword) async {
    final url = Uri.parse('http://172.21.65.64:5000/search?keyword=$keyword'); // ← 자신의 PC IP로 변경
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _results = data['results'];
        });
      } else {
        setState(() {
          _results = [];
        });
      }
    } catch (e) {
      print("에러 발생: $e");
      setState(() {
        _results = [];
      });
    }
  }

  void _onSearchChanged(String keyword) {
    if (keyword.trim().isNotEmpty) {
      _fetchSearchResults(keyword);
    } else {
      setState(() {
        _results = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('검색')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: '검색어를 입력하세요',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: _onSearchChanged,
            ),
            SizedBox(height: 20),
            Expanded(
              child: _results.isEmpty
                  ? Center(child: Text('검색 결과가 여기에 표시됩니다'))
                  : ListView.builder(
                      itemCount: _results.length,
                      itemBuilder: (context, index) {
                        final item = _results[index];
                        return ListTile(
                          title: Text(item['title'] ?? '제목 없음'),
                          subtitle: Text(item['content'] ?? '내용 없음'),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
