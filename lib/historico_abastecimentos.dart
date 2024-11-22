import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'abastecimentoDAO.dart';
import 'model/abastecimento.dart';

class HistoricoAbastecimentosPage extends StatelessWidget {
  final User? user = FirebaseAuth.instance.currentUser;
  final AbastecimentoDAO abastecimentoDAO = AbastecimentoDAO();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Histórico Geral de Abastecimentos"),
      ),
      body: StreamBuilder<List<Abastecimento>>(
        stream: abastecimentoDAO.getAbastecimentosByUserId(user?.uid ?? ""),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("Nenhum abastecimento registrado."));
          }

          final abastecimentos = snapshot.data!;

          return ListView.builder(
            itemCount: abastecimentos.length,
            itemBuilder: (context, index) {
              var abastecimento = abastecimentos[index];
              return ListTile(
                title: Text("Litros: ${abastecimento.litros.toStringAsFixed(2)} L"),
                subtitle: Text("Quilometragem: ${abastecimento.quilometragemAtual} km | Data: ${abastecimento.data.toLocal()}"),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    await abastecimentoDAO.deletarAbastecimento(abastecimento.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Abastecimento excluído com sucesso!")),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
