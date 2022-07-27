final String idVlrColumn = "id";
final String vCompraColumn = "compra";
final String vMinColumn = "minimo";
final String vendaColumn = "venda";
final String sugColumn = "sugerido";

class ProdVlr {
  final int id;
  final num vlrCompra;
  final num vlrMinimo;
  final num vlrVenda;
  final num vlrSugerido;

  const ProdVlr({
    required this.id,
    required this.vlrCompra,
    required this.vlrMinimo,
    required this.vlrVenda,
    required this.vlrSugerido,
  });

  factory ProdVlr.fromTxt(Map<String, dynamic> txt) {
    return ProdVlr(
      id: txt[idVlrColumn] as int,
      vlrCompra: txt[vCompraColumn] as num,
      vlrMinimo: txt[vMinColumn] as num,
      vlrVenda: txt[vendaColumn] as num,
      vlrSugerido: txt[sugColumn] as num,
    );
  }
  factory ProdVlr.fromMap(Map<dynamic, dynamic> txt) {
    return ProdVlr(
      id: txt[idVlrColumn] as int,
      vlrCompra: txt[vCompraColumn] as num,
      vlrMinimo: txt[vMinColumn] as num,
      vlrVenda: txt[vendaColumn] as num,
      vlrSugerido: txt[sugColumn] as num,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      idVlrColumn : id,
      vCompraColumn : vlrCompra,
      vMinColumn : vlrMinimo,
      vendaColumn : vlrVenda,
      sugColumn : vlrSugerido,
    };
  }
}
