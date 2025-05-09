import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<dynamic>> searchPosts(String keyword) async {
  final uri = Uri.parse(" http://172.21.65.64:5030/search?keyword=$keyword");
  final response = await http.get(uri);

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return (data["data"] as Map<String, dynamic>)
        .entries
        .map((e) => {"pid": e.key, ...e.value})
        .toList();
  } else {
    throw Exception("검색 실패");
  }
}
