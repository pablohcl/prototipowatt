import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:prototipo/objects/produto.dart';
import 'package:prototipo/objects/db_helper.dart';
import 'package:csv/csv.dart';



class Atualizar extends StatefulWidget {
  const Atualizar({Key? key}) : super(key: key);

  @override
  State<Atualizar> createState() => _AtualizarState();
}

class _AtualizarState extends State<Atualizar> {

  late Future<List<dynamic>> futureProdList;
  DbHelper helper = DbHelper();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Atualizando"),
        ),
        body: Center(
          child: FutureBuilder<List<dynamic>>(
            future: futureProdList,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data!.length.toString() + " Produtos atualizados!");
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
    futureProdList = fetchProdutos();
  }

  Future<List<dynamic>> fetchProdutos() async {
    final response = await http.get(Uri.parse(
        'https://pablohenriquecorrea.000webhostapp.com/mobile/t_a_pro.CSV'));

    if (response.statusCode == 200) {
      final List<List<dynamic>> rowsAsListOfValues = CsvToListConverter().convert(response.body);

      await helper.saveProdutos(rowsAsListOfValues);
      Future<List> l = helper.getTodosProdutos();
      l.then((value) => print(value.length));

      return rowsAsListOfValues;
    } else {
      throw Exception('Falha ao carregar dados');
    }
  }
}
