import 'package:flutter/material.dart';
import '../dados_mock.dart';
import '../services/api_services.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {

  final TextEditingController nomeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  final TextEditingController confirmarSenhaController = TextEditingController();

  bool esconderSenha = true;
  bool esconderConfirmacao = true;

  Future<void> cadastrar() async{
    String nome = nomeController.text.trim();
    String email = emailController.text.trim();
    String senha = senhaController.text;
    String confirmarSenha = confirmarSenhaController.text;

    if(nome.isEmpty || email.isEmpty || senha.isEmpty || confirmarSenha.isEmpty){
      mostrarMensagem('Preencha todos os campos');
      return;
    }

    if(!email.contains('@')){
      mostrarMensagem('Digite um e-mail válido');
      return;
    }

    if(senha.length < 4){
      mostrarMensagem('A senha deve ter no mínimo 4 caracteres');
      return;
    }

    if(senha != confirmarSenha){
      mostrarMensagem('As senhas não coincidem');
      return;
    }

    bool emailExistente = false;

    for(var usuario in usuarios){
      if(usuario['email'] == email){
        emailExistente = true;
        break;
      }
    }

    if(emailExistente){
      mostrarMensagem('E-mail já cadastrado');
      return;
    }

    // Map<String, String> novoUsuario = {
    //   'nome': nome,
    //   'email': email,
    //   'senha': senha,
    // };

    // usuarios.add(novoUsuario);

    final resultado = await ApiService.cadastrar(
      nome: nome,
      email: email,
      senha: senha
    );

    if(resultado['sucesso'] == true){
      mostrarMensagem('Usuário cadastrado com sucesso');
      Navigator.pop(context);
      return;
    }

    
  }

  void mostrarMensagem(String mensagem){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
      )
    );
  }

  

  @override
  void dispose(){
    nomeController.dispose();
    emailController.dispose();
    senhaController.dispose();
    confirmarSenhaController.dispose();
    
    super.dispose();
  } 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Criar Usuário',
          ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),

            const Icon (Icons.person_add, size: 90,),

            const SizedBox(height: 15),

            const Text(
              'Crie uma nova conta',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: nomeController,
              decoration: const InputDecoration(
                labelText: 'Nome',
                hintText: 'Digite seu nome',
                prefixIcon: Icon(Icons.person_outline),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'E-mail',
                hintText: 'Digite seu e-mail',
                prefixIcon: Icon(Icons.email_outlined),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: senhaController,
              obscureText: esconderSenha,
              decoration: InputDecoration(
                labelText: 'Senha',
                hintText: 'Digite sua senha',
                prefixIcon: const Icon(Icons.lock_outline),
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    esconderSenha ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      esconderSenha = !esconderSenha;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: confirmarSenhaController,
              obscureText: esconderConfirmacao,
              decoration: InputDecoration(
                labelText: 'Confirmar Senha',
                hintText: 'Digite sua senha novamente',
                prefixIcon: const Icon(Icons.lock),
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    esconderConfirmacao ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      esconderConfirmacao = !esconderConfirmacao;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 25),

            ElevatedButton.icon(
              onPressed: cadastrar,
              icon: const Icon(Icons.person_add, size: 18,),
              label: const Text('Cadastrar', style: TextStyle(fontSize: 14),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8
                  ),
                  minimumSize: Size.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
              ),
            ),

            const SizedBox(height: 10),

            OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
                 },
                child: const Text('Voltar para o login'),
                )

          ],
        ),
      )
    );
  }
}