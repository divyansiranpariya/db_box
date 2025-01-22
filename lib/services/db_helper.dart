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

  Future<int> rawInsertTodo({required Todo todo}) async {
    await initDb();
    String query = "INSERT INTO todos (title, isBookmarked)VALUES ("${todo.title}", ${todo.isBookmarked ? 1 : 0})";
    return await db!.rawInsert(query);
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

  Future<int> rawUpdateTodo({required Todo todo}) async {
    await initDb();
    String query = "UPDATE todos SET title = "${todo.title}", isBookmarked = ${todo.isBookmarked ? 1 : 0} WHERE id = ${todo.id}";
    return await db!.rawUpdate(query);
  }

  Future<void> rawDeleteTodo(int id) async {
    await initDb();
    String query = '''
      DELETE FROM todos WHERE id = $id
    ''';
    await db!.rawDelete(query);
  }

  Future<void> removeAllTodos() async {
    await initDb();
    await db!.delete('todos');
  }
}
