final String idColumn = "id";
String descColumn = "descricao";
String undColumn = "undMedida";
String grupoColumn = "grupo";

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
      id: txt[idColumn] as int,
      descricao: txt[descColumn] as String,
      undMedida: txt[undColumn] as String,
      grupo: txt[grupoColumn] as String,
    );
  }
  factory Produto.fromMap(Map<dynamic, dynamic> txt) {
    return Produto(
      id: txt[idColumn] as int,
      descricao: txt[descColumn] as String,
      undMedida: txt[undColumn] as String,
      grupo: txt[grupoColumn] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      idColumn : id,
      descColumn : descricao,
      undColumn : undMedida,
      grupoColumn : grupo,
    };
  }

  @override
  String toString() {
    return 'id: $id, Descrição: $descricao, Unidade: $undMedida, Grupo: $grupo';
  }
}
