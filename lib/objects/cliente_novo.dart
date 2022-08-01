import 'package:prototipo/objects/cliente.dart';

class ClienteNovo {
  final int novoId;
  final String novoDocumento;
  final String novoRazao;
  final String novoFantasia;
  final String novoCep;
  final String novoRua;
  final String novoNumero;
  final String novoBairro;
  final String novoCidade;
  final String novoUf;
  final String novoEmail;
  final String novoFone1;
  final String novoFone2;

  const ClienteNovo({
    required this.novoId,
    required this.novoDocumento,
    required this.novoRazao,
    required this.novoFantasia,
    required this.novoCep,
    required this.novoRua,
    required this.novoNumero,
    required this.novoBairro,
    required this.novoCidade,
    required this.novoUf,
    required this.novoEmail,
    required this.novoFone1,
    required this.novoFone2,
  });

  factory ClienteNovo.fromJson(Map<String, dynamic> json) {
    return ClienteNovo(
      novoId: json['id'] as int,
      novoDocumento: json['cnpj'] as String,
      novoRazao: json['nome'] as String,
      novoFantasia: json['fantasia'] as String,
      novoCep: json['cep'] as String,
      novoRua: json['logradouro'] as String,
      novoNumero: json['numero'] as String,
      novoBairro: json['bairro'] as String,
      novoCidade: json['municipio'] as String,
      novoUf: json['uf'] as String,
      novoEmail: json['email'] as String,
      novoFone1: json['telefone'] as String,
      novoFone2: json['telefone2'] as String,
    );
  }

  factory ClienteNovo.fromTxt(Map<String, dynamic> txt) {
    return ClienteNovo(
      novoId: txt['id'] as int,
      novoDocumento: txt['cnpj'] as String,
      novoRazao: txt['nome'] as String,
      novoFantasia: txt['fantasia'] as String,
      novoCep: txt['cep'] as String,
      novoRua: txt['logradouro'] as String,
      novoNumero: txt['numero'] as String,
      novoBairro: txt['bairro'] as String,
      novoCidade: txt['municipio'] as String,
      novoUf: txt['uf'] as String,
      novoEmail: txt['email'] as String,
      novoFone1: txt['telefone'] as String,
      novoFone2: txt['telefone2'] as String,
    );
  }

  factory ClienteNovo.fromMap(Map<dynamic, dynamic> txt) {
    return ClienteNovo(
      novoId: txt['id'] as int,
      novoDocumento: txt['cnpj'] as String,
      novoRazao: txt['nome'] as String,
      novoFantasia: txt['fantasia'] as String,
      novoCep: txt['cep'] as String,
      novoRua: txt['logradouro'] as String,
      novoNumero: txt['numero'] as String,
      novoBairro: txt['bairro'] as String,
      novoCidade: txt['municipio'] as String,
      novoUf: txt['uf'] as String,
      novoEmail: txt['email'] as String,
      novoFone1: txt['telefone'] as String,
      novoFone2: txt['telefone2'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      idCliColumn : novoId,
      cliDocColumn : novoDocumento,
      cliRazaoColumn : novoRazao,
      cliFantasiaColumn : novoFantasia,
      cliCepColumn : novoCep,
      cliRuaColumn : novoRua,
      cliNumColumn : novoNumero,
      cliBairroColumn : novoBairro,
      cliCidadeColumn : novoCidade,
      cliUfColumn : novoUf,
      cliEmailColumn : novoEmail,
      cliFone1Column : novoFone1,
      cliFone2Column : novoFone2,
    };
  }
}
