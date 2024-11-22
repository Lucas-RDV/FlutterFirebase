class Veiculo {
  String id;
  String nome;
  String modelo;
  int ano;
  String placa;

  Veiculo({required this.id, required this.nome, required this.modelo, required this.ano, required this.placa});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'modelo': modelo,
      'ano': ano,
      'placa': placa,
    };
  }

  factory Veiculo.fromMap(Map<String, dynamic> map, String documentId) {
    return Veiculo(
      id: documentId,
      nome: map['nome'],
      modelo: map['modelo'],
      ano: map['ano'],
      placa: map['placa'],
    );
  }
}
