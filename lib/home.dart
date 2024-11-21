import 'package:firebase_projeto/dao.dart';
import 'package:firebase_projeto/login.dart';
import 'package:firebase_projeto/model/veiculo.dart';
import 'package:firebase_projeto/perfilScreen.dart';
import 'package:firebase_projeto/cadastroVeiculo.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Controle de Abastecimento',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(title: 'Meus Veículos'),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});

  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
    } catch (e) {
      print("Erro ao realizar logout: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Home"),
              onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const HomeScreen(title: 'Meus Veículos')),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.directions_car),
              title: const Text("Meus Veículos"),
              onTap: () {
                // Ação para a tela de veículos
              },
            ),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text("Adicionar Veículo"),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CadastroVeiculo()),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text("Histórico de Abastecimentos"),
              onTap: () {
                // Redireciona para histórico de abastecimentos
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Perfil"),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PerfilScreen()),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: _logout,
            ),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Lista de Veículos Cadastrados:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Veiculo>>(
              stream: DaoFirestore.getVeiculos(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Erro ao carregar dados'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Nenhum veículo encontrado'));
                } else {
                  final veiculos = snapshot.data!;
                  return ListView.builder(
                    itemCount: veiculos.length,
                    itemBuilder: (context, index) {
                      final veiculo = veiculos[index];
                      return ListTile(
                        title: Text('Placa: ${veiculo.placa}'),
                        subtitle: Text('Modelo: ${veiculo.modelo}'),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
