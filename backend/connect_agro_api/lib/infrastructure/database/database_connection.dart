import 'package:mysql1/mysql1.dart';

// Configuracoes de conexao ao banco de dados no Docker
class DatabaseConnection {
  static final ConnectionSettings settings = ConnectionSettings(
    host: '127.0.0.1', // 'localhost' ou '127.0.0.1'
    port: 3306,
    user: 'user',
    password: 'password',
    db: 'connect_agro_db',
  );

  
  static Future<MySqlConnection> openConnection() async {
    try {
      
      return await MySqlConnection.connect(settings);
    } catch (e) { // Erro
      print('Erro ao conectar ao banco de dados: $e');
      rethrow;
    }
  }
}