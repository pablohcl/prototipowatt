import 'package:firebase_auth/firebase_auth.dart';
import 'package:prototipo/objects/prod_vlr.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'produto.dart';
import 'cond_pgto.dart';

final String tabelaProduto = "t_produto";
final String tabelaCondicoes = "t_condicoes";
final String tabelaValores = "t_prod_valores";

final String dropTableProdutos = "DROP TABLE $tabelaProduto";
final String dropTableCondicoes = "DROP TABLE $tabelaCondicoes";
final String dropTableValores = "DROP TABLE $tabelaValores";

final String createTableProdutos =
    "CREATE TABLE $tabelaProduto($idColumn INT PRIMARY KEY, $refColumn TEXT, $descColumn TEXT, $undColumn TEXT, $grupoColumn INT)";
final String createTableCondicoes =
    "CREATE TABLE $tabelaCondicoes($idCondColumn INT PRIMARY KEY, $condCondColumn TEXT)";
final String createTableValores =
    "CREATE TABLE $tabelaValores($idVlrColumn INT PRIMARY KEY, $vCompraColumn DECIMAL, $vMinColumn DECIMAL, $vendaColumn DECIMAL, $sugColumn DECIMAL)";

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
        await db.execute(createTableProdutos);
        await db.execute(createTableCondicoes);
        await db.execute(createTableValores);
      },
    );
  }

  Future<void> recreateTable(String table) async {
    Database? dbProd = await db;
    if (table == 'produtos') {
      await dbProd!.execute(dropTableProdutos);
      await dbProd.execute(createTableProdutos);
    } else if (table == 'condicoes') {
      await dbProd!.execute(dropTableCondicoes);
      await dbProd.execute(createTableCondicoes);
    } else if (table == 'valores') {
      await dbProd!.execute(dropTableValores);
      await dbProd.execute(createTableValores);
    }
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
        grupoColumn: int.parse(linha[4].substring(0, linha[4].length - 1)),
      };

      batch.insert(tabelaProduto, map);
    }

    return await batch.commit();
  }

  Future<List<dynamic>> saveValores(List<List<dynamic>> listValores) async {
    Database? dbProd = await db;
    var batch = dbProd!.batch();
    for (int i = 1; i < listValores.length; i++) {
      final linha = listValores[i].toString().split(';');
      final Map<String, dynamic> map = {
        idVlrColumn: int.parse(linha[0].substring(1).trim()),
        vCompraColumn: num.parse(linha[1].replaceAll(',', '.').trim()),
        vMinColumn: num.parse(linha[2].replaceAll(',', '.').trim()),
        vendaColumn: num.parse(linha[3].replaceAll(',', '.').trim()),
        sugColumn: num.parse(linha[4].substring(0, linha[4].length - 1).replaceAll(',', '.').trim()),
      };

      batch.insert(tabelaValores, map);
    }

    return await batch.commit();
  }

  Future<List<dynamic>> saveCondicoes(List<List<dynamic>> listConds) async {
    Database? dbProd = await db;
    var batch = dbProd!.batch();
    for (int i = 1; i < listConds.length; i++) {
      final linha = listConds[i].toString().split(';');
      final Map<String, dynamic> map = {
        idCondColumn: int.parse(linha[0].substring(1)),
        condCondColumn: linha[1].toString(),
      };

      batch.insert(tabelaCondicoes, map);
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
          id: 0, ref: "null", descricao: "null", undMedida: "null", grupo: 0);
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

  Future<List<ProdVlr>> getTodosValores() async {
    Database? dbProd = await db;
    List listMap = await dbProd!.rawQuery("SELECT * FROM $tabelaValores");
    List<ProdVlr> listValores = List.generate(
      listMap.length,
          (index) {
        return ProdVlr.fromMap(listMap[index]);
      },
      growable: true,
    );

    return listValores;
  }

  Future<List<CondPgto>> getTodasCondicoes() async {
    Database? dbProd = await db;
    List listMap = await dbProd!.rawQuery("SELECT * FROM $tabelaCondicoes");
    List<CondPgto> listCond = List.generate(
      listMap.length,
      (index) {
        return CondPgto.fromMap(listMap[index]);
      },
      growable: true,
    );

    return listCond;
  }

  Future<List<Produto>> buscaProdutos(String textoDigitado) async {
    Database? dbProd = await db;
    String queryString = "SELECT * FROM $tabelaProduto WHERE $descColumn LIKE ";
    final splittedText = textoDigitado.split(",");
    for (int i = 0; i < splittedText.length; i++) {
      final String txt = splittedText[i].toString().trim();
      if (i != splittedText.length - 1) {
        queryString = queryString + "'%$txt%' AND $descColumn LIKE ";
      } else {
        queryString = queryString + "'%$txt%'";
      }
    }
    List listMap = await dbProd!.rawQuery(queryString);
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
