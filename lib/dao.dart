import 'package:firebase_projeto/model/abastecimento.dart';
import 'package:firebase_projeto/model/veiculo.dart';
import 'package:firebase_projeto/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class DaoFirestore {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  static Future<void> inicializa() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  static Future<void> salvarVeiculo(Veiculo veiculo, String id) async {
    try {
      await db.collection("veiculos").doc(id).set(veiculo.toMap());
    } catch (error) {
      print("Erro ao salvar veículo com ID $id: $error");
    }
  }

  static Future<void> salvarVeiculoAutoID(Veiculo veiculo) async {
    try {
      await db.collection("veiculos").add(veiculo.toMap());
    } catch (error) {
      print("Erro ao salvar veículo com ID automático: $error");
    }
  }

  static Future<void> atualizarVeiculo(Veiculo veiculo, String id) async {
    try {
      await db.collection("veiculos").doc(id).update(veiculo.toMap());
    } catch (error) {
      print("Erro ao atualizar veículo com ID $id: $error");
    }
  }

  static Future<void> excluirVeiculo(String id) async {
    try {
      await db.collection("veiculos").doc(id).delete();
    } catch (error) {
      print("Erro ao excluir veículo com ID $id: $error");
    }
  }

  static Stream<List<Veiculo>> getVeiculos() {
    return db.collection('veiculos').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Veiculo(
          nome: doc['nome'] ?? '',
          modelo: doc['modelo'] ?? '',
          ano: doc['ano'] ?? '',
          placa: doc['placa'] ?? '',
        );
      }).toList();
    });
  }

  static Future<void> salvarAbastecimento(Abastecimento abastecimento, String veiculoId) async {
    try {
      await db.collection("veiculos")
        .doc(veiculoId)
        .collection("abastecimentos")
        .add(abastecimento.toMap());
    } catch (error) {
      print("Erro ao salvar abastecimento para o veículo com ID $veiculoId: $error");
    }
  }

  static Stream<List<Abastecimento>> getAbastecimentos(String veiculoId) {
    return db.collection("veiculos")
      .doc(veiculoId)
      .collection("abastecimentos")
      .snapshots()
      .map((snapshot) {
        return snapshot.docs.map((doc) {
          return Abastecimento(
            litros: doc['litros'],
            quilometragem: doc['quilometragem'],
            data: (doc['data'] as Timestamp).toDate(),
          );
        }).toList();
      });
  }
}
