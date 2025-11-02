import 'dart:convert';
import 'package:shelf/shelf.dart';
import '../../application/services/login_service.dart';

class LoginHandler {
  final LoginService _loginService;

  LoginHandler(this._loginService);

  Future<Response> login(Request request) async {
    try {
      final body = await request.readAsString();
      if (body.isEmpty) {
        return Response(400, body: 'Corpo da requisição não pode ser vazio.');
      }
      
      final data = jsonDecode(body) as Map<String, dynamic>;
      final email = data['email'] as String?;
      final senha = data['senha'] as String?;

      if (email == null || senha == null) {
        return Response(400, body: 'Dados incompletos. São necessários: email, senha.');
      }

      final usuario = await _loginService.login(email: email, senha: senha);

      // MUDANÇA: Agora retornamos todos os dados do usuário no corpo da resposta.
      final responseBody = jsonEncode({
        'id': usuario.id,
        'nome': usuario.nome,
        'email': usuario.email,
        'tipo_usuario': usuario.tipoUsuario.name, // Ex: 'produtor'
        'nome_estabelecimento': usuario.nomeEstabelecimento,
        'cidade': usuario.cidade,
        'estado': usuario.estado,
      });

      return Response.ok(responseBody, headers: {'Content-Type': 'application/json'});

    } on Exception catch (e) {
      return Response(401, body: e.toString().replaceFirst('Exception: ', ''));
    } catch (e) {
      print('Erro no handler ao fazer login: $e');
      return Response.internalServerError(body: 'Ocorreu um erro no servidor.');
    }
  }
}