final String idCondColumn = "id";
final String condCondColumn = "condicao";

class CondPgto {
  final int id;
  final String condicao;

  const CondPgto({
    required this.id,
    required this.condicao,
  });

  factory CondPgto.fromTxt(Map<String, dynamic> txt) {
    return CondPgto(
      id: txt[idCondColumn] as int,
      condicao: txt[condCondColumn] as String,
    );
  }
  factory CondPgto.fromMap(Map<dynamic, dynamic> txt) {
    return CondPgto(
      id: txt[idCondColumn] as int,
      condicao: txt[condCondColumn] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      idCondColumn : id,
      condCondColumn : condicao,
    };
  }

  @override
  String toString() {
    return 'id: $id, Condição: $condicao';
  }
}
