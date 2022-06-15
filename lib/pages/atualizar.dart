import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:prototipo/objects/produto.dart';
import 'package:csv/csv.dart';

Future<Produto> fetchDados() async {
  final response = await http.get(Uri.parse(
      'https://pablohenriquecorrea.000webhostapp.com/mobile/t_a_pro.CSV'));

  if (response.statusCode == 200) {
    List<List<dynamic>> rowsAsListOfValues =
        CsvToListConverter().convert(response.body);
    final linha = rowsAsListOfValues[1].toString().split(';');
    Map<String, dynamic> map = {
      'id': linha[0],
      'descricao': linha[1],
      'undMedida': linha[2],
      'grupo': linha[3],
    };



    return Produto.fromTxt(map);
  } else {
    throw Exception('Falha ao carregar dados');
  }
}

class Atualizar extends StatefulWidget {
  const Atualizar({Key? key}) : super(key: key);

  @override
  State<Atualizar> createState() => _AtualizarState();
}

class _AtualizarState extends State<Atualizar> {
  late Future<Produto> futureList;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Atualizando"),
        ),
        body: Center(
          child: FutureBuilder<Produto>(
            future: futureList,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data!.descricao.toString());
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    futureList = fetchDados();
    createDB();
  }

  void createDB() async {
    // Avoid errors caused by flutter upgrade.
    // Importing 'package:flutter/widgets.dart' is required.
    WidgetsFlutterBinding.ensureInitialized();
    // Open the database and store the reference.
    final database = openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'watt.db'),
      // When the database is first created, create a table to store dogs.
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          'CREATE TABLE dogs(id INTEGER PRIMARY KEY, name TEXT, age INTEGER)',
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );

    Future<void> insertProduto(Produto prod) async {
      // Pegar referência do banco de dados
      final db = await database;

      // Insert the Dog into the correct table. You might also specify the
      // `conflictAlgorithm` to use in case the same dog is inserted twice.
      //
      // In this case, replace any previous data.
      await db.insert('watt', prod.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }
}
