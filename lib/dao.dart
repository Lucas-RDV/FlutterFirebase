import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_projeto/model/abastecimento.dart';
import 'package:firebase_projeto/model/veiculo.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addVeiculo(Veiculo veiculo) async {
    await _firestore.collection('veiculos').add(veiculo.toMap());
  }

  Future<List<Veiculo>> getVeiculos(String userId) async {
    var querySnapshot = await _firestore.collection('veiculos').where('userId', isEqualTo: userId).get();
    return querySnapshot.docs.map((doc) => Veiculo.fromMap(doc.data(), doc.id)).toList();
  }

  Future<void> deleteVeiculo(String id) async {
    await _firestore.collection('veiculos').doc(id).delete();
  }

  Future<void> addAbastecimento(Abastecimento abastecimento) async {
    await _firestore.collection('abastecimentos').add(abastecimento.toMap());
  }

  Future<List<Abastecimento>> getAbastecimentos(String veiculoId) async {
    var querySnapshot = await _firestore.collection('abastecimentos').where('veiculoId', isEqualTo: veiculoId).get();
    return querySnapshot.docs.map((doc) => Abastecimento.fromMap(doc.data(), doc.id)).toList();
  }
}
