import 'package:firebase_projeto/firebaseAuth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'perfil.dart';
import 'login.dart';
// import 'meus_veiculos.dart';
import 'veiculoDAO.dart';
import 'model/veiculo.dart';
import 'adicionar_veiculo.dart';
// import 'historico_abastecimentos_page.dart';
import 'novo_abastecimento.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AutenticacaoFirebase auth = AutenticacaoFirebase();
  User? user;
  final VeiculoDAO veiculoDAO = VeiculoDAO();

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  Future<void> _getUser() async {
    setState(() {
      user = FirebaseAuth.instance.currentUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Controle de Abastecimento"),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(user?.displayName ?? "Usuário Anônimo"), 
              accountEmail: Text(user?.email ?? "Email não disponível"), 
              currentAccountPicture: CircleAvatar(
                child: Icon(Icons.person, size: 40),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text("Home"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.directions_car),
              title: Text("Meus Veículos"),
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => MeusVeiculosPage()),
                // );
              },
            ),
            ListTile(
              leading: Icon(Icons.add),
              title: Text("Adicionar Veículo"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdicionarVeiculoPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.history),
              title: Text("Histórico de Abastecimentos"),
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => HistoricoAbastecimentosPage()),
                // );
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text("Perfil"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PerfilPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Logout"),
              onTap: () async {
                String message = await auth.signOut();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(message)),
                );
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                );
              },
            ),
          ],
        ),
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
              return ListTile(
                title: Text(veiculo.modelo),
                subtitle: Text("Ano: ${veiculo.ano} | Placa: ${veiculo.placa}"),
                trailing: IconButton(
                  icon: Icon(Icons.local_gas_station),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NovoAbastecimentoPage(veiculo: veiculo),
                      ),
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
