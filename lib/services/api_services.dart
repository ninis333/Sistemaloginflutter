import '../dados_mock.dart';

class ApiService {

  static Future<Map<String, dynamic>> login({
    required String email,
    required String senha,
  }) async {
    final usuario = usuarios.firstWhere(
      (item) => item['email'] == email.trim() && item['senha'] == senha,
      orElse: () => <String, String>{},
    );

    if (usuario.isEmpty) {
      return {
        'sucesso': false,
        'mensagem': 'E-mail ou senha incorretos.',
      };
    }

    return {
      'sucesso': true,
      'dados': {'usuario': usuario},
    };
  }

  static Future<Map<String, dynamic>> cadastrar({
    required String nome,
    required String email,
    required String senha,
  }) async {
    final emailExiste = usuarios.any((item) => item['email'] == email);
    if (emailExiste) {
      return {
        'sucesso': false,
        'mensagem': 'Já existe um usuário com esse e-mail.',
      };
    }

    usuarios.add({
      'nome': nome,
      'email': email,
      'senha': senha,
    });

    return {
      'sucesso': true,
      'dados': {'usuario': usuarios.last},
    };
  }
}