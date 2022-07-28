import 'package:flutter/material.dart';
import 'package:prototipo/objects/db_helper.dart';
import 'package:prototipo/objects/prod_vlr.dart';

import '../objects/produto.dart';

class ViewProduto extends StatefulWidget {
  const ViewProduto({Key? key}) : super(key: key);

  static const routeName = '/viewProduto';

  @override
  State<ViewProduto> createState() => _ViewProdutoState();
}

class _ViewProdutoState extends State<ViewProduto> {
  late Future<Produto> futureProduto;
  late Future<ProdVlr> futureValor;
  DbHelper helper = DbHelper();
  Produto? argsProduto;
  late Produto? produto;
  late ProdVlr? valor;

  @override
  Widget build(BuildContext context) {
    argsProduto = ModalRoute.of(context)!.settings.arguments as Produto;
    print(argsProduto);
    futureProduto = pegaProduto();
    futureValor = pegaValor();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(argsProduto!.id.toString()),
          actions: [
            myIconButton(),
          ],
        ),
        body: Column(
          children: [
            mostraProduto(),
            mostraValores(),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  Future<Produto> pegaProduto() async {
    return await helper.getProduto(argsProduto!.id);
  }

  Future<ProdVlr> pegaValor() async {
    return await helper.getValor(argsProduto!.id);
  }

  FutureBuilder<Produto> mostraProduto() {
    return FutureBuilder<Produto>(
      future: futureProduto,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          produto = snapshot.data;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        produto!.descricao,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        // By default, show a loading spinner.
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  FutureBuilder<ProdVlr> mostraValores() {
    return FutureBuilder<ProdVlr>(
      future: futureValor,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          valor = snapshot.data;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        "Mínimo: R\$ " + valor!.vlrMinimo.toStringAsFixed(2),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        "Sugerido: R\$ " +
                            valor!.vlrSugerido.toStringAsFixed(2),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        "Venda: R\$ " + valor!.vlrVenda.toStringAsFixed(2),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
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
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget myIconButton() {
    if (helper.isAdmin()) {
      return IconButton(
        onPressed: () {
          if (helper.isAdmin()) {
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      content: Text(valor!.vlrCompra.toStringAsFixed(2)),
                    ));
          }
        },
        icon: Icon(
          Icons.lightbulb,
          color: Colors.yellow,
        ),
      );
    } else {
      return SizedBox();
    }
  }
}
