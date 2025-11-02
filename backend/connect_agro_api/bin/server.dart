
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';

// Importações de Usuário e Autenticação
import 'package:connect_agro_api/application/services/cadastro_service.dart';
import 'package:connect_agro_api/application/services/login_service.dart';
import 'package:connect_agro_api/application/services/usuario_service.dart';
import 'package:connect_agro_api/infrastructure/repositories/usuario_repository_mysql.dart';
import 'package:connect_agro_api/presentation/handlers/cadastro_handler.dart';
import 'package:connect_agro_api/presentation/handlers/login_handler.dart';
import 'package:connect_agro_api/presentation/handlers/usuario_handler.dart';

// Importações de Produto
import 'package:connect_agro_api/application/services/produto_service.dart';
import 'package:connect_agro_api/infrastructure/repositories/produto_repository_mysql.dart';
import 'package:connect_agro_api/presentation/handlers/produto_handler.dart';

// Importações do Histórico de Compras
import 'package:connect_agro_api/infrastructure/repositories/compra_repository_mysql.dart';
import 'package:connect_agro_api/application/services/compra_service.dart';
import 'package:connect_agro_api/presentation/handlers/compra_handler.dart';

// Importação do Banco de Dados
import 'package:connect_agro_api/infrastructure/database/database_connection.dart';

void main() async {
  // --- Injeção de Dependência ---
  final dbConnection = await DatabaseConnection.openConnection();
  
  final usuarioRepository = UsuarioRepositoryMysql(dbConnection);
  final produtoRepository = ProdutoRepositoryMysql(dbConnection);
  final compraRepository = CompraRepositoryMysql(dbConnection);

  final cadastroService = CadastroService(usuarioRepository);
  final loginService = LoginService(usuarioRepository);
  final produtoService = ProdutoService(produtoRepository);
  final compraService = CompraService(compraRepository);
  final usuarioService = UsuarioService(usuarioRepository);
  
  final cadastroHandler = CadastroHandler(cadastroService);
  final loginHandler = LoginHandler(loginService);
  final produtoHandler = ProdutoHandler(produtoService);
  final compraHandler = CompraHandler(compraService);
  final usuarioHandler = UsuarioHandler(usuarioService);

  final app = Router();

  // --- Rotas ---
  app.post('/usuarios', cadastroHandler.cadastrarUsuario);
  app.post('/login', loginHandler.login);
  app.get('/produtores', usuarioHandler.listarProdutores);
  
  app.post('/produtos', produtoHandler.criarProduto);
  app.get('/produtos', produtoHandler.listarTodosProdutos);
  app.put('/produtos/<id>', produtoHandler.atualizarProduto);
  app.delete('/produtos/<id>', produtoHandler.deletarProduto);
  app.get('/produtores/<id>/produtos', produtoHandler.listarProdutosPorProdutor);
  
  app.get('/compradores/<id>/historico', compraHandler.listarHistorico);
  
  app.post('/compras', compraHandler.finalizarCompra);

  // --- NOVA ROTA DE BUSCA ---
  app.get('/produtos/buscar', produtoHandler.buscarProdutosPorNome);

  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(corsHeaders())
      .addHandler(app);

  final server = await io.serve(handler, 'localhost', 8080);
  print('🚀 Servidor rodando com CORS habilitado em http://${server.address.host}:${server.port}');
}