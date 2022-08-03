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
final String cliDDDColumn = "ddd";
final String cliFone1Column = "fone1";
final String cliPjColumn = "pj";
final String cliEmailColumn = "email";


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
  final String ddd;
  final String fone1;
  final String pj;
  final String email;

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
    required this.ddd,
    required this.fone1,
    required this.pj,
    required this.email,
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
      ddd: json['ddd'] as String,
      fone1: json['telefone'] as String,
      pj: json['pj'] as String,
      email: json['email'] as String,
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
      ddd: txt['ddd'] as String,
      fone1: txt['telefone'] as String,
      pj: txt['pj'] as String,
      email: txt['email'] as String,
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
      ddd: txt['ddd'] as String,
      fone1: txt['telefone'] as String,
      pj: txt['pj'] as String,
      email: txt['email'] as String,
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
      cliUfColumn : ddd,
      cliFone1Column : fone1,
      cliPjColumn : pj,
      cliEmailColumn : email,
    };
  }
}
