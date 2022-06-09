import 'package:flutter/material.dart';

class ConsultaPreco extends StatelessWidget {
  const ConsultaPreco({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 30),
      color: Colors.blue,
      child: ElevatedButton(
        child: Column(
          children: [
            Icon(Icons.exit_to_app),
            Text('Voltar'),
          ],
        ),
        onPressed: (){
          Navigator.pop(context);
        },
      ),
    );
  }
}
