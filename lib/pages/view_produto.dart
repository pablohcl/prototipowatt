import 'package:flutter/material.dart';
import 'package:prototipo/objects/db_helper.dart';

import '../objects/produto.dart';

class ViewProduto extends StatefulWidget {
  const ViewProduto({Key? key}) : super(key: key);

  static const routeName = '/viewProduto';

  @override
  State<ViewProduto> createState() => _ViewProdutoState();
}

class _ViewProdutoState extends State<ViewProduto> {

  late Produto produto;
  DbHelper helper = DbHelper();

  @override
  Widget build(BuildContext context) {
    final argsProduto = ModalRoute.of(context)!.settings.arguments as int;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("DESCRIÇÃO DO PRODUTO"),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  // DESENVOLVER FUNCAO PARA PEGAR O PRODUTO E EXIBIR
}
