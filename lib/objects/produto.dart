class Produto {
  final int id;
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
      id: txt['id'] as int,
      descricao: txt['descricao'] as String,
      undMedida: txt['undMedida'] as String,
      grupo: txt['grupo'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'descricao' : descricao,
      'undMedida' : undMedida,
      'grupo' : grupo,
    };
  }

  @override
  String toString() {
    return 'id: $id, Descrição: $descricao, Unidade: $undMedida, Grupo: $grupo';
  }
}
