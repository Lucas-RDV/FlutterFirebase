import 'package:firebase_projeto/dao.dart';
import 'package:firebase_projeto/login.dart';
import 'package:firebase_projeto/model/veiculo.dart';
import 'package:firebase_projeto/perfilScreen.dart';
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
  // Função para realizar o logout
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
            // Removido o DrawerHeader com o nome e imagem do usuário

            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Home"),
              onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const HomeScreen(title: 'Meus Veículos')),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.directions_car),
              title: const Text("Meus Veículos"),
              onTap: () {
                // Ação de Navegação para a tela de veículos
              },
            ),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text("Adicionar Veículo"),
              onTap: () {
                // Ação de Navegação para adicionar novo veículo
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text("Histórico de Abastecimentos"),
              onTap: () {
                // Ação de Navegação para o histórico de abastecimentos
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
            // Alterado para o botão de Logout
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: _logout, // Chama a função de logout
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Lista de Veículos Cadastrados:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: StreamBuilder<List<Veiculo>>(
                stream: DaoFirestore.getVeiculos(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return const Text('Erro ao carregar dados');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text('Nenhum veículo encontrado');
                  } else {
                    final veiculos = snapshot.data!;
                    return ListView.builder(
                      itemCount: veiculos.length,
                      itemBuilder: (context, index) {
                        final veiculo = veiculos[index];
                        return ListTile(
                          title: Text(veiculo.nome),
                          subtitle: Text(
                              'Modelo: ${veiculo.modelo} | Ano: ${veiculo.ano}'),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Ação para adicionar um novo veículo
        },
        tooltip: 'Adicionar Veículo',
        child: const Icon(Icons.add),
      ),
    );
  }
}
