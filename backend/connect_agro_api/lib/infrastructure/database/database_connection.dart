import 'package:mysql1/mysql1.dart';

// Configuracoes de conexao ao banco de dados no Docker
class DatabaseConnection {
  static final ConnectionSettings settings = ConnectionSettings(
    host: '127.0.0.1',
    port: 3306,
    user: 'user',
    password: 'password',
    db: 'connect_agro_db',
  );

  // Metodo para abrir a conexao com o banco de dados
  static Future<MySqlConnection> openConnection() async {
    try {
      
      return await MySqlConnection.connect(settings);
    } catch (e) { 
      print('Erro ao conectar ao banco de dados: $e');
      rethrow;
    }
  }
}