import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_projeto/dao.dart';
import 'package:firebase_projeto/model/veiculo.dart';
import 'package:flutter/material.dart';

class CadastroVeiculo extends StatefulWidget {
  @override
  _CadastroVeiculoState createState() => _CadastroVeiculoState();
}

class _CadastroVeiculoState extends State<CadastroVeiculo> {
  final _formKey = GlobalKey<FormState>();
  final _placaController = TextEditingController();
  final _modeloController = TextEditingController();

  @override
  void dispose() {
    _placaController.dispose();
    _modeloController.dispose();
    super.dispose();
  }

  void _salvarVeiculo() async {
    if (_formKey.currentState!.validate()) {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final veiculo = Veiculo(
          placa: _placaController.text,
          modelo: _modeloController.text,
          abastecimentos: [],
          userId: user.uid,
        );

        DaoFirestore.salvarVeiculoAutoID(veiculo).then((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Veículo cadastrado com sucesso!')),
          );
          Navigator.pop(context);
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao salvar veículo: $error')),
          );
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuário não autenticado')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar Veículo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _placaController,
                decoration: const InputDecoration(labelText: 'Placa'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe a placa do veículo';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _modeloController,
                decoration: const InputDecoration(labelText: 'Modelo'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe o modelo do veículo';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _salvarVeiculo,
                child: const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
