import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('todo.db'); // 파일 이름 지정
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE todoList (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        content TEXT NOT NULL,
        status INTEGER NOT NULL
      )
    ''');
  }

  /// 메모 추가
  Future<int> createTodo(String date, String content, {int status = 0}) async {
    final db = await instance.database;
    final data = {
      'date': date,
      'content': content,
      'status': status,
    };
    return await db.insert('todoList', data);
  }

  /// 모든 메모 읽기 (사용 안 해도 됨)
  Future<List<Map<String, dynamic>>> readAllTodo() async {
    final db = await instance.database;
    return await db.query('todoList');
  }

  /// 날짜별 메모 불러오기
  Future<List<Map<String, dynamic>>> readMemosByDate(String date) async {
    final db = await instance.database;
    return await db.query(
      'todoList',
      where: 'date = ?',
      whereArgs: [date],
    );
  }

  /// 메모 업데이트
  Future<int> updateTodo(int id, String content, {int status = 0}) async {
    final db = await instance.database;
    final data = {'content': content, 'status': status};
    return await db.update('todoList', data, where: 'id = ?', whereArgs: [id]);
  }

  /// 메모 삭제
  Future<int> deleteTodo(int id) async {
    final db = await instance.database;
    return await db.delete('todoList', where: 'id = ?', whereArgs: [id]);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
