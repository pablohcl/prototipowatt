import 'package:flutter/material.dart';

class NovoCliente extends StatefulWidget {
  NovoCliente({Key? key}) : super(key: key);

  @override
  State<NovoCliente> createState() => _NovoClienteState();
}

class _NovoClienteState extends State<NovoCliente> {
  String? tipoCadastro = '';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Novo Cliente'),
        ),
        body: Column(
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
                    if(tipoCadastro == ''){
                      tipoCadastro = 'juridica';
                      setState(() {
                        montaTela();
                      });
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
              TextFormField(
                validator: (value) {},
                decoration: InputDecoration(
                  labelText: 'CPF',
                  labelStyle: TextStyle(color: Colors.green),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
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
              TextFormField(
                validator: (value) {},
                decoration: InputDecoration(
                  labelText: 'CNPJ',
                  labelStyle: TextStyle(color: Colors.green),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
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
        title: Text('Atenção!', style: TextStyle(color: Colors.red),),
        content: Text(
            'Tem certeza que deseja trocar o tipo de cliente? TODOS OS DADOS DIGITADOS SERÃO PERDIDOS!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancelar', style: TextStyle(color: Colors.black),),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              tipoCadastro = texto;
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
}