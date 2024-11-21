class Veiculo {
  final String placa;
  final String modelo;
  final String userId;
  final List<String> abastecimentos;

  Veiculo({
    required this.placa,
    required this.modelo,
    required this.userId,
    required this.abastecimentos,
  });

  Map<String, dynamic> toMap() {
    return {
      'placa': placa,
      'modelo': modelo,
      'userId': userId,
      'abastecimentos': abastecimentos,
    };
  }

  factory Veiculo.fromMap(Map<String, dynamic> map) {
    return Veiculo(
      placa: map['placa'] ?? '',
      modelo: map['modelo'] ?? '',
      userId: map['userId'] ?? '',
      abastecimentos: List<String>.from(map['abastecimentos'] ?? []),
    );
  }
}
