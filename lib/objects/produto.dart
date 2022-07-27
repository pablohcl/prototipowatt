final String idColumn = "id";
final String refColumn = "ref";
final String descColumn = "descricao";
final String undColumn = "undMedida";
final String grupoColumn = "grupo";

class Produto {
  final int id;
  final String ref;
  final String descricao;
  final String undMedida;
  final int grupo;

  const Produto({
    required this.id,
    required this.ref,
    required this.descricao,
    required this.undMedida,
    required this.grupo,
  });

  factory Produto.fromTxt(Map<String, dynamic> txt) {
    return Produto(
      id: txt[idColumn] as int,
      ref: txt[refColumn] as String,
      descricao: txt[descColumn] as String,
      undMedida: txt[undColumn] as String,
      grupo: txt[grupoColumn] as int,
    );
  }
  factory Produto.fromMap(Map<dynamic, dynamic> txt) {
    return Produto(
      id: txt[idColumn] as int,
      ref: txt[refColumn] as String,
      descricao: txt[descColumn] as String,
      undMedida: txt[undColumn] as String,
      grupo: txt[grupoColumn] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      idColumn : id,
      refColumn : ref,
      descColumn : descricao,
      undColumn : undMedida,
      grupoColumn : grupo,
    };
  }

  @override
  String toString() {
    return 'id: $id, Ref: $ref, Descrição: $descricao, Unidade: $undMedida, Grupo: $grupo';
  }
}
