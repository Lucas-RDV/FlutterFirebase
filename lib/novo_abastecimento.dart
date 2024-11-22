import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'model/veiculo.dart';
import 'model/abastecimento.dart';

class NovoAbastecimentoPage extends StatefulWidget {
  final Veiculo veiculo;

  NovoAbastecimentoPage({required this.veiculo});

  @override
  _NovoAbastecimentoPageState createState() => _NovoAbastecimentoPageState();
}

class _NovoAbastecimentoPageState extends State<NovoAbastecimentoPage> {
  final TextEditingController _litrosController = TextEditingController();
  final TextEditingController _quilometragemController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _salvarAbastecimento() async {
    if (_litrosController.text.isNotEmpty && _quilometragemController.text.isNotEmpty) {
      try {
        Abastecimento novoAbastecimento = Abastecimento(
          id: '',
          veiculoId: widget.veiculo.id,
          litros: double.parse(_litrosController.text),
          quilometragemAtual: int.parse(_quilometragemController.text),
          data: DateTime.now(),
        );

        await _firestore.collection('abastecimentos').add(novoAbastecimento.toMap());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Abastecimento salvo com sucesso!")),
        );
        Navigator.pop(context); 
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erro ao salvar abastecimento: $e")),
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
        title: Text("Novo Abastecimento - ${widget.veiculo.modelo}"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _litrosController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Litros Abastecidos",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _quilometragemController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Quilometragem Atual",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _salvarAbastecimento,
              child: Text("Salvar Abastecimento"),
            ),
          ],
        ),
      ),
    );
  }
}
