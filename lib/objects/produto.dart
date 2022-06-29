final String idColumn = "id";
String descColumn = "descricao";
String undColumn = "undMedida";
String grupoColumn = "grupo";
String vCompraColumn = "vCompra";
String vMinColumn = "vMin";
String vProdColumn = "vProd";
String vSugColumn = "vSug";

class Produto {
  final int id;
  final String descricao;
  final String undMedida;
  final int grupo;
  final num valorCompra;
  final num valorMin;
  final num valorProd;
  final num valorSugerido;

  const Produto({
    required this.id,
    required this.descricao,
    required this.undMedida,
    required this.grupo,
    required this.valorCompra,
    required this.valorMin,
    required this.valorProd,
    required this.valorSugerido,
  });

  factory Produto.fromTxt(Map<String, dynamic> txt) {
    return Produto(
      id: txt[idColumn] as int,
      descricao: txt[descColumn] as String,
      undMedida: txt[undColumn] as String,
      grupo: txt[grupoColumn] as int,
      valorCompra: txt[vCompraColumn] as num,
      valorMin: txt[vMinColumn] as num,
      valorProd: txt[vProdColumn] as num,
      valorSugerido: txt[vSugColumn] as num,
    );
  }
  factory Produto.fromMap(Map<dynamic, dynamic> txt) {
    return Produto(
      id: txt[idColumn] as int,
      descricao: txt[descColumn] as String,
      undMedida: txt[undColumn] as String,
      grupo: txt[grupoColumn] as int,
      valorCompra: txt[vCompraColumn] as num, // aqui esta o problema
      valorMin: txt[vMinColumn] as num,
      valorProd: txt[vProdColumn] as num,
      valorSugerido: txt[vSugColumn] as num,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      idColumn : id,
      descColumn : descricao,
      undColumn : undMedida,
      grupoColumn : grupo,
      vCompraColumn : valorCompra,
      vMinColumn : valorMin,
      vProdColumn : valorProd,
      vSugColumn : valorSugerido,
    };
  }

  @override
  String toString() {
    return 'id: $id, Descrição: $descricao, Unidade: $undMedida, Grupo: $grupo';
  }
}
