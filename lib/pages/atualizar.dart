import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:prototipo/objects/produto.dart';

Future<Produto> fetchDados() async {
  //final response = await http.get(Uri.parse('https://receitaws.com.br/v1/cnpj/$cnpj'));
  // REGISTRAR UM DOMINIO PARA HOSPEDAR OS ARQUIVOS

  if (response.statusCode == 200) {
    return Cliente.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Falha ao carregar dados');
  }
}

class Atualizar extends StatelessWidget {
  const Atualizar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(

      ),
    );
  }
}
