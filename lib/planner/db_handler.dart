import 'package:path_provider/path_provider.dart'
    show getApplicationDocumentsDirectory;
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:planner_sqflite/planner/model.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Database? _db;
  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDatabase();
    return null;
  }

  initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'Todo.db'); //veritabanı adı
    var db = await openDatabase(path, version: 1, onCreate: _createDatabase);
    return db;
  }

//veritabanı oluştur
  //create table in the database
  _createDatabase(Database db, int version) async {
    //Veritabanında oluştrulacak tablo create edilir(yaratılır)
    await db.execute(
        "CREATE TABLE mytodo(id INTEGER PRIMARY KEY AUTOINCREMENT,title TEXT NOT NULL,desc TEXT NOT NULL,dateandtime TEXT NOT NULL)");
    version = 1;
  }

  //inseert data
  Future<ToDoModel> insert(ToDoModel todoModel) async {
    //ekleme fonksiyonu
    var dbClint = await db;
    await dbClint?.insert('mytodo', todoModel.toMap());
    return todoModel;
  }

  //Verileri database'den çekiyoruz
  Future<List<ToDoModel>> getDataList() async {
    await db;
    final List<Map<String, Object?>> QueryResult =
        await _db!.rawQuery('SELECT *FROM mytodo');
    return QueryResult.map((e) => ToDoModel.fromMap(e)).toList();
  }

  //delete işlemi
  Future<int> delete(int id) async {
    var dbClint = await db;
    return await dbClint!.delete('mytodo', where: 'id=?', whereArgs: [id]);
  }

  //update(güncelleme işlemi)
  Future<int> update(ToDoModel toDoModel) async {
    var dbClint = await db;
    return await dbClint!.update('mytodo', toDoModel.toMap(),
        where: 'id = ?', whereArgs: [toDoModel.id]);
  }
}
