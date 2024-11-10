
import 'package:firebase_database/firebase_database.dart';

class Registrocontroller {

  // Adicionando dados
   void addUser(String id, String nome, int quantidade, double valor) {
    final databaseRef =
        FirebaseDatabase.instance.ref('produtos'); // Caminho no banco de dados
    databaseRef.child(id).set({
      'nome': 'nome',
      'quantidade': quantidade,
      'valor': valor,
    });
  }

  // Lendo dados
   Future<Object?> getProdutosList() async {
    final databaseRef = FirebaseDatabase.instance.ref('produtos');
    DatabaseEvent event = await databaseRef.once();
    return event.snapshot.value; // Imprime os dados de user1
  }
}