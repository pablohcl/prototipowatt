final String idCliColumn = "id";
final String cliRazaoColumn = "razao";
final String cliFantasiaColumn = "fantasia";
final String cliDocColumn = "documento";
final String cliInscrColumn = "inscricao";
final String cliCepColumn = "cep";
final String cliRuaColumn = "rua";
final String cliNumColumn = "numero";
final String cliBairroColumn = "bairro";
final String cliCidadeColumn = "cidade";
final String cliUfColumn = "uf";
final String cliEmailColumn = "email";
final String cliFone1Column = "fone1";
final String cliFone2Column = "fone2";

class Cliente {
  final int id;
  final String razao;
  final String fantasia;
  final String documento;
  final String inscrEstadual;
  final String cep;
  final String rua;
  final String numero;
  final String bairro;
  final String cidade;
  final String uf;
  final String email;
  final String fone1;
  final String fone2;

  const Cliente({
    required this.id,
    required this.razao,
    required this.fantasia,
    required this.documento,
    required this.inscrEstadual,
    required this.cep,
    required this.rua,
    required this.numero,
    required this.bairro,
    required this.cidade,
    required this.uf,
    required this.email,
    required this.fone1,
    required this.fone2,
  });

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      id: json['id'] as int,
      razao: json['nome'] as String,
      fantasia: json['fantasia'] as String,
      documento: json['cnpj'] as String,
      inscrEstadual: json['inscricao'] as String,
      cep: json['cep'] as String,
      rua: json['logradouro'] as String,
      numero: json['numero'] as String,
      bairro: json['bairro'] as String,
      cidade: json['municipio'] as String,
      uf: json['uf'] as String,
      email: json['email'] as String,
      fone1: json['telefone'] as String,
      fone2: '',
    );
  }

  factory Cliente.fromTxt(Map<String, dynamic> txt) {
    return Cliente(
      id: txt['id'] as int,
      razao: txt['nome'] as String,
      fantasia: txt['fantasia'] as String,
      documento: txt['cnpj'] as String,
      inscrEstadual: txt['inscricao'] as String,
      cep: txt['cep'] as String,
      rua: txt['logradouro'] as String,
      numero: txt['numero'] as String,
      bairro: txt['bairro'] as String,
      cidade: txt['municipio'] as String,
      uf: txt['uf'] as String,
      email: txt['email'] as String,
      fone1: txt['telefone'] as String,
      fone2: '',
    );
  }

  factory Cliente.fromMap(Map<dynamic, dynamic> txt) {
    return Cliente(
      id: txt['id'] as int,
      razao: txt['nome'] as String,
      fantasia: txt['fantasia'] as String,
      documento: txt['cnpj'] as String,
      inscrEstadual: txt['inscricao'] as String,
      cep: txt['cep'] as String,
      rua: txt['logradouro'] as String,
      numero: txt['numero'] as String,
      bairro: txt['bairro'] as String,
      cidade: txt['municipio'] as String,
      uf: txt['uf'] as String,
      email: txt['email'] as String,
      fone1: txt['telefone'] as String,
      fone2: '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      idCliColumn: id,
      cliRazaoColumn : razao,
      cliFantasiaColumn : fantasia,
      cliDocColumn : documento,
      cliInscrColumn : inscrEstadual,
      cliCepColumn : cep,
      cliRuaColumn : rua,
      cliNumColumn : numero,
      cliBairroColumn : bairro,
      cliCidadeColumn : cidade,
      cliUfColumn : uf,
      cliEmailColumn : email,
      cliFone1Column : fone1,
      cliFone2Column : fone2,
    };
  }
}
