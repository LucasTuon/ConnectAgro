import 'package:mysql1/mysql1.dart';
import '../../application/repositories/usuario_repository.dart';
import '../../domain/usuario.dart';

class UsuarioRepositoryMysql implements IUsuarioRepository {
  final MySqlConnection _dbConnection;

  UsuarioRepositoryMysql(this._dbConnection);

  @override
  Future<void> salvar(Usuario usuario) async {
    try {
      const String query = '''
        INSERT INTO Usuarios (nome, email, senha, tipo_usuario, nome_estabelecimento, cidade, estado, foto_url)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?);
      ''';

      final tipoUsuarioString = usuario.tipoUsuario.name == 'pontoDeVenda' ? 'PONTO_DE_VENDA' : 'PRODUTOR';
      
      await _dbConnection.query(query, [
        usuario.nome,
        usuario.email,
        usuario.senha,
        tipoUsuarioString,
        usuario.nomeEstabelecimento,
        usuario.cidade,
        usuario.estado,
        usuario.fotoUrl,
      ]);
    } catch (e) {
      print('Erro ao salvar usuário: $e');
      rethrow;
    }
  }

  @override
  Future<Usuario?> buscarPorEmail(String email) async {
    try {
      const String query = 'SELECT * FROM Usuarios WHERE email = ? LIMIT 1;';

      final results = await _dbConnection.query(query, [email]);

      if (results.isEmpty) {
        return null;
      }

      final row = results.first;

      final tipoUsuario = (row['tipo_usuario'] as String).toUpperCase() == 'PRODUTOR'
          ? TipoUsuario.produtor
          : TipoUsuario.pontoDeVenda;

      return Usuario(
        id: row['id'] as int,
        nome: row['nome'] as String,
        email: row['email'] as String,
        senha: row['senha'] as String,
        tipoUsuario: tipoUsuario,
        nomeEstabelecimento: row['nome_estabelecimento'] as String?,
        cidade: row['cidade'] as String?,
        estado: row['estado'] as String?,
        fotoUrl: row['foto_url'] as String?,
      );
    } catch (e) {
      print('Erro ao buscar usuário por email: $e');
      rethrow;
    }
  }

  // --- NOVO MÉTODO ABAIXO ---
  @override
  Future<List<Usuario>> listarProdutores() async {
    try {
      const String query = "SELECT * FROM Usuarios WHERE tipo_usuario = 'PRODUTOR';";

      final results = await _dbConnection.query(query);

      // Mapeia cada linha do resultado para um objeto Usuario
      return results.map((row) {
        return Usuario(
          id: row['id'] as int,
          nome: row['nome'] as String,
          email: row['email'] as String,
          senha: row['senha'] as String,
          tipoUsuario: TipoUsuario.produtor, // Já sabemos que é produtor
          nomeEstabelecimento: row['nome_estabelecimento'] as String?,
          cidade: row['cidade'] as String?,
          estado: row['estado'] as String?,
          fotoUrl: row['foto_url'] as String?,
        );
      }).toList();
    } catch (e) {
      print('Erro ao listar produtores: $e');
      rethrow;
    }
  }
}