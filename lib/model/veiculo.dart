class Veiculo {
  String nome;
  String modelo;
  String ano;
  String placa;

  Veiculo({
    required this.nome,
    required this.modelo,
    required this.ano,
    required this.placa,
  });

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'modelo': modelo,
      'ano': ano,
      'placa': placa,
    };
  }

  factory Veiculo.fromMap(Map<String, dynamic> map) {
    return Veiculo(
      nome: map['nome'] ?? '',
      modelo: map['modelo'] ?? '',
      ano: map['ano'] ?? '',
      placa: map['placa'] ?? '',
    );
  }
}
