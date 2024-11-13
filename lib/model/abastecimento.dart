import 'package:cloud_firestore/cloud_firestore.dart';

class Abastecimento {
  final double litros;
  final int quilometragem;
  final DateTime data;

  Abastecimento({
    required this.litros,
    required this.quilometragem,
    required this.data,
  });

  Map<String, dynamic> toMap() {
    return {
      'litros': litros,
      'quilometragem': quilometragem,
      'data': Timestamp.fromDate(data),
    };
  }

  factory Abastecimento.fromMap(Map<String, dynamic> map) {
    return Abastecimento(
      litros: map['litros']?.toDouble() ?? 0.0,
      quilometragem: map['quilometragem']?.toInt() ?? 0,
      data: (map['data'] as Timestamp).toDate(),
    );
  }
}
