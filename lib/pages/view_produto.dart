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
  Produto? argsProduto;
  late Produto? produto;

  @override
  Widget build(BuildContext context) {
    argsProduto = ModalRoute.of(context)!.settings.arguments as Produto;
    print(argsProduto);
    futureProduto = pegaProduto();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text(argsProduto!.id.toString()),),
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
  }

  Future<Produto> pegaProduto() async {
    return await helper.getProduto(argsProduto!.id);
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
                Row(
                  children: [
                    Expanded(
                      flex: 9,
                      child: Text(
                        "Mínimo: R\$ " + produto!.valorMin.toStringAsFixed(2),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.red,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: IconButton(
                        onPressed: () {
                          if(helper.isAdmin()){
                            showDialog(context: context, builder: (context) => AlertDialog(content: Text(produto!.valorCompra.toStringAsFixed(2)),));
                          }
                        },
                        icon: Icon(
                          Icons.lightbulb,
                          color: Colors.yellow,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "Sugerido: R\$ " +
                          produto!.valorSugerido.toStringAsFixed(2),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.yellow,
                      ),
                    ),
                    SizedBox(height: 25,),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "Venda: R\$ " + produto!.valorProd.toStringAsFixed(2),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.green,
                      ),
                    ),
                    SizedBox(height: 30,),
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
}
