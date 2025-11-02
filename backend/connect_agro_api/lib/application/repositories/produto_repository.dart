import '../../domain/produto.dart';

abstract class IProdutoRepository {
  Future<void> salvar(Produto produto);
  Future<List<Produto>> listarTodos();
  Future<List<Produto>> listarPorProdutorId(int produtorId);
  Future<void> atualizar(Produto produto);
  Future<void> deletar(int id);

  // NOVO MÉTODO
  /// Busca produtos cujo nome corresponda ao termo de pesquisa.
  Future<List<Produto>> buscarPorNome(String termo);
}