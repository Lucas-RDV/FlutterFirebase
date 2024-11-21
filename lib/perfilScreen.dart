import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({Key? key}) : super(key: key);

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String email = 'Carregando...';

  @override
  void initState() {
    super.initState();
    _carregarEmailUsuario();
  }

  Future<void> _carregarEmailUsuario() async {
    try {
      final user = _auth.currentUser;
      setState(() {
        email = user?.email ?? 'E-mail não disponível';
      });
    } catch (e) {
      setState(() {
        email = 'Erro ao carregar e-mail';
      });
      debugPrint('Erro ao carregar e-mail: $e');
    }
  }

  Future<void> _alterarEmail(String novoEmail) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await user.updateEmail(novoEmail);
        await user.reload();
        setState(() {
          email = novoEmail;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('E-mail alterado com sucesso!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao alterar e-mail: $e')),
      );
    }
  }

  Future<void> _alterarSenha(String novaSenha) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await user.updatePassword(novaSenha);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Senha alterada com sucesso!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao alterar senha: $e')),
      );
    }
  }

  Future<void> _exibirDialogoAlterarEmail() async {
    final TextEditingController controller = TextEditingController();
    final novoEmail = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Alterar E-mail'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Novo E-mail',
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, null),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, controller.text),
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );

    if (novoEmail != null && novoEmail.isNotEmpty) {
      await _alterarEmail(novoEmail);
    }
  }

  Future<void> _exibirDialogoAlterarSenha() async {
    final TextEditingController controller = TextEditingController();
    final novaSenha = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Alterar Senha'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Nova Senha',
            ),
            obscureText: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, null),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, controller.text),
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );

    if (novaSenha != null && novaSenha.isNotEmpty) {
      await _alterarSenha(novaSenha);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'E-mail: $email',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _exibirDialogoAlterarEmail,
              child: const Text('Alterar E-mail'),
            ),
            ElevatedButton(
              onPressed: _exibirDialogoAlterarSenha,
              child: const Text('Alterar Senha'),
            ),
          ],
        ),
      ),
    );
  }
}
