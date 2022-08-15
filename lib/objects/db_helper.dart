import 'package:firebase_auth/firebase_auth.dart';
import 'package:prototipo/objects/cliente.dart';
import 'package:prototipo/objects/prod_vlr.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'cliente_novo.dart';
import 'produto.dart';
import 'cond_pgto.dart';

final String tabelaProduto = "t_produto";
final String tabelaCondicoes = "t_condicoes";
final String tabelaValores = "t_prod_valores";
final String tabelaClientes = "t_clientes";
final String tabelaClienteNovo = "t_cliente_novo";

final String dropTableProdutos = "DROP TABLE IF EXISTS $tabelaProduto";
final String dropTableCondicoes = "DROP TABLE IF EXISTS $tabelaCondicoes";
final String dropTableValores = "DROP TABLE IF EXISTS $tabelaValores";
final String dropTableClientes = "DROP TABLE IF EXISTS $tabelaClientes";
final String dropTableClienteNovo = "DROP TABLE IF EXISTS $tabelaClienteNovo";

final String createTableProdutos =
    "CREATE TABLE $tabelaProduto($idColumn INT PRIMARY KEY, $refColumn TEXT, $descColumn TEXT, $undColumn TEXT, $grupoColumn INT)";
final String createTableCondicoes =
    "CREATE TABLE $tabelaCondicoes($idCondColumn INT PRIMARY KEY, $condCondColumn TEXT)";
final String createTableValores =
    "CREATE TABLE $tabelaValores($idVlrColumn INT PRIMARY KEY, $vCompraColumn DECIMAL, $vMinColumn DECIMAL, $vendaColumn DECIMAL, $sugColumn DECIMAL)";
final String createTableClientes =
    "CREATE TABLE $tabelaClientes($idCliColumn INT PRIMARY KEY, $cliRazaoColumn TEXT, $cliFantasiaColumn TEXT, $cliDocColumn TEXT, $cliInscrColumn TEXT, $cliCepColumn TEXT, $cliRuaColumn TEXT, $cliNumColumn TEXT, $cliBairroColumn TEXT, $cliCidadeColumn TEXT, $cliUfColumn TEXT, $cliDDDColumn TEXT, $cliFone1Column TEXT, $cliPjColumn TEXT, $cliEmailColumn TEXT)";
final String createTableClienteNovo =
    "CREATE TABLE $tabelaClienteNovo($idCliColumn INT PRIMARY KEY, $cliRazaoColumn TEXT, $cliFantasiaColumn TEXT, $cliDocColumn TEXT, $cliInscrColumn TEXT, $cliCepColumn TEXT, $cliRuaColumn TEXT, $cliNumColumn TEXT, $cliBairroColumn TEXT, $cliCidadeColumn TEXT, $cliUfColumn TEXT, $cliDDDColumn TEXT, $cliFone1Column TEXT, $cliPjColumn TEXT, $cliEmailColumn TEXT)";

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
        await db.execute(createTableClientes);
        await db.execute(createTableClienteNovo);
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
    } else if (table == 'clientes') {
      await dbProd!.execute(dropTableClientes);
      await dbProd.execute(createTableClientes);
    } else if (table == 'cliente-novo') {
      await dbProd!.execute(dropTableClienteNovo);
      await dbProd.execute(createTableClienteNovo);
    }
  }

  Future<int> getLastId(String table, String coluna) async {
    Database? dbProd = await db;
    List<Map> maps = await dbProd!
        .rawQuery("SELECT * FROM $table ORDER BY $coluna DESC");

    if (maps.isNotEmpty) {
      print(maps.toString());
      return maps.first[idCliColumn];
    } else {
      return 0;
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

  Future<List<dynamic>> saveClientes(List<List<dynamic>> listCli) async {
    Database? dbProd = await db;
    var batch = dbProd!.batch();
    for (int i = 1; i < listCli.length; i++) {
      final linha = listCli[i].toString().split(';');
      final Map<String, dynamic> map = {
        idCliColumn: linha[0].substring(1),
        cliRazaoColumn: linha[1],
        cliFantasiaColumn: linha[2],
        cliDocColumn: linha[3],
        cliInscrColumn: linha [4],
        cliCepColumn: linha[5],
        cliRuaColumn: linha[6],
        cliNumColumn: linha[7],
        cliBairroColumn: linha[8],
        cliCidadeColumn: linha[9],
        cliUfColumn: linha[10],
        cliDDDColumn: linha[11],
        cliFone1Column: linha[12],
        cliPjColumn: linha[13],
        cliEmailColumn: linha[14],
      };

      batch.insert(tabelaClientes, map);
    }

    return await batch.commit();
  }

  Future<void> saveClienteNovo(Map<String, dynamic> novoCli) async {
    Database? dbProd = await db;

    dbProd!.insert(tabelaClienteNovo, novoCli);
  }

  Future<List<dynamic>> saveValores(List<List<dynamic>> listValores) async {
    Database? dbProd = await db;
    var batch = dbProd!.batch();
    for (int i = 1; i < listValores.length; i++) {
      final linha = listValores[i].toString().split(';');
      final Map<String, dynamic> map = {
        idVlrColumn: linha[0].substring(1).trim(),
        vCompraColumn: linha[1].replaceAll(',', '.').replaceAll(' ', ''),
        vMinColumn: linha[2].replaceAll(',', '.').replaceAll(' ', ''),
        vendaColumn: linha[3].replaceAll(',', '.').replaceAll(' ', ''),
        sugColumn: linha[4].substring(0, linha[4].length - 1).replaceAll(',', '.').replaceAll(' ', ''),
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

  Future<Cliente> getCliente(int id) async {
    Database? dbProd = await db;

    List<Map> maps = await dbProd!
        .rawQuery("SELECT * FROM $tabelaClientes WHERE $idCliColumn = $id");

    if (maps.isNotEmpty) {
      print(maps.toString());
      return Cliente.fromMap(maps.first);
    } else {
      return new Cliente(
          id: 0, documento: 'null', razao: "null", fantasia: "null", inscrEstadual: 'null', cep: "null", rua: 'null', numero: 'null', bairro: 'null', cidade: 'null', uf: 'null', email: 'null', fone1: 'null', ddd: 'null', pj: 'null');
    }
  }

  Future<ProdVlr> getValor(int id) async {
    Database? dbProd = await db;
    /*List<Map> maps = await dbProd!.query(
      tabelaProduto,
      columns: [idColumn, descColumn, undColumn, grupoColumn, vCompraColumn, vMinColumn, vProdColumn, vSugColumn],
      where: "$idColumn = ?",
      whereArgs: [id],
    );*/

    List<Map> maps = await dbProd!
        .rawQuery("SELECT * FROM $tabelaValores WHERE $idVlrColumn = $id");

    if (maps.isNotEmpty) {
      print(maps.toString());
      return ProdVlr.fromMap(maps.first);
    } else {
      return new ProdVlr(
          id: 0, vlrCompra: 0.00, vlrMinimo: 0.00, vlrVenda: 0.00, vlrSugerido: 0.00);
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

  Future<List<Cliente>> getTodosClientes() async {
    Database? dbProd = await db;
    List listMap = await dbProd!.rawQuery("SELECT * FROM $tabelaClientes");
    List<Cliente> listCli = List.generate(
      listMap.length,
          (index) {
        return Cliente.fromMap(listMap[index]);
      },
      growable: true,
    );

    return listCli;
  }

  Future<List<ClienteNovo>> getTodosClientesNovos() async {
    Database? dbProd = await db;
    List listMap = await dbProd!.rawQuery("SELECT * FROM $tabelaClienteNovo");
    List<ClienteNovo> listCli = List.generate(
      listMap.length,
          (index) {
        return ClienteNovo.fromMap(listMap[index]);
      },
      growable: true,
    );

    return listCli;
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

  Future<List<Cliente>> buscaClientes(String textoDigitado) async {
    Database? dbProd = await db;
    String queryString = "SELECT * FROM $tabelaClientes WHERE $cliRazaoColumn LIKE ";
    final splittedText = textoDigitado.split(",");
    for (int i = 0; i < splittedText.length; i++) {
      final String txt = splittedText[i].toString().trim();
      if (i != splittedText.length - 1) {
        queryString = queryString + "'%$txt%' AND $cliRazaoColumn LIKE ";
      } else {
        queryString = queryString + "'%$txt%'";
      }
    }
    List listMap = await dbProd!.rawQuery(queryString);
    return List.generate(
      listMap.length,
          (index) {
        return Cliente.fromMap(listMap[index]);
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
