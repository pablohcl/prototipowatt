import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:prototipo/objects/produto.dart';
import 'package:csv/csv.dart';

Future<List<dynamic>> fetchDados() async {
  final response = await http.get(Uri.parse('https://pablohenriquecorrea.000webhostapp.com/mobile/t_a_pro.CSV'));

  if (response.statusCode == 200) {

    List<List<dynamic>> rowsAsListOfValues = CsvToListConverter().convert(response.body);

    return rowsAsListOfValues;
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

  late Future<List<dynamic>> futureList;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Atualizando"),
        ),
        body: Center(
          child: FutureBuilder<List<dynamic>>(
            future: futureList,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data!.toString());
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
  }
}
