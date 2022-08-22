import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:prototipo/objects/cliente.dart';
import 'package:prototipo/objects/db_helper.dart';
import 'package:prototipo/text-formatters/cep_formatter.dart';
import 'package:prototipo/text-formatters/fone_formatter.dart';
import 'package:prototipo/text-formatters/inscr_estadual_formatter.dart';

import '../text-formatters/cpf_text_formatter.dart';
import '../text-formatters/upper_case_text_formatter.dart';

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
  late TextEditingController inscrController = TextEditingController();

  late Future<Cliente> futureCli;

  late int idNovoCliente;

  final _cpfFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _nomeFocus = FocusNode();
  final _apelidoFocus = FocusNode();
  final _cepFocus = FocusNode();
  final _bairroFocus = FocusNode();
  final _ruaFocus = FocusNode();
  final _numFocus = FocusNode();
  final _cidadeFocus = FocusNode();
  final _ufFocus = FocusNode();
  final _dddFocus = FocusNode();
  final _fone1Focus = FocusNode();
  final _inscrFocus = FocusNode();

  final _formKey = GlobalKey<FormState>();

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
      return Padding(
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
      );
    } else if (tipoCadastro == 'fisica') {
      return FutureBuilder(
          future: helper.getLastId(tabelaClienteNovo, idCliColumn),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('${snapshot.error}');
            } else if (snapshot.hasData) {
              idNovoCliente = int.parse(snapshot.data.toString());
              return Form(
                key: _formKey,
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
                              LengthLimitingTextInputFormatter(14),
                              CpfTextFormatter(),
                            ],
                            focusNode: _cpfFocus,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value!.length != 11) {
                                FocusScope.of(context).requestFocus(_cpfFocus);
                                return 'CPF inválido!';
                              } else {
                                return null;
                              }
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
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(11),
                              UpperCaseTextFormatter(),
                              InscrEstadualFormatter(),
                            ],
                            focusNode: _inscrFocus,
                            validator: (value) {
                              if (value!.length != 10 &&
                                  !value.contains('ISENTO')) {
                                FocusScope.of(context).requestFocus(_cpfFocus);
                                return 'Inscrição estadual inválida!';
                              } else {
                                return null;
                              }
                            },
                            controller: inscrController,
                            decoration: InputDecoration(
                              labelText: 'Inscrição estadual',
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
                            validator: (value) {
                              if (value!.isEmpty) {
                                FocusScope.of(context).requestFocus(_nomeFocus);
                                return 'Preencha o nome!';
                              } else {
                                return null;
                              }
                            },
                            focusNode: _nomeFocus,
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
                            validator: (value) {
                              if (value!.isEmpty) {
                                FocusScope.of(context)
                                    .requestFocus(_apelidoFocus);
                                return 'Campo obrigatório!';
                              } else {
                                return null;
                              }
                            },
                            focusNode: _apelidoFocus,
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
                                  focusNode: _cepFocus,
                                  validator: (value) {
                                    if (value!.length != 8) {
                                      FocusScope.of(context)
                                          .requestFocus(_cepFocus);
                                      return 'CEP inválido!';
                                    } else {
                                      return null;
                                    }
                                  },
                                  controller: cepController,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(9),
                                    CepFormatter(),
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
                                  focusNode: _bairroFocus,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      FocusScope.of(context)
                                          .requestFocus(_bairroFocus);
                                      return 'Campo obrigatório!';
                                    } else {
                                      return null;
                                    }
                                  },
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
                                  focusNode: _ruaFocus,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      FocusScope.of(context)
                                          .requestFocus(_ruaFocus);
                                      return 'Campo obrigatório!';
                                    } else {
                                      return null;
                                    }
                                  },
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
                                  focusNode: _numFocus,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      FocusScope.of(context)
                                          .requestFocus(_numFocus);
                                      return 'Campo obrigatório!';
                                    } else {
                                      return null;
                                    }
                                  },
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
                                  focusNode: _cidadeFocus,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      FocusScope.of(context)
                                          .requestFocus(_cidadeFocus);
                                      return 'Campo obrigatório!';
                                    } else {
                                      return null;
                                    }
                                  },
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
                                  focusNode: _ufFocus,
                                  validator: (value) {
                                    if (value!.length != 2) {
                                      FocusScope.of(context)
                                          .requestFocus(_ufFocus);
                                      return 'UF inválida!';
                                    } else {
                                      return null;
                                    }
                                  },
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
                                  focusNode: _dddFocus,
                                  validator: (value) {
                                    if (value!.length != 2) {
                                      FocusScope.of(context)
                                          .requestFocus(_dddFocus);
                                      return 'Campo obrigatório!';
                                    } else {
                                      return null;
                                    }
                                  },
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
                                  inputFormatters: [
                                    FoneFormatter(),
                                    LengthLimitingTextInputFormatter(10),
                                  ],
                                  focusNode: _fone1Focus,
                                  validator: (value) {
                                    if (value!.length < 8) {
                                      FocusScope.of(context)
                                          .requestFocus(_fone1Focus);
                                      return 'Telefone inválido!';
                                    } else {
                                      return null;
                                    }
                                  },
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
                            validator: (value) {
                              if (value!.contains('@')) {
                                return null;
                              } else {
                                FocusScope.of(context)
                                    .requestFocus(_emailFocus);
                                return 'E-mail inválido!';
                              }
                            },
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
                                    if (_formKey.currentState!.validate()) {
                                      final Map<String, dynamic> map = {
                                        // CRIAR TABELA t_cliente_novo
                                        idCliColumn: idNovoCliente + 1,
                                        cliDocColumn: cnpjController.text.replaceAll('.', '').replaceAll('-', ''),
                                        cliInscrColumn: inscrController.text.replaceAll('/', ''),
                                        cliRazaoColumn: razaoController.text,
                                        cliFantasiaColumn:
                                            fantasiaController.text,
                                        cliCepColumn: cepController.text.replaceAll('-', ''),
                                        cliRuaColumn: ruaController.text,
                                        cliNumColumn: numeroController.text,
                                        cliBairroColumn: bairroController.text,
                                        cliCidadeColumn:
                                            municipioController.text,
                                        cliUfColumn: ufController.text,
                                        cliDDDColumn: dddController.text,
                                        cliFone1Column: fone1Controller.text.replaceAll('-', ''),
                                        cliPjColumn: 'FALSO',
                                        cliEmailColumn: emailController.text,
                                      };
                                      helper.saveClienteNovo(map);
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Text(
                                            'Cliente cadastrado com Sucesso!',
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                _formKey.currentState!.reset();
                                                Navigator.of(context).pop();
                                                tipoCadastro = 'fisica';
                                                cnpjController.text = '';
                                                inscrController.text = '';
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
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                    ;
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10.0),
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
          });
    } else if (tipoCadastro == 'juridica') {
      return Form(
        key: _formKey,
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
              inscrController.text = '';
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