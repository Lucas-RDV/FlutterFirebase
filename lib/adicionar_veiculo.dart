import 'package:flutter/material.dart';
import 'model/veiculo.dart';
import 'veiculoDAO.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdicionarVeiculoPage extends StatefulWidget {
  @override
  _AdicionarVeiculoPageState createState() => _AdicionarVeiculoPageState();
}

class _AdicionarVeiculoPageState extends State<AdicionarVeiculoPage> {
    final TextEditingController _modeloController = TextEditingController();
  final TextEditingController _anoController = TextEditingController();
  final TextEditingController _placaController = TextEditingController();

  final VeiculoDAO veiculoDAO = VeiculoDAO();
  final User? user = FirebaseAuth.instance.currentUser;

  Future<void> _salvarVeiculo() async {
    if (_modeloController.text.isNotEmpty &&
        _anoController.text.isNotEmpty &&
        _placaController.text.isNotEmpty) {
      try {
        Veiculo novoVeiculo = Veiculo(
          id: '',
          modelo: _modeloController.text,
          ano: int.parse(_anoController.text),
          placa: _placaController.text ?? '',
        );
        await veiculoDAO.adicionarVeiculo(novoVeiculo);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Veículo salvo com sucesso!")),
        );
        Navigator.pop(context); // Retorna para a tela anterior após salvar
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erro ao salvar veículo: $e")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Todos os campos são obrigatórios.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Adicionar Veículo"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
                        TextField(
              controller: _modeloController,
              decoration: InputDecoration(
                labelText: "Modelo",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _anoController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Ano",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _placaController,
              decoration: InputDecoration(
                labelText: "Placa",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _salvarVeiculo,
              child: Text("Salvar Veículo"),
            ),
          ],
        ),
      ),
    );
  }
}
