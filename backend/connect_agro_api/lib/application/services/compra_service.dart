import '../../domain/compra.dart';
import '../../infrastructure/repositories/compra_repository_mysql.dart';

class CompraService {
  final CompraRepositoryMysql _compraRepository;
  CompraService(this._compraRepository);

  Future<List<Compra>> listarHistorico(int compradorId) async {
    return await _compraRepository.listarPorCompradorId(compradorId);
  }

  // Simula a compra de produtos por um ponto de venda
  // Aqui poderiam ter logicas adicionais, como verificacao de estoque, processamento de pagamento, etc
  Future<void> salvarCompra(int pontoDeVendaId, List<Map<String, dynamic>> items) async {
    try {
      await _compraRepository.salvarCompra(pontoDeVendaId, items);
    } catch (e) {
      print('Erro no serviço ao salvar compra: $e');
      rethrow;
    }
  }
}