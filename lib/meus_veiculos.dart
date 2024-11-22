import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'veiculoDAO.dart';
import 'model/veiculo.dart';
import 'abastecimentoDAO.dart';
import 'historico_veiculo.dart';

class MeusVeiculosPage extends StatefulWidget {
  @override
  _MeusVeiculosPageState createState() => _MeusVeiculosPageState();
}

class _MeusVeiculosPageState extends State<MeusVeiculosPage> {
  final User? user = FirebaseAuth.instance.currentUser;
  final VeiculoDAO veiculoDAO = VeiculoDAO();
  final AbastecimentoDAO abastecimentoDAO = AbastecimentoDAO();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Meus Veículos"),
      ),
      body: StreamBuilder<List<Veiculo>>(
        stream: veiculoDAO.getVeiculosByUserId(user?.uid ?? ""),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("Nenhum veículo cadastrado."));
          }

          final veiculos = snapshot.data!;

          return ListView.builder(
            itemCount: veiculos.length,
            itemBuilder: (context, index) {
              var veiculo = veiculos[index];
              return FutureBuilder<double>(
                future: abastecimentoDAO.calcularMediaConsumo(veiculo.id),
                builder: (context, mediaSnapshot) {
                  if (mediaSnapshot.connectionState == ConnectionState.waiting) {
                    return ListTile(
                      title: Text(veiculo.modelo),
                      subtitle: Text("Ano: ${veiculo.ano} | Placa: ${veiculo.placa} | Calculando média de consumo..."),
                    );
                  }

                  double mediaConsumo = mediaSnapshot.data ?? 0.0;
                  return ListTile(
                    title: Text(veiculo.modelo),
                    subtitle: Text("Ano: ${veiculo.ano} | Placa: ${veiculo.placa} | Média: ${mediaConsumo.toStringAsFixed(2)} km/l"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.history),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HistoricoVeiculoPage(veiculoId: veiculo.id),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () async {
                            await veiculoDAO.deletarVeiculo(veiculo.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Veículo excluído com sucesso!")),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
