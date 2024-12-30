import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/todo_model.dart';

class DBHelper {
  DBHelper._();
  static final DBHelper instance = DBHelper._();
  Database? db;

  Future<void> initDb() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, "todo.db");

    db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        String query = '''
          CREATE TABLE IF NOT EXISTS todos (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            isBookmarked INTEGER NOT NULL
          )
        ''';
        db.execute(query);
      },
    );
  }

  Future<int> insertTodo({required Todo todo}) async {
    await initDb();
    Map<String, dynamic> data = {
      'title': todo.title,
      'isBookmarked': todo.isBookmarked ? 1 : 0,
    };
    return await db!.insert('todos', data);
  }

  Future<List<Todo>> getTodos() async {
    await initDb();
    List<Map<String, dynamic>> data = await db!.query('todos');
    return data.map((item) {
      return Todo(
        id: item['id'],
        title: item['title'],
        isBookmarked: item['isBookmarked'] == 1,
      );
    }).toList();
  }

  Future<int> updateTodo({required Todo todo}) async {
    await initDb();
    Map<String, dynamic> data = {
      'title': todo.title,
      'isBookmarked': todo.isBookmarked ? 1 : 0,
    };
    return await db!.update(
      'todos',
      data,
      where: 'id = ?',
      whereArgs: [todo.id],
    );
  }

  Future<void> removeTodo(int id) async {
    await initDb();
    await db!.delete('todos', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> removeAllTodos() async {
    await initDb();
    await db!.delete('todos');
  }
}
