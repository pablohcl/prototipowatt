import 'package:flutter/material.dart';

class NovoCliente extends StatelessWidget {
  const NovoCliente({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Novo Cliente'),
        ),
      ),
    );
  }
}
