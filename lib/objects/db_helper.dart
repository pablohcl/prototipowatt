import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'produto.dart';

final String tabelaProduto = "t_produto";

class DbHelper {
  static final DbHelper _instance = DbHelper.internal();

  factory DbHelper() => _instance;

  DbHelper.internal();

  late Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "base.db");

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int newerVersion) async {
      await db.execute(
          "CREATE TABLE $tabelaProduto($idColumn INT PRIMARY KEY, $descColumn TEXT, $undColumn TEXT, $grupoColumn TEXT,)");
    });
  }

  Future<Produto> saveProduto(Produto produto) async {
    Database dbProd = await db;
    await dbProd.insert(tabelaProduto, produto.toMap());
    return produto;
  }

  Future<Produto> getProduto(int id) async {
    Database dbProd = await db;
    List<Map> maps = await dbProd.query(
      tabelaProduto,
      columns: [idColumn, descColumn, undColumn, grupoColumn],
      where: "$idColumn = ?",
      whereArgs: [id],
    );

    if(maps.length > 0){
      return Produto.fromMap(maps.first);
    } else {
      return new Produto(id: 0, descricao: "null", undMedida: "null", grupo: 0);
    }
  }

  Future<int> deleteProduto(int id) async {
    Database dbProd = await db;
    return await dbProd.delete(tabelaProduto, where: "$idColumn = ?", whereArgs: [id]);
  }

  Future<int> updateProduto(Produto produto) async {
    Database dbProd = await db;
    return await dbProd.update(tabelaProduto, produto.toMap(), where: "$idColumn = ?", whereArgs: [produto.id]);
  }

  Future<List> getTodosProdutos() async {
    Database dbProd = await db;
    List listMap  = await dbProd.rawQuery("SELECT * FROM $tabelaProduto");
    List<Produto> listProd = List.empty();
    for(Map m in listMap){
      listProd.add(Produto.fromMap(m));
    }
    return listProd;
  }

  Future<int> getNumber() async {
    Database dbProd = await db;
    return Sqflite.firstIntValue(await dbProd.rawQuery("SELECT COUNT(*) FROM $tabelaProduto"));
  }

  close() async {
    Database dbProd = await db;
    dbProd.close();
  }
}
