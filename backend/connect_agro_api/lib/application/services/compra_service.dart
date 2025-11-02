import '../../domain/compra.dart';
import '../../infrastructure/repositories/compra_repository_mysql.dart';

class CompraService {
  final CompraRepositoryMysql _compraRepository;
  CompraService(this._compraRepository);

  Future<List<Compra>> listarHistorico(int compradorId) async {
    return await _compraRepository.listarPorCompradorId(compradorId);
  }

  // --- NOVO MÉTODO ABAIXO ---
  /// Orquestra a finalização de uma compra.
  Future<void> salvarCompra(int pontoDeVendaId, List<Map<String, dynamic>> items) async {
    try {
      // Aqui poderíamos ter lógicas de negócio, como validar estoque, etc.
      // Por enquanto, apenas repassamos para o repositório.
      await _compraRepository.salvarCompra(pontoDeVendaId, items);
    } catch (e) {
      print('Erro no serviço ao salvar compra: $e');
      rethrow;
    }
  }
}