import '../../domain/usuario.dart';

// Metodos que um repositorio de usuarios deve ter
abstract class IUsuarioRepository {

  // Salva um usuario no banco de dados
  Future<void> salvar(Usuario usuario);
  
  // Busca um usuario pelo email (retorna null se nao existir)
  Future<Usuario?> buscarPorEmail(String email);

  // Lista todos os usuarios que sao do tipo produtor
  Future<List<Usuario>> listarProdutores();
}