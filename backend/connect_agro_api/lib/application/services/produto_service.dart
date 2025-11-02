import '../../domain/produto.dart';
import '../repositories/produto_repository.dart';

class ProdutoService {
  final IProdutoRepository _produtoRepository;

  ProdutoService(this._produtoRepository);

  Future<void> criarProduto({
    required String nome,
    required String descricao,
    required double preco,
    String? unidade,
    required String imagemUrl,
    required CategoriaProduto categoria,
    required int produtorId,
    int? quantidadeEstoque,
    DateTime? dataColheita,
  }) async {
    try {
      final novoProduto = Produto(
        nome: nome,
        descricao: descricao,
        preco: preco,
        unidade: unidade,
        imagemUrl: imagemUrl,
        categoria: categoria,
        produtorId: produtorId,
        quantidadeEstoque: quantidadeEstoque,
        dataColheita: dataColheita,
      );

      await _produtoRepository.salvar(novoProduto);
    } catch (e) {
      print('Erro no serviço ao criar produto: $e');
      rethrow;
    }
  }

  Future<List<Produto>> listarTodosProdutos() async {
    try {
      return await _produtoRepository.listarTodos();
    } catch (e) {
      print('Erro no serviço ao listar produtos: $e');
      rethrow;
    }
  }
  
  Future<List<Produto>> listarProdutosPorProdutor(int produtorId) async {
    try {
      return await _produtoRepository.listarPorProdutorId(produtorId);
    } catch (e) {
      print('Erro no serviço ao listar produtos do produtor: $e');
      rethrow;
    }
  }
  
  Future<void> atualizarProduto(int id, Map<String, dynamic> data) async {
    // Para simplificar, estamos recriando o objeto. Em um sistema maior,
    // buscaríamos o produto original primeiro.
    final produto = Produto(
      id: id,
      nome: data['nome'],
      descricao: data['descricao'],
      preco: (data['preco'] as num).toDouble(),
      unidade: data['unidade'],
      imagemUrl: data['imagemUrl'],
      categoria: CategoriaProduto.values.firstWhere((e) => e.name == data['categoria']),
      quantidadeEstoque: data['quantidade_estoque'],
      dataColheita: data['data_colheita'] != null ? DateTime.parse(data['data_colheita']) : null,
      produtorId: 0, // O produtorId não é atualizado, então 0 é um placeholder
    );
    await _produtoRepository.atualizar(produto);
  }

  Future<void> deletarProduto(int id) async {
    await _produtoRepository.deletar(id);
  }

  // --- NOVO MÉTODO ABAIXO ---
  /// Solicita a busca de produtos por nome.
  Future<List<Produto>> buscarProdutosPorNome(String termo) async {
    try {
      return await _produtoRepository.buscarPorNome(termo);
    } catch (e) {
      print('Erro no serviço ao buscar produtos por nome: $e');
      rethrow;
    }
  }
}