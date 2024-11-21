import 'package:firebase_auth/firebase_auth.dart';
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
    await db.collection("veiculos").doc(id).set(veiculo.toMap()).catchError(
          (error) => print("Erro ao salvar veículo: $error"),
        );
  }

  static Future<void> salvarVeiculoAutoID(Veiculo veiculo) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('Usuário não está logado.');
    }

    final veiculoMap = veiculo.toMap(); // Converte o veículo para mapa
    veiculoMap['userId'] = user.uid; // Adiciona o userId ao mapa

    await db.collection('veiculos').add(veiculoMap);
  }

  static Future<void> atualizarVeiculo(Veiculo veiculo, String id) async {
    await db.collection("veiculos").doc(id).update(veiculo.toMap()).catchError(
          (error) => print("Erro ao atualizar veículo: $error"),
        );
  }

  static Future<void> excluirVeiculo(String id) async {
    try {
      await db.collection("veiculos").doc(id).delete();
    } catch (error) {
      print("Erro ao excluir veículo com ID $id: $error");
    }
  }

  static Stream<List<Veiculo>> getVeiculos() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Stream.empty();
    }

    return db
        .collection('veiculos')
        .where('userId', isEqualTo: user.uid)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Veiculo.fromMap(doc.data());
      }).toList();
    });
  }

  static Future<void> salvarAbastecimento(
      Abastecimento abastecimento, String veiculoId) async {
    try {
      await db
          .collection("veiculos")
          .doc(veiculoId)
          .collection("abastecimentos")
          .add(abastecimento.toMap());
    } catch (error) {
      print(
          "Erro ao salvar abastecimento para o veículo com ID $veiculoId: $error");
    }
  }

  static Stream<List<Abastecimento>> getAbastecimentos(String veiculoId) {
    return db
        .collection("veiculos")
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
