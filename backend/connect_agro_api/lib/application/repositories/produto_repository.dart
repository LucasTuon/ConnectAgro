import '../../domain/produto.dart';

abstract class IProdutoRepository {

  // Metodo para salvar um produto
  Future<void> salvar(Produto produto);

  // Metodo para listar todos os produtos
  Future<List<Produto>> listarTodos();

  // Metodo para listar produtos por ID do produtor
  Future<List<Produto>> listarPorProdutorId(int produtorId);

  // Metodo para atualizar um produto
  Future<void> atualizar(Produto produto);

  // Metodo para deletar um produto por ID
  Future<void> deletar(int id);

  // Metodo para buscar produtos por nome
  Future<List<Produto>> buscarPorNome(String termo);
  
}