class Produto {
  final String id;
  final String descricao;
  final String undMedida;
  final String grupo;

  const Produto({
    required this.id,
    required this.descricao,
    required this.undMedida,
    required this.grupo,
  });

  factory Produto.fromTxt(Map<String, dynamic> txt) {
    return Produto(
      id: txt['id'] as String,
      descricao: txt['descricao'] as String,
      undMedida: txt['undMedida'] as String,
      grupo: txt['grupo'] as String,
    );
  }
}
