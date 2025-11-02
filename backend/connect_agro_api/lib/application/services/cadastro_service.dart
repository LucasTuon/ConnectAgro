import '../../domain/usuario.dart';
import '../repositories/usuario_repository.dart';

class CadastroService {
  final IUsuarioRepository _usuarioRepository;

  CadastroService(this._usuarioRepository);

  /// Executa o caso de uso de cadastrar um novo usuário.
  Future<void> cadastrarUsuario({
    required String nome,
    required String email,
    required String senha,
    required String tipoUsuario,
    required String nomeEstabelecimento,
    required String cidade,
    required String estado,
    String? fotoUrl,
  }) async {
    try {
      final tipo = tipoUsuario.toLowerCase() == 'produtor'
          ? TipoUsuario.produtor
          : TipoUsuario.pontoDeVenda;

      // Passamos os novos dados ao criar o objeto Usuario.
      final novoUsuario = Usuario(
        nome: nome,
        email: email,
        senha: senha,
        tipoUsuario: tipo,
        nomeEstabelecimento: nomeEstabelecimento,
        cidade: cidade,
        estado: estado,
        fotoUrl: fotoUrl, // NOVO
      );

      await _usuarioRepository.salvar(novoUsuario);
    } catch (e) {
      print('Erro no serviço ao tentar cadastrar usuário: $e');
      rethrow;
    }
  }
}