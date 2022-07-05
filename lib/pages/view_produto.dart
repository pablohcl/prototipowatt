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

  late Future<Produto> futureProduto;
  DbHelper helper = DbHelper();
  int? argsProduto;
  late Produto? produto;
  String appBarTitle = "Carregando...";

  @override
  Widget build(BuildContext context) {
    argsProduto = ModalRoute
        .of(context)!
        .settings
        .arguments as int;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            mostraProduto(),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    futureProduto = pegaProduto();
  }

  Future<Produto> pegaProduto() async {
    return await helper.getProduto(argsProduto!);
  }

  FutureBuilder<Produto> mostraProduto() {
    return FutureBuilder<Produto>(
      future: futureProduto,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          produto = snapshot.data;
          setState(() {
            appBarTitle = produto!.descricao;
          });
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(produto!.id.toString()),
                      flex: 2,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Text(produto!.descricao),
                    ),
                  ],
                ),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        // By default, show a loading spinner.
        return const Center(child: CircularProgressIndicator(),);
      },
    );
  }
}