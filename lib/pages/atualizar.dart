import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:prototipo/objects/cond_pgto.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:prototipo/objects/prod_vlr.dart';
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
  late Future<List<dynamic>> futureCondList;
  late Future<List<dynamic>> futureProdVlrList;
  late List? produtos;
  late List? condicoes;
  late List? valores;

  DbHelper helper = DbHelper();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Atualizando"),
        ),
        body: Column(
          children: [
            Center(
              child: FutureBuilder<List<dynamic>>(
                future: futureProdList,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    //return Text(snapshot.data!.length.toString() + " Produtos atualizados!");
                    produtos = snapshot.data;
                    return Text(produtos!.length.toString()+" Registros atualizados");
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }

                  // By default, show a loading spinner.
                  return Center(child: const CircularProgressIndicator());
                },
              ),
            ),
            FutureBuilder<List<dynamic>>(
              future: futureCondList,
              builder: (context, snapshot){
                if(snapshot.hasError){
                  return Text('${snapshot.error}');
                } else if(snapshot.hasData){
                  condicoes = snapshot.data;
                  return Text(condicoes!.length.toString()+' Registros atualizados');
                }

                return Center(child: const CircularProgressIndicator());
              },
            ),
            FutureBuilder<List<dynamic>>(
              future: futureProdVlrList,
              builder: (context, snapshot){
                if(snapshot.hasError){
                  return Text('${snapshot.error}');
                } else if(snapshot.hasData){
                  valores = snapshot.data;
                  return Text(valores!.length.toString()+' Registros atualizados');
                }

                return Center(child: const CircularProgressIndicator());
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    futureProdList = fetchProdutos();
    futureCondList = fetchCondicoes();
    futureProdVlrList = fetchValores();
  }

  Future<List<dynamic>> fetchProdutos() async {
    final response = await http.get(Uri.parse(
        'https://pablohenriquecorrea.000webhostapp.com/mobile/t_a_pro.CSV'));

    if (response.statusCode == 200) {
      final List<List<dynamic>> rowsAsListOfValues = CsvToListConverter().convert(response.body);

      await helper.recreateTable('produtos');
      await helper.saveProdutos(rowsAsListOfValues);
      Future<List<Produto>> l = helper.getTodosProdutos();
      l.then((value) => print(value.length));

      return rowsAsListOfValues;
    } else {
      throw Exception('Falha ao carregar dados');
    }
  }

  Future<List<dynamic>> fetchValores() async {
    final response = await http.get(Uri.parse(
        'https://pablohenriquecorrea.000webhostapp.com/mobile/t_a_pro_vlr.CSV'));

    if (response.statusCode == 200) {
      final List<List<dynamic>> rowsAsListOfValues = CsvToListConverter().convert(response.body);

      await helper.recreateTable('valores');
      await helper.saveValores(rowsAsListOfValues);
      Future<List<ProdVlr>> l = helper.getTodosValores();
      l.then((value) => print(value.length));

      return rowsAsListOfValues;
    } else {
      throw Exception('Falha ao carregar dados');
    }
  }

  Future<List<dynamic>> fetchCondicoes() async {
    final response = await http.get(Uri.parse(
        'https://pablohenriquecorrea.000webhostapp.com/mobile/t_a_cond.CSV'));

    if (response.statusCode == 200) {
      final List<List<dynamic>> rowsAsListOfValues = CsvToListConverter().convert(response.body);

      await helper.recreateTable('condicoes');
      await helper.saveCondicoes(rowsAsListOfValues);
      Future<List<CondPgto>> l = helper.getTodasCondicoes();
      l.then((value) => print(value.length));

      return rowsAsListOfValues;
    } else {
      throw Exception('Falha ao carregar dados');
    }
  }
}
