import 'package:firebase_projeto/model/registro.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_projeto/firebase_options.dart';

class DaoRealTime {
  static final FirebaseDatabase db = FirebaseDatabase.instance;

  static void inicializa() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  static void salvar(Cliente c, int _counter) {
    db.ref("clientes").child("cliente$_counter").set(c.toMap).onError(
          (error, stackTrace) => print("Erro ao salvar cliente: $error"),
        );
  }

  // Função para buscar clientes do Realtime Database
  static Stream<List<Cliente>> getClientes() {
    return db.ref("clientes").onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>? ?? {};
      return data.entries.map((entry) {
        final clienteData = entry.value as Map;
        return Cliente(
          nome: clienteData['nome'],
          idade: clienteData['idade'],
        );
      }).toList();
    });
  }
}