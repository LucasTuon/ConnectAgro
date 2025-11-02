import '../../domain/usuario.dart';
import '../repositories/usuario_repository.dart';

class LoginService {
  final IUsuarioRepository _usuarioRepository;

  LoginService(this._usuarioRepository);

  /// Retorna o objeto Usuario em caso de sucesso.
  /// Lanca uma excecao em caso de falha (usuario nao encontrado ou senha incorreta).
  Future<Usuario> login({
    required String email,
    required String senha,
  }) async {
    // Usa o repositorio para buscar o usuario pelo e-mail
    final usuario = await _usuarioRepository.buscarPorEmail(email);

    // Verifica se o usuario existe
    if (usuario == null) {
      throw Exception('Usuário não encontrado.');
    }

    // Verifica se a senha esta correta
    // ATENCAO: Esta é uma verificação de senha em texto plano
    // É INSEGURA e usada aqui apenas para demonstracao do funcionamento
  
    if (usuario.senha != senha) {
      throw Exception('Senha incorreta.');
    }

    // Se tudo estiver correto, retorna o usuario
    return usuario;
  }
}