import 'package:firebase_auth/firebase_auth.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'produto.dart';

final String tabelaProduto = "t_produto";

final String dropTables = "DROP TABLE $tabelaProduto";
final String createTables =
    "CREATE TABLE $tabelaProduto($idColumn INT PRIMARY KEY, $refColumn TEXT, $descColumn TEXT, $undColumn TEXT, $grupoColumn INT, $vCompraColumn DECIMAL, $vMinColumn DECIMAL, $vProdColumn DECIMAL, $vSugColumn DECIMAL)";

class DbHelper {
  static final DbHelper _instance = DbHelper.internal();
  FirebaseAuth _auth = FirebaseAuth.instance;

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

    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int newerVersion) async {
        await db.execute(createTables);
      },
    );
  }

  Future<void> recreateTables() async {
    Database? dbProd = await db;
    await dbProd!.execute(dropTables);
    await dbProd.execute(createTables);
  }

  Future<List<dynamic>> saveProdutos(List<List<dynamic>> listProds) async {
    Database? dbProd = await db;
    var batch = dbProd!.batch();
    for (int i = 1; i < listProds.length; i++) {
      final linha = listProds[i].toString().split(';');
      final Map<String, dynamic> map = {
        idColumn: int.parse(linha[0].substring(1)),
        refColumn: linha[1].toString(),
        descColumn: linha[2],
        undColumn: linha[3],
        grupoColumn: int.parse(linha[4]),
        vCompraColumn: linha[5].replaceAll(",", ".").replaceAll(" ", ""),
        vMinColumn: linha[6].replaceAll(",", ".").replaceAll(" ", ""),
        vProdColumn: linha[7].replaceAll(",", ".").replaceAll(" ", ""),
        vSugColumn: linha[8]
            .substring(0, linha[8].length - 1)
            .replaceAll(",", ".")
            .replaceAll(" ", ""),
      };
      print(map[vCompraColumn]);

      batch.insert(tabelaProduto, map);
    }

    return await batch.commit();
  }

  Future<Produto> getProduto(int id) async {
    Database? dbProd = await db;
    /*List<Map> maps = await dbProd!.query(
      tabelaProduto,
      columns: [idColumn, descColumn, undColumn, grupoColumn, vCompraColumn, vMinColumn, vProdColumn, vSugColumn],
      where: "$idColumn = ?",
      whereArgs: [id],
    );*/

    List<Map> maps = await dbProd!
        .rawQuery("SELECT * FROM $tabelaProduto WHERE $idColumn = $id");

    if (maps.isNotEmpty) {
      print(maps.toString());
      return Produto.fromMap(maps.first);
    } else {
      return new Produto(
          id: 0,
          ref: "null",
          descricao: "null",
          undMedida: "null",
          grupo: 0,
          valorCompra: 0,
          valorMin: 0,
          valorProd: 0,
          valorSugerido: 0);
    }
  }

  Future<int> deleteProduto(int id) async {
    Database? dbProd = await db;
    return await dbProd!
        .delete(tabelaProduto, where: "$idColumn = ?", whereArgs: [id]);
  }

  Future<List<Produto>> getTodosProdutos() async {
    Database? dbProd = await db;
    List listMap = await dbProd!.rawQuery("SELECT * FROM $tabelaProduto");
    List<Produto> listProd = List.generate(
      listMap.length,
      (index) {
        return Produto.fromMap(listMap[index]);
      },
      growable: true,
    );

    return listProd;
  }

  Future<List<Produto>> buscaProdutos(String textoDigitado) async {
    Database? dbProd = await db;
    List listMap = await dbProd!.rawQuery(
        "SELECT * FROM $tabelaProduto WHERE $descColumn LIKE '%$textoDigitado%'");
    print(
        "SELECT * FROM $tabelaProduto WHERE $descColumn LIKE '%$textoDigitado%'");
    print(listMap.length);
    return List.generate(
      listMap.length,
      (index) {
        return Produto.fromMap(listMap[index]);
      },
      growable: true,
    );
  }

  Future<int> getNumber() async {
    Database? dbProd = await db;
    return Sqflite.firstIntValue(
        await dbProd!.rawQuery("SELECT COUNT(*) FROM $tabelaProduto"));
  }

  deleteTable(String table) async {
    Database? dbProd = await db;
    return await dbProd!.rawQuery("sql");
  }

  close() async {
    Database? dbProd = await db;
    dbProd!.close();
  }

  bool isAdmin() {
    if (_auth.currentUser!.email == "pablo@wattdistribuidora.com.br" ||
        _auth.currentUser!.email == "waltair@wattdistribuidora.com.br") {
      return true;
    } else {
      return false;
    }
  }
}
