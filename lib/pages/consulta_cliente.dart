import 'package:flutter/material.dart';
import 'package:prototipo/pages/view_cliente.dart';
import 'package:prototipo/pages/view_produto.dart';

import '../objects/cliente.dart';
import '../objects/db_helper.dart';
import '../objects/produto.dart';
import 'novo_cliente.dart';

class ConsultaCliente extends StatefulWidget {
  const ConsultaCliente({Key? key}) : super(key: key);

  @override
  State<ConsultaCliente> createState() => _ConsultaClienteState();
}

class _ConsultaClienteState extends State<ConsultaCliente> {
  DbHelper helper = DbHelper();
  late Future<List<Cliente>> futureClientes;
  late List<Cliente>? clientes;
  TextEditingController buscaController = TextEditingController();

  @override
  void initState() {
    super.initState();

    futureClientes = helper.getTodosClientes();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Consultar clientes"),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NovoCliente()));
              },
              icon: Icon(
                Icons.add,
                color: Colors.white,
              ),
            )
          ],
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
                    onSubmitted: (txt) {
                      futureClientes = helper.buscaClientes(txt);
                      setState(() {
                        preencheListView();
                      });
                    },
                    onChanged: (String txt) {
                      futureClientes = helper.buscaClientes(txt);
                      setState(() {
                        preencheListView();
                      });
                    },
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
                      futureClientes =
                          helper.buscaClientes(buscaController.text);
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

  FutureBuilder<List<Cliente>> preencheListView() {
    return FutureBuilder<List<Cliente>>(
      future: futureClientes,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          clientes = snapshot.data;
          return Expanded(
            child: ListView.builder(
              itemCount: clientes!.length,
              itemBuilder: (context, index) {
                return _clienteCard(context, clientes![index]);
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

  Widget _clienteCard(BuildContext context, Cliente cli) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, ViewCliente.routeName, arguments: cli);
      },
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cli.fantasia.toString(),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Text(
                    cli.razao.toString(),
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
