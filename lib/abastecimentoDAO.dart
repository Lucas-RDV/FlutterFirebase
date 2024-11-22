import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_projeto/model/abastecimento.dart';

class AbastecimentoDAO {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<double> calcularMediaConsumo(String veiculoId) async {
    try {
      QuerySnapshot abastecimentosSnapshot = await _firestore
          .collection('abastecimentos')
          .where('veiculoId', isEqualTo: veiculoId)
          .orderBy('data')
          .get();

      if (abastecimentosSnapshot.docs.length < 2) {
        // Média de consumo requer pelo menos dois abastecimentos
        return 0.0;
      }

      double totalKm = 0;
      double totalLitros = 0;

      for (int i = 1; i < abastecimentosSnapshot.docs.length; i++) {
        var abastecimentoAnterior = abastecimentosSnapshot.docs[i - 1];
        var abastecimentoAtual = abastecimentosSnapshot.docs[i];

        int kmAnterior = abastecimentoAnterior['quilometragemAtual'];
        int kmAtual = abastecimentoAtual['quilometragemAtual'];
        double litros = abastecimentoAtual['litros'];

        totalKm += (kmAtual - kmAnterior);
        totalLitros += litros;
      }

      return totalLitros > 0 ? totalKm / totalLitros : 0.0;
    } catch (e) {
      print("Erro ao calcular a média de consumo: $e");
      return 0.0;
    }
  }

  Future<void> adicionarAbastecimento(Abastecimento abastecimento) async {
    try {
      await _firestore.collection('abastecimentos').add(abastecimento.toMap());
    } catch (e) {
      print("Erro ao adicionar abastecimento: $e");
    }
  }

  Stream<List<Abastecimento>> lerAbastecimentos(String veiculoId) {
    return _firestore
        .collection('abastecimentos')
        .where('veiculoId', isEqualTo: veiculoId)
        .orderBy('data')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Abastecimento.fromMap(doc.data(), doc.id))
            .toList());
  }

  Future<void> deletarAbastecimento(String abastecimentoId) async {
    try {
      await _firestore.collection('abastecimentos').doc(abastecimentoId).delete();
    } catch (e) {
      print("Erro ao deletar abastecimento: $e");
    }
  }
}
