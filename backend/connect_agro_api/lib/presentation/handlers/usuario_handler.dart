import 'dart:convert';
import 'package:shelf/shelf.dart';
import '../../../application/services/usuario_service.dart';

class UsuarioHandler {
  final UsuarioService _usuarioService;

  UsuarioHandler(this._usuarioService);

  /// Manipula a requisição para listar todos os produtores (GET /produtores)
  Future<Response> listarProdutores(Request request) async {
    try {
      final produtores = await _usuarioService.listarProdutores();

      // Transforma a lista de objetos Usuario em uma lista de Mapas (JSON)
      final produtoresJson = produtores.map((produtor) => {
            'id': produtor.id,
            'nome': produtor.nome,
            'nome_estabelecimento': produtor.nomeEstabelecimento,
            'cidade': produtor.cidade,
            'estado': produtor.estado,
            'foto_url': produtor.fotoUrl,
            // Não enviamos a senha ou outras informações sensíveis
          }).toList();

      return Response.ok(
        jsonEncode(produtoresJson),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      print('Erro no handler ao listar produtores: $e');
      return Response.internalServerError(body: 'Ocorreu um erro no servidor.');
    }
  }
}