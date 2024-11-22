class Veiculo {
  final String id;
  final String modelo;
  final int ano;
  final String placa;

  Veiculo({
    required this.id,
    required this.modelo,
    required this.ano,
    required this.placa,
  });

  Map<String, dynamic> toMap() {
    return {
      'modelo': modelo,
      'ano': ano,
      'placa': placa,
    };
  }

  factory Veiculo.fromMap(Map<String, dynamic> map, String documentId) {
    return Veiculo(
      id: documentId,
      modelo: map['modelo'],
      ano: map['ano'],
      placa: map['placa'],
    );
  }
}
