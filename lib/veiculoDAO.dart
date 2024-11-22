import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_projeto/model/veiculo.dart';


class VeiculoDAO {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Veiculo>> getVeiculosByUserId(String userId) {
    return _firestore
        .collection('veiculos')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Veiculo.fromMap(doc.data(), doc.id))
            .toList());
  }

  Future<void> adicionarVeiculo(Veiculo veiculo) async {
    try {
      await _firestore.collection('veiculos').add(veiculo.toMap());
    } catch (e) {
      print("Erro ao adicionar veículo: $e");
    }
  }

  Future<void> deletarVeiculo(String veiculoId) async {
    try {
      await _firestore.collection('veiculos').doc(veiculoId).delete();
    } catch (e) {
      print("Erro ao deletar veículo: $e");
    }
  }
}
