import 'package:mysql1/mysql1.dart';
import '../../domain/compra.dart';

// Repositorio para gerenciar compras no banco de dados MySQL
class CompraRepositoryMysql {
  final MySqlConnection _dbConnection;

  CompraRepositoryMysql(this._dbConnection);

  // Metodo para listar o historico de compras de um ponto de venda
  Future<List<Compra>> listarPorCompradorId(int compradorId) async {
    try {
      const String query = '''
        SELECT 
          C.id, C.data_compra, C.status_entrega, C.preco_total,
          P.nome AS nome_produto,
          V.nome AS nome_vendedor
        FROM Compras C
        JOIN Produtos P ON C.produto_id = P.id
        JOIN Usuarios V ON C.produtor_id = V.id
        WHERE C.ponto_de_venda_id = ?
        ORDER BY C.data_compra DESC;
      ''';

      final results = await _dbConnection.query(query, [compradorId]);

      return results.map((row) {
        return Compra(
          id: row['id'] as int,
          nomeProduto: row['nome_produto'] as String,
          nomeVendedor: row['nome_vendedor'] as String,
          dataCompra: row['data_compra'] as DateTime,
          statusEntrega: row['status_entrega'] as String,
          precoTotal: row['preco_total'] as double,
        );
      }).toList();
    } catch (e) {
      print('Erro ao listar histórico de compras: $e');
      rethrow;
    }
  }

  /// Salva uma lista de itens de compra dentro de uma transacao
  Future<void> salvarCompra(int pontoDeVendaId, List<Map<String, dynamic>> items) async {
    await _dbConnection.transaction((trans) async {
      for (var item in items) {
        const String query = '''
          INSERT INTO Compras 
          (ponto_de_venda_id, produto_id, produtor_id, quantidade, preco_total, status_entrega) 
          VALUES (?, ?, ?, ?, ?, 'EM_PREPARACAO');
        ''';
        
        await trans.query(query, [
          pontoDeVendaId,
          item['produto_id'],
          item['produtor_id'],
          item['quantidade'],
          item['preco_total'],
        ]);
      }
    });
  }
}