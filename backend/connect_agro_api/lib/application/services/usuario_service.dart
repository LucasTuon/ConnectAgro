import '../../domain/usuario.dart';
import '../repositories/usuario_repository.dart';

class UsuarioService {
  final IUsuarioRepository _usuarioRepository;

  UsuarioService(this._usuarioRepository);

  /// Solicita a lista de todos os usuários que são produtores.
  Future<List<Usuario>> listarProdutores() async {
    try {
      return await _usuarioRepository.listarProdutores();
    } catch (e) {
      print('Erro no serviço ao listar produtores: $e');
      rethrow;
    }
  }
}