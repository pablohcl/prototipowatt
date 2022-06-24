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

  late Future<Produto> futureList;
  DbHelper helper = DbHelper();

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
                return Text(snapshot.data!.grupo.toString());
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
    helper.getTodosProdutos().then((list) => print(list));
  }

  Future<Produto> fetchDados() async {
    final response = await http.get(Uri.parse(
        'https://pablohenriquecorrea.000webhostapp.com/mobile/t_a_pro.CSV'));

    if (response.statusCode == 200) {
      List<List<dynamic>> rowsAsListOfValues =
      CsvToListConverter().convert(response.body);
      final linha = rowsAsListOfValues[1].toString().split(';');
      Map<String, dynamic> map = {
        'id' : int.parse(linha[0].substring(1)),
        'descricao': linha[1],
        'undMedida': linha[2],
        'grupo': int.parse(linha[3].substring(0, linha[3].length -1)),
      };

      final pro = Produto.fromTxt(map);
      //helper.saveProduto(pro);

      return Produto.fromTxt(map);
    } else {
      throw Exception('Falha ao carregar dados');
    }
  }
}
