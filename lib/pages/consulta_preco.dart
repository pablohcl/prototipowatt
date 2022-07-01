import 'package:flutter/material.dart';

import '../objects/db_helper.dart';
import '../objects/produto.dart';

class ConsultaPreco extends StatefulWidget {
  const ConsultaPreco({Key? key}) : super(key: key);

  @override
  State<ConsultaPreco> createState() => _ConsultaPrecoState();
}

class _ConsultaPrecoState extends State<ConsultaPreco> {
  DbHelper helper = DbHelper();
  late Future<List<Produto>> futureProdutos;
  late List<Produto>? produtos;
  TextEditingController buscaController = TextEditingController();

  @override
  void initState() {
    super.initState();

    futureProdutos = helper.getTodosProdutos();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Consultar preços"),
        ),
        body: Column(
          children: [
            SizedBox(
              height: 12,
            ),
            Row(
              children: [
                SizedBox(
                  width: 8,
                ),
                Expanded(
                  flex: 7,
                  child: TextField(
                    controller: buscaController,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(color: Colors.green),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                  flex: 3,
                  child: ElevatedButton(
                    child: Text(
                      "BUSCAR",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    onPressed: () {
                      print("INICIO DO onPressed() ####################");
                      print(buscaController.text);
                      futureProdutos = helper.buscaProdutos(buscaController.text);
                      setState(() {
                        preencheListView();
                      });
                    },
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                            EdgeInsets.symmetric(vertical: 18))),
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            // IMPLEMENTAR ListView.builder() ##########
            preencheListView(),
          ],
        ),
      ),
    );
  }

  FutureBuilder<List<Produto>> preencheListView() {
    return FutureBuilder<List<Produto>>(
      future: futureProdutos,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          produtos = snapshot.data;
          return Expanded(
            child: ListView.builder(
              itemCount: produtos!.length,
              itemBuilder: (context, index) {
                return _produtoCard(context, index);
              },
            ),
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        // By default, show a loading spinner.
        return const CircularProgressIndicator();
      },
    );
  }

  Widget _produtoCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/icon/boxes.png"),
                  ),
                ),
              ),
              SizedBox(width: 10,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      produtos![index].descricao,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    Text(
                      produtos![index].id.toString(),
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
