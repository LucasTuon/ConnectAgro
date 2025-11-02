import 'dart:convert';
import 'package:shelf/shelf.dart';
import '../../application/services/compra_service.dart';

class CompraHandler {
  final CompraService _compraService;
  CompraHandler(this._compraService);

  // Manipula a requisição para listar o historico de compras (GET /compras/historico/{compradorId})
  Future<Response> listarHistorico(Request request, String compradorIdString) async {
    try {
      final int compradorId = int.parse(compradorIdString);
      final historico = await _compraService.listarHistorico(compradorId);

      final historicoJson = historico.map((compra) => {
        'id': compra.id,
        'nomeProduto': compra.nomeProduto,
        'nomeVendedor': compra.nomeVendedor,
        'dataCompra': compra.dataCompra.toIso8601String(),
        'statusEntrega': compra.statusEntrega,
        'precoTotal': compra.precoTotal,
      }).toList();

      return Response.ok(jsonEncode(historicoJson), headers: {'Content-Type': 'application/json'});
    } catch (e) {
      print('Erro no handler ao listar histórico: $e');
      return Response.internalServerError(body: 'Ocorreu um erro no servidor.');
    }
  }

  /// Manipula a requisicao para finalizar uma compra (POST /compras)
  Future<Response> finalizarCompra(Request request) async {
    try {
      final body = await request.readAsString();
      final data = jsonDecode(body) as Map<String, dynamic>;

      // Esperamos um JSON com o ID do comprador e a lista de itens
      final int pontoDeVendaId = data['ponto_de_venda_id'];
      final List<Map<String, dynamic>> items = (data['items'] as List).cast<Map<String, dynamic>>();

      if (items.isEmpty) {
        return Response.badRequest(body: 'O carrinho não pode estar vazio.');
      }

      await _compraService.salvarCompra(pontoDeVendaId, items);

      return Response.ok('Compra finalizada com sucesso e registrada no histórico!');
    } catch (e) {
      print('Erro no handler ao finalizar compra: $e');
      return Response.internalServerError(body: 'Ocorreu um erro ao processar sua compra.');
    }
  }

}