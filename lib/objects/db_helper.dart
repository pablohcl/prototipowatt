import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'produto.dart';

final String tabelaProduto = "t_produto";

class DbHelper {

  static final DbHelper _instance = DbHelper.internal();

  factory DbHelper() => _instance;

  DbHelper.internal();

  Database _db;

  Future<Database> get db async {
    if(_db != null){
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "base.db");

    return await openDatabase(path, version: 1, onCreate: (Database db, int newerVersion) async {
      await db.execute(
        "CREATE TABLE $tabelaProduto($idColumn INT PRIMARY KEY, $descColumn TEXT, $undColumn TEXT, $grupoColumn TEXT)"
      );
    });
  }
}