import 'dart:convert';
import 'package:shelf/shelf.dart';
import '../../application/services/produto_service.dart';
import '../../domain/produto.dart';

class ProdutoHandler {
  final ProdutoService _produtoService;

  ProdutoHandler(this._produtoService);

  Future<Response> criarProduto(Request request) async {
    try {
      final body = await request.readAsString();
      final data = jsonDecode(body) as Map<String, dynamic>;

      // Lógica para converter os dados para a entidade Produto
      final novoProduto = Produto(
        nome: data['nome'],
        descricao: data['descricao'],
        preco: (data['preco'] as num).toDouble(),
        unidade: data['unidade'],
        imagemUrl: data['imagemUrl'],
        categoria: CategoriaProduto.values.firstWhere((e) => e.name == data['categoria']),
        produtorId: data['produtorId'],
        quantidadeEstoque: data['quantidade_estoque'],
        dataColheita: data['data_colheita'] != null ? DateTime.parse(data['data_colheita']) : null,
      );

      await _produtoService.criarProduto(
        nome: novoProduto.nome,
        descricao: novoProduto.descricao,
        preco: novoProduto.preco,
        unidade: novoProduto.unidade,
        imagemUrl: novoProduto.imagemUrl,
        categoria: novoProduto.categoria,
        produtorId: novoProduto.produtorId,
        quantidadeEstoque: novoProduto.quantidadeEstoque,
        dataColheita: novoProduto.dataColheita,
      );

      return Response(201, body: 'Produto cadastrado com sucesso!');
    } catch (e) {
      print('Erro no handler ao criar produto: $e');
      return Response.internalServerError(body: 'Ocorreu um erro no servidor.');
    }
  }

  Future<Response> listarTodosProdutos(Request request) async {
    try {
      final produtos = await _produtoService.listarTodosProdutos();
      final produtosJson = _mapearListaProdutosParaJson(produtos);
      return Response.ok(
        jsonEncode(produtosJson),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      print('Erro no handler ao listar todos produtos: $e');
      return Response.internalServerError(body: 'Ocorreu um erro no servidor.');
    }
  }

  Future<Response> listarProdutosPorProdutor(Request request, String produtorIdString) async {
    try {
      final int produtorId = int.parse(produtorIdString);
      final produtos = await _produtoService.listarProdutosPorProdutor(produtorId);
      final produtosJson = _mapearListaProdutosParaJson(produtos);
      return Response.ok(
        jsonEncode(produtosJson),
        headers: {'Content-Type': 'application/json'},
      );
    } on FormatException {
      return Response.badRequest(body: 'O ID do produtor na URL deve ser um número.');
    } catch (e) {
      print('Erro no handler ao listar produtos do produtor: $e');
      return Response.internalServerError(body: 'Ocorreu um erro no servidor.');
    }
  }

  Future<Response> atualizarProduto(Request request, String id) async {
    try {
      final int produtoId = int.parse(id);
      final body = await request.readAsString();
      final data = jsonDecode(body) as Map<String, dynamic>;
      
      await _produtoService.atualizarProduto(produtoId, data);
      return Response.ok('Produto atualizado com sucesso!');
    } catch (e) {
      print('Erro no handler ao atualizar produto: $e');
      return Response.internalServerError(body: 'Ocorreu um erro no servidor.');
    }
  }

  Future<Response> deletarProduto(Request request, String id) async {
    try {
      final int produtoId = int.parse(id);
      await _produtoService.deletarProduto(produtoId);
      return Response.ok('Produto deletado com sucesso!');
    } catch (e) {
      print('Erro no handler ao deletar produto: $e');
      return Response.internalServerError(body: 'Ocorreu um erro no servidor.');
    }
  }

  // --- NOVO MÉTODO ABAIXO ---
  /// Manipula a requisição para buscar produtos por nome (GET /produtos/buscar?q=...)
  Future<Response> buscarProdutosPorNome(Request request) async {
    try {
      // 1. Lê o parâmetro de consulta 'q' da URL.
      final String? termoBusca = request.url.queryParameters['q'];

      if (termoBusca == null || termoBusca.isEmpty) {
        return Response.badRequest(body: "Parâmetro de busca 'q' é obrigatório.");
      }

      // 2. Chama o serviço com o termo de busca.
      final produtos = await _produtoService.buscarProdutosPorNome(termoBusca);
      
      // 3. Mapeia e retorna os resultados.
      final produtosJson = _mapearListaProdutosParaJson(produtos);
      return Response.ok(
        jsonEncode(produtosJson),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      print('Erro no handler ao buscar produtos: $e');
      return Response.internalServerError(body: 'Ocorreu um erro no servidor.');
    }
  }

  // --- NOVO MÉTODO AUXILIAR PRIVADO ---
  /// Mapeia uma lista de objetos Produto para o formato JSON.
  List<Map<String, dynamic>> _mapearListaProdutosParaJson(List<Produto> produtos) {
    return produtos.map((produto) => {
      'id': produto.id,
      'nome': produto.nome,
      'descricao': produto.descricao,
      'preco': produto.preco,
      'unidade': produto.unidade,
      'imagemUrl': produto.imagemUrl,
      'categoria': produto.categoria.name,
      'quantidade_estoque': produto.quantidadeEstoque,
      'avaliacao_media': produto.avaliacaoMedia,
      'total_avaliacoes': produto.totalAvaliacoes,
      'data_colheita': produto.dataColheita?.toIso8601String(),
      'produtorId': produto.produtorId,
    }).toList();
  }
}