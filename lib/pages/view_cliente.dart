import 'package:flutter/material.dart';
import 'package:prototipo/objects/db_helper.dart';
import 'package:prototipo/objects/prod_vlr.dart';

import '../objects/cliente.dart';
import '../objects/produto.dart';

class ViewCliente extends StatefulWidget {
  const ViewCliente({Key? key}) : super(key: key);

  static const routeName = '/viewCliente';

  @override
  State<ViewCliente> createState() => _ViewClienteState();
}

class _ViewClienteState extends State<ViewCliente> {
  late Future<Cliente> futureCliente;
  DbHelper helper = DbHelper();
  Cliente? argsCliente;
  late Cliente? cliente;

  @override
  Widget build(BuildContext context) {
    argsCliente = ModalRoute.of(context)!.settings.arguments as Cliente;
    print(argsCliente);
    futureCliente = pegaCliente();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(argsCliente!.id.toString()),
        ),
        body: Column(
          children: [
            mostraCliente(),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  Future<Cliente> pegaCliente() async {
    return await helper.getCliente(argsCliente!.id);
  }

  FutureBuilder<Cliente> mostraCliente() {
    return FutureBuilder<Cliente>(
      future: futureCliente,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          cliente = snapshot.data;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cliente!.fantasia.toString(),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  cliente!.razao.toString(),
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                Text(
                  cliente!.rua.toString()+', '+cliente!.numero.toString(),
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  cliente!.cidade.toString(),
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  cliente!.ddd.toString()+', '+cliente!.fone1.toString(),
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  cliente!.email.toString().replaceAll(']', ''),
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
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
