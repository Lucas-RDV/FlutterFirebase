class Abastecimento {
  String veiculoId;
  double quantidadeLitros; 
  double quilometragem; 
  DateTime data; 

  Abastecimento({
    required this.veiculoId,
    required this.quantidadeLitros,
    required this.quilometragem,
    required this.data,
  });
  
  Map<String, dynamic> toMap() {
    return {
      'veiculoId': veiculoId,
      'quantidadeLitros': quantidadeLitros,
      'quilometragem': quilometragem,
      'data': data.toIso8601String(),
    };
  }

  factory Abastecimento.fromMap(Map<String, dynamic> map) {
    return Abastecimento(
      veiculoId: map['veiculoId'] ?? '',
      quantidadeLitros: map['quantidadeLitros'] ?? 0.0,
      quilometragem: map['quilometragem'] ?? 0.0,
      data: DateTime.parse(map['data'] ?? DateTime.now().toIso8601String()),
    );
  }
}
