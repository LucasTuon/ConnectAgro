import 'package:mysql1/mysql1.dart';
import '../../application/repositories/produto_repository.dart';
import '../../domain/produto.dart';

class ProdutoRepositoryMysql implements IProdutoRepository {
  final MySqlConnection _dbConnection;

  ProdutoRepositoryMysql(this._dbConnection);

  @override
  Future<void> salvar(Produto produto) async {
    try {
      const String query = '''
        INSERT INTO Produtos (nome, descricao, preco, unidade, imagem_url, categoria, produtor_id, quantidade_estoque, data_colheita)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?);
      ''';
      await _dbConnection.query(query, [
        produto.nome,
        produto.descricao,
        produto.preco,
        produto.unidade,
        produto.imagemUrl,
        produto.categoria.name.toUpperCase(),
        produto.produtorId,
        produto.quantidadeEstoque,
        produto.dataColheita,
      ]);
    } catch (e) {
      print('Erro ao salvar produto: $e');
      rethrow;
    }
  }

  @override
  Future<List<Produto>> listarTodos() async {
    try {
      const String query = 'SELECT * FROM Produtos ORDER BY data_criacao DESC;';
      final results = await _dbConnection.query(query);
      return _mapearResultadosParaProdutos(results);
    } catch (e) {
      print('Erro ao listar todos os produtos: $e');
      rethrow;
    }
  }

  @override
  Future<List<Produto>> listarPorProdutorId(int produtorId) async {
    try {
      const String query = 'SELECT * FROM Produtos WHERE produtor_id = ? ORDER BY data_criacao DESC;';
      final results = await _dbConnection.query(query, [produtorId]);
      return _mapearResultadosParaProdutos(results);
    } catch (e) {
      print('Erro ao listar produtos por produtor: $e');
      rethrow;
    }
  }

  @override
  Future<void> atualizar(Produto produto) async {
    try {
      const String query = '''
        UPDATE Produtos SET 
        nome = ?, descricao = ?, preco = ?, unidade = ?, imagem_url = ?, 
        categoria = ?, quantidade_estoque = ?, data_colheita = ?
        WHERE id = ?;
      ''';
      await _dbConnection.query(query, [
        produto.nome,
        produto.descricao,
        produto.preco,
        produto.unidade,
        produto.imagemUrl,
        produto.categoria.name.toUpperCase(),
        produto.quantidadeEstoque,
        produto.dataColheita,
        produto.id,
      ]);
    } catch (e) {
      print('Erro ao atualizar produto: $e');
      rethrow;
    }
  }

  @override
  Future<void> deletar(int id) async {
    try {
      const String query = 'DELETE FROM Produtos WHERE id = ?;';
      await _dbConnection.query(query, [id]);
    } catch (e) {
      print('Erro ao deletar produto: $e');
      rethrow;
    }
  }

  // --- NOVO MÉTODO ABAIXO ---
  @override
  Future<List<Produto>> buscarPorNome(String termo) async {
    try {
      // Usamos 'LIKE' com '%' para buscar nomes que contenham o termo.
      const String query = 'SELECT * FROM Produtos WHERE nome LIKE ?;';
      
      // Formatamos o termo de busca para '%termo%'
      final results = await _dbConnection.query(query, ['%$termo%']);
      
      return _mapearResultadosParaProdutos(results);
    } catch (e) {
      print('Erro ao buscar produtos por nome: $e');
      rethrow;
    }
  }

  // --- NOVO MÉTODO AUXILIAR PRIVADO ---
  /// Mapeia os resultados de uma query (Results) para uma lista de Objetos Produto.
  /// Isso evita a repetição de código que estávamos tendo.
  List<Produto> _mapearResultadosParaProdutos(Results results) {
    return results.map((row) {
      final categoria = CategoriaProduto.values.firstWhere(
        (e) => e.name.toUpperCase() == (row['categoria'] as String).toUpperCase(),
      );
      return Produto(
        id: row['id'] as int,
        nome: row['nome'] as String,
        descricao: (row['descricao'] as Blob?)?.toString() ?? '',
        preco: row['preco'] as double,
        unidade: row['unidade'] as String?,
        imagemUrl: row['imagem_url'] as String? ?? '',
        categoria: categoria,
        quantidadeEstoque: row['quantidade_estoque'] as int? ?? 0,
        avaliacaoMedia: (row['avaliacao_media'] as double?) ?? 0.0,
        totalAvaliacoes: row['total_avaliacoes'] as int? ?? 0,
        dataColheita: row['data_colheita'] as DateTime?,
        produtorId: row['produtor_id'] as int,
      );
    }).toList();
  }
}