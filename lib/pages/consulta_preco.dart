import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../objects/db_helper.dart';

class ConsultaPreco extends StatefulWidget {
  const ConsultaPreco({Key? key}) : super(key: key);

  @override
  State<ConsultaPreco> createState() => _ConsultaPrecoState();
}

class _ConsultaPrecoState extends State<ConsultaPreco> {
  DbHelper helper = DbHelper();

  @override
  void initState() {
    super.initState();
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
                    onPressed: () {},
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
          ],
        ),
      ),
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
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/icon/boxes.png"),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Column(
                  children: [
                    // Desenvolver o Future para ter a lista cm os produtos
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
