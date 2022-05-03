class Cliente {
  final String documento;
  final String razao;
  final String fantasia;
  final String cep;
  final String rua;
  final String numero;
  final String bairro;
  final String cidade;
  final String uf;
  final String email;

  const Cliente({
    required this.documento,
    required this.razao,
    required this.fantasia,
    required this.cep,
    required this.rua,
    required this.numero,
    required this.bairro,
    required this.cidade,
    required this.uf,
    required this.email,
  });

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      documento: json['cnpj'] as String,
      razao: json['nome'] as String,
      fantasia: json['fantasia'] as String,
      cep: json['cep'] as String,
      rua: json['rua'] as String,
      numero: json['numero'] as String,
      bairro: json['bairro'] as String,
      cidade: json['municipio'] as String,
      uf: json['uf'] as String,
      email: json['email'] as String,
    );
  }
}
