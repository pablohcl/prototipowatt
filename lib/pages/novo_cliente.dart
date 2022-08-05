import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:prototipo/objects/cliente.dart';
import 'package:prototipo/objects/db_helper.dart';

import '../objects/cliente_novo.dart';

Future<Cliente> fetchDados(String cnpj) async {
  final response =
      await http.get(Uri.parse('https://receitaws.com.br/v1/cnpj/$cnpj'));

  if (response.statusCode == 200) {
    return Cliente.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Falha ao carregar dados');
  }
}

class NovoCliente extends StatefulWidget {
  NovoCliente({Key? key}) : super(key: key);

  @override
  State<NovoCliente> createState() => _NovoClienteState();
}

class _NovoClienteState extends State<NovoCliente> {
  String? tipoCadastro = '';

  DbHelper helper = DbHelper();

  late TextEditingController cnpjController = TextEditingController();
  late TextEditingController razaoController = TextEditingController();
  late TextEditingController fantasiaController = TextEditingController();
  late TextEditingController cepController = TextEditingController();
  late TextEditingController bairroController = TextEditingController();
  late TextEditingController ruaController = TextEditingController();
  late TextEditingController numeroController = TextEditingController();
  late TextEditingController municipioController = TextEditingController();
  late TextEditingController ufController = TextEditingController();
  late TextEditingController dddController = TextEditingController();
  late TextEditingController fone1Controller = TextEditingController();
  late TextEditingController emailController = TextEditingController();

  late Future<Cliente> futureCli;

  late int idNovoCliente;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Novo Cliente'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (tipoCadastro == '') {
                        tipoCadastro = 'fisica';
                        setState(() {
                          montaTela();
                        });
                      } else if (tipoCadastro == 'fisica') {
                        return;
                      } else {
                        mostrarConfirmacaoDeTroca('fisica');
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: isCpf()
                          ? MaterialStateProperty.all(Colors.green)
                          : MaterialStateProperty.all(
                              Colors.black.withOpacity(0.2)),
                      elevation: isCpf()
                          ? MaterialStateProperty.all(2)
                          : MaterialStateProperty.all(0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            'CPF',
                            style: TextStyle(
                              fontSize: 26,
                            ),
                          ),
                          Text('Pessoa Física'),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (tipoCadastro == '') {
                        tipoCadastro = 'juridica';
                        setState(() {
                          montaTela();
                        });
                      } else if (tipoCadastro == 'juridica') {
                        return;
                      } else {
                        mostrarConfirmacaoDeTroca('juridica');
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: isCnpj()
                          ? MaterialStateProperty.all(Colors.green)
                          : MaterialStateProperty.all(
                              Colors.black.withOpacity(0.2)),
                      elevation: isCnpj()
                          ? MaterialStateProperty.all(2)
                          : MaterialStateProperty.all(0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            'CNPJ',
                            style: TextStyle(
                              fontSize: 26,
                            ),
                          ),
                          Text('Pessoa Jurídica'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              montaTela(),
            ],
          ),
        ),
      ),
    );
  }

  Widget montaTela() {
    if (tipoCadastro == '') {
      return Form(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Selecione o tipo',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );
    } else if (tipoCadastro == 'fisica') {
      return FutureBuilder(
        future: helper.getLastId(tabelaClienteNovo, idCliColumn),
        builder: (context, snapshot) {
          if(snapshot.hasError){
            return Text('${snapshot.error}');
          } else if(snapshot.hasData){
            idNovoCliente = int.parse(snapshot.data.toString());
            return Form(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Icon(
                      Icons.person_add,
                      size: 88,
                      color: Colors.green,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Column(
                      children: [
                        SizedBox(
                          height: 8,
                        ),
                        TextFormField(
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(11),
                          ],
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            return value!.length != 11 ? 'CPF inválido!' : null;
                          },
                          controller: cnpjController,
                          decoration: InputDecoration(
                            labelText: 'CPF',
                            labelStyle: TextStyle(color: Colors.green),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: razaoController,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            label: Text('Nome'),
                            labelStyle: TextStyle(color: Colors.green),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: fantasiaController,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            label: Text('Apelido / Nome Fantasia'),
                            labelStyle: TextStyle(color: Colors.green),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: TextFormField(
                                controller: cepController,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(8),
                                ],
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  label: Text('CEP'),
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
                              flex: 6,
                              child: TextFormField(
                                controller: bairroController,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  label: Text('Bairro'),
                                  labelStyle: TextStyle(color: Colors.green),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 8,
                              child: TextFormField(
                                controller: ruaController,
                                keyboardType: TextInputType.streetAddress,
                                decoration: InputDecoration(
                                  label: Text('Rua'),
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
                              flex: 2,
                              child: TextFormField(
                                controller: numeroController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  label: Text('Nº'),
                                  labelStyle: TextStyle(color: Colors.green),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 8,
                              child: TextFormField(
                                controller: municipioController,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  label: Text('Município'),
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
                              flex: 2,
                              child: TextFormField(
                                controller: ufController,
                                keyboardType: TextInputType.text,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(2),
                                ],
                                decoration: InputDecoration(
                                  label: Text('UF'),
                                  labelStyle: TextStyle(color: Colors.green),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: TextFormField(
                                controller: dddController,
                                keyboardType: TextInputType.text,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(2),
                                ],
                                decoration: InputDecoration(
                                  label: Text('DDD'),
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
                              flex: 8,
                              child: TextFormField(
                                controller: fone1Controller,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  label: Text('Telefone 1'),
                                  labelStyle: TextStyle(color: Colors.green),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            label: Text('E-mail'),
                            labelStyle: TextStyle(color: Colors.green),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  // Fazer o insert no banco
                                  print(idNovoCliente+1);
                                  print('ID DO CLIENTE CADASTRADO');
                                  final Map<String, dynamic> map = {
                                    // CRIAR TABELA t_cliente_novo
                                    idCliColumn: idNovoCliente+1,
                                    cliDocColumn: cnpjController.text,
                                    cliRazaoColumn: razaoController.text,
                                    cliFantasiaColumn: fantasiaController.text,
                                    cliCepColumn: cepController.text,
                                    cliRuaColumn: ruaController.text,
                                    cliNumColumn: numeroController.text,
                                    cliBairroColumn: bairroController.text,
                                    cliCidadeColumn: municipioController.text,
                                    cliUfColumn: ufController.text,
                                    cliDDDColumn: dddController.text,
                                    cliFone1Column: fone1Controller.text,
                                    cliPjColumn: 'FALSO',
                                    cliEmailColumn: emailController.text,
                                  };
                                  helper.saveClienteNovo(map);
                                  //print(map);
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text(
                                        'Cliente cadastrado com Sucesso!',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            tipoCadastro = 'fisica';
                                            cnpjController.text = '';
                                            razaoController.text = '';
                                            fantasiaController.text = '';
                                            cepController.text = '';
                                            bairroController.text = '';
                                            ruaController.text = '';
                                            numeroController.text = '';
                                            municipioController.text = '';
                                            ufController.text = '';
                                            dddController.text = '';
                                            fone1Controller.text = '';
                                            emailController.text = '';
                                            setState(() {
                                              montaTela();
                                            });
                                          },
                                          child: Text(
                                            'OK',
                                            style: TextStyle(color: Colors.black),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                                  child: Text(
                                    'Salvar',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                    /*TextFormField(
                    keyboardType: TextInputType.number,
                    controller: cpfController,
                    validator: (value) {},
                    decoration: InputDecoration(
                      labelText: 'CPF',
                      labelStyle: TextStyle(color: Colors.green),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),*/
                  ],
                ),
              ),
            );
          }
          return Center(child: const CircularProgressIndicator());
        }
      );
    } else if (tipoCadastro == 'juridica') {
      return Form(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                Icons.add_business,
                size: 88,
                color: Colors.green,
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 7,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: cnpjController,
                      validator: (value) {},
                      decoration: InputDecoration(
                        labelText: 'CNPJ',
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
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(vertical: 18))),
                      child: Text(
                        'Buscar',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          montaTela();
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              montaRestoTela(cnpjController.text),
            ],
          ),
        ),
      );
    } else {
      return Text('Nenhum tipo selecionado!');
    }
  }

  bool isCpf() {
    if (tipoCadastro == 'fisica') {
      return true;
    } else if (tipoCadastro == '') {
      return true;
    } else {
      return false;
    }
  }

  bool isCnpj() {
    if (tipoCadastro == 'juridica') {
      return true;
    } else if (tipoCadastro == '') {
      return true;
    } else {
      return false;
    }
  }

  void mostrarConfirmacaoDeTroca(String texto) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Deseja trocar o tipo de cliente?',
          style: TextStyle(color: Colors.black),
        ),
        content: Text('TODOS OS DADOS DIGITADOS SERÃO PERDIDOS!',
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'Cancelar',
              style: TextStyle(color: Colors.black),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              tipoCadastro = texto;
              cnpjController.text = '';
              razaoController.text = '';
              fantasiaController.text = '';
              cepController.text = '';
              bairroController.text = '';
              ruaController.text = '';
              numeroController.text = '';
              municipioController.text = '';
              ufController.text = '';
              dddController.text = '';
              fone1Controller.text = '';
              emailController.text = '';
              setState(() {
                montaTela();
              });
            },
            child: Text(
              'Sim',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Widget montaRestoTela(String cnpj) {
    if (cnpj.isEmpty) {
      return Text('');
    } else {
      return FutureBuilder<Cliente>(
        future: fetchDados(cnpj),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                SizedBox(
                  height: 8,
                ),
                TextFormField(
                  initialValue: snapshot.data!.razao,
                  enabled: false,
                  decoration: InputDecoration(
                    label: Text('Razão Social'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  initialValue: snapshot.data!.fantasia,
                  decoration: InputDecoration(
                    label: Text('Fantasia'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        initialValue: snapshot.data!.cep,
                        enabled: false,
                        decoration: InputDecoration(
                          label: Text('CEP'),
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
                      flex: 6,
                      child: TextFormField(
                        initialValue: snapshot.data!.bairro,
                        enabled: false,
                        decoration: InputDecoration(
                          label: Text('Bairro'),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 8,
                      child: TextFormField(
                        initialValue: snapshot.data!.rua,
                        enabled: false,
                        decoration: InputDecoration(
                          label: Text('Rua'),
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
                      flex: 2,
                      child: TextFormField(
                        initialValue: snapshot.data!.numero,
                        enabled: false,
                        decoration: InputDecoration(
                          label: Text('Nº'),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 8,
                      child: TextFormField(
                        initialValue: snapshot.data!.cidade,
                        enabled: false,
                        decoration: InputDecoration(
                          label: Text('Município'),
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
                      flex: 2,
                      child: TextFormField(
                        initialValue: snapshot.data!.uf,
                        enabled: false,
                        decoration: InputDecoration(
                          label: Text('UF'),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        initialValue: snapshot.data!.ddd,
                        decoration: InputDecoration(
                          label: Text('DDD'),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 8,
                      child: TextFormField(
                        initialValue: snapshot.data!.fone1,
                        decoration: InputDecoration(
                          label: Text('Telefone 1'),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                TextFormField(
                  initialValue: snapshot.data!.email,
                  decoration: InputDecoration(
                    label: Text('E-mail'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Text(
                            'Salvar',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return const CircularProgressIndicator();
        },
      );
    }
  }
}
