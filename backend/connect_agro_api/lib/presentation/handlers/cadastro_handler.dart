import 'dart:convert';
import 'package:shelf/shelf.dart';
import '../../application/services/cadastro_service.dart';

class CadastroHandler {
  final CadastroService _cadastroService;

  CadastroHandler(this._cadastroService);

  // A funcao que lida com o cadastro de usuario
  Future<Response> cadastrarUsuario(Request request) async {
    try {
      final body = await request.readAsString();
      if (body.isEmpty) {
        return Response.badRequest(body: 'Corpo da requisição não pode ser vazio.');
      }
      
      final data = jsonDecode(body) as Map<String, dynamic>;

      // Pegamos os campos obrigatorios do corpo da requisicao
      final nome = data['nome'] as String?;
      final email = data['email'] as String?;
      final senha = data['senha'] as String?;
      final tipoUsuario = data['tipo_usuario'] as String?;
      final nomeEstabelecimento = data['nome_estabelecimento'] as String?;
      final cidade = data['cidade'] as String?;
      final estado = data['estado'] as String?;
      
      // O campo fotoUrl eh opcional
      final fotoUrl = data['foto_url'] as String?;

      // Validacao basica dos campos obrigatorios
      if (nome == null ||
          email == null ||
          senha == null ||
          tipoUsuario == null ||
          nomeEstabelecimento == null ||
          cidade == null ||
          estado == null) {
        return Response.badRequest(body: 'Dados incompletos. Todos os campos, exceto a foto, são necessários.');
      }
      
      // Chamamos o servico para cadastrar o usuario
      await _cadastroService.cadastrarUsuario(
        nome: nome,
        email: email,
        senha: senha,
        tipoUsuario: tipoUsuario,
        nomeEstabelecimento: nomeEstabelecimento,
        cidade: cidade,
        estado: estado,
        fotoUrl: fotoUrl, // Novo
      );

      return Response(201, body: 'Usuário cadastrado com sucesso!');

    } catch (e) {
      print('Erro no handler ao cadastrar usuário: $e');
      return Response.internalServerError(body: 'Ocorreu um erro no servidor.');
    }
  }
}