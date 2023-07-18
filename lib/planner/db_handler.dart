// ignore_for_file: depend_on_referenced_packages, non_constant_identifier_names

import 'package:path_provider/path_provider.dart'
    show getApplicationDocumentsDirectory;
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:planner_sqflite/planner/model.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Database? _db;

  // Veritabanı erişimi için bir getter oluşturuyoruz.
  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDatabase();
    return null;
  }

  // Veritabanını başlatmak için bir fonksiyon
  initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path,
        'Todo.db'); // Veritabanı adı ve yolunu belirtiyoruz
    var db = await openDatabase(path, version: 1, onCreate: _createDatabase);
    return db;
  }

  // Veritabanını oluşturan fonksiyon
  _createDatabase(Database db, int version) async {
    // Veritabanında oluşturulacak tabloyu (mytodo) yaratıyoruz
    await db.execute(
        "CREATE TABLE mytodo(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT NOT NULL, desc TEXT NOT NULL, dateandtime TEXT NOT NULL)");
    version = 1;
  }

  // Veritabanına veri ekleyen fonksiyon
  Future<ToDoModel> insert(ToDoModel todoModel) async {
    var dbClient = await db;
    await dbClient?.insert('mytodo', todoModel.toMap());
    return todoModel;
  }

  // Veritabanından verileri çeken fonksiyon
  Future<List<ToDoModel>> getDataList() async {
    await db;
    final List<Map<String, Object?>> QueryResult =
        await _db!.rawQuery('SELECT * FROM mytodo');
    return QueryResult.map((e) => ToDoModel.fromMap(e)).toList();
  }

  // Veritabanından veri silen fonksiyon
  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient!.delete('mytodo', where: 'id = ?', whereArgs: [id]);
  }

  // Veritabanında veriyi güncelleyen fonksiyon
  Future<int> update(ToDoModel toDoModel) async {
    var dbClient = await db;
    return await dbClient!.update('mytodo', toDoModel.toMap(),
        where: 'id = ?', whereArgs: [toDoModel.id]);
  }
}
