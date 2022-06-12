class Produto {
  final String id;
  final String descricao;
  final String undMedida;
  final String grupo;
  final String subGrupo;

  const Produto({
    required this.id,
    required this.descricao,
    required this.undMedida,
    required this.grupo,
    required this.subGrupo,
  });

  factory Produto.fromTxt(Map<String, dynamic> txt) {
    return Produto(
      id: txt['id'] as String,
      descricao: txt['descricao'] as String,
      undMedida: txt['unidade de medida'] as String,
      grupo: txt['grupo'] as String,
      subGrupo: txt['sub grupo'] as String,
    );
  }
}