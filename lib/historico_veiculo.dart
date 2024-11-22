import 'package:flutter/material.dart';
import 'abastecimentoDAO.dart';
import 'model/abastecimento.dart';

class HistoricoVeiculoPage extends StatelessWidget {
  final String veiculoId;
  final AbastecimentoDAO abastecimentoDAO = AbastecimentoDAO();

  HistoricoVeiculoPage({required this.veiculoId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Histórico do Veículo"),
      ),
      body: StreamBuilder<List<Abastecimento>>(
        stream: abastecimentoDAO.getAbastecimentosByVeiculoId(veiculoId),
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
