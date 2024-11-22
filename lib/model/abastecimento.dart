class Abastecimento {
  String id;
  String veiculoId;
  double litros;
  int quilometragemAtual;
  DateTime data;

  Abastecimento({
    required this.id,
    required this.veiculoId,
    required this.litros,
    required this.quilometragemAtual,
    required this.data,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'veiculoId': veiculoId,
      'litros': litros,
      'quilometragemAtual': quilometragemAtual,
      'data': data.toIso8601String(),
    };
  }

  factory Abastecimento.fromMap(Map<String, dynamic> map, String documentId) {
    return Abastecimento(
      id: documentId,
      veiculoId: map['veiculoId'],
      litros: map['litros'],
      quilometragemAtual: map['quilometragemAtual'],
      data: DateTime.parse(map['data']),
    );
  }
}
