import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'produto.dart';

final String tabelaProduto = "t_produto";

class DbHelper {
  static final DbHelper _instance = DbHelper.internal();

  factory DbHelper() => _instance;

  DbHelper.internal();

  static Database? _db;

  Future<Database?> get db async {
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
          "CREATE TABLE $tabelaProduto($idColumn INT PRIMARY KEY, $descColumn TEXT, $undColumn TEXT, $grupoColumn INT)");
    });
  }

  Future<List<dynamic>> saveProdutos(List<List<dynamic>> listProds) async {
    Database? dbProd = await db;
    var batch = dbProd!.batch();

    for(int i = 1; i < listProds.length; i++){
      final linha = listProds[i].toString().split(';');
      Map<String, dynamic> map = {
        'id' : int.parse(linha[0].substring(1)),
        'descricao': linha[1],
        'undMedida': linha[2],
        'grupo': int.parse(linha[3].substring(0, linha[3].length -1)),
      };

      final Produto prod = await getProduto(map['id']);
      if(prod.id == 0){
        batch.insert(tabelaProduto, map);
      } else if(prod.id == map['id']){
        batch.update(tabelaProduto, map,
            where: "$idColumn = ?", whereArgs: [map['id']]);
      } else {
        print('ITEM NAO FOI INSERIDO NEM ATUALIZADO');
      }
    }

    return await batch.commit();
  }

  Future<Produto> getProduto(int id) async {
    Database? dbProd = await db;
    List<Map> maps = await dbProd!.query(
      tabelaProduto,
      columns: [idColumn, descColumn, undColumn, grupoColumn],
      where: "$idColumn = ?",
      whereArgs: [id],
    );

    if (maps.length > 0) {
      return Produto.fromMap(maps.first);
    } else {
      return new Produto(id: 0, descricao: "null", undMedida: "null", grupo: 0);
    }
  }

  Future<int> deleteProduto(int id) async {
    Database? dbProd = await db;
    return await dbProd!
        .delete(tabelaProduto, where: "$idColumn = ?", whereArgs: [id]);
  }

  Future<List> getTodosProdutos() async {
    Database? dbProd = await db;
    List listMap = await dbProd!.rawQuery("SELECT * FROM $tabelaProduto");
    List<Produto> listProd = List.generate(
      listMap.length,
      (index) {
        return Produto.fromMap(listMap[index]);
      },
      growable: false,
    );

    return listProd;
  }

  Future<int> getNumber() async {
    Database? dbProd = await db;
    return Sqflite.firstIntValue(
        await dbProd!.rawQuery("SELECT COUNT(*) FROM $tabelaProduto"));
  }

  deleteTable (String table) async {
    Database? dbProd = await db;
    return await dbProd!.rawQuery("sql");
  }

  close() async {
    Database? dbProd = await db;
    dbProd!.close();
  }
}
