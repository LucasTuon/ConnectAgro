import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/produto.dart';
import '../models/usuario.dart';

// Servico responsável por interagir com a API backend
// Fornece metodos para listar produtos, cadastrar usuarios, login, etc

class ApiService {
  final String _baseUrl = 'http://localhost:8080';

  Future<List<Produto>> listarProdutos() async {
    final response = await http.get(Uri.parse('$_baseUrl/produtos'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Produto.fromJson(json)).toList();
    } else {
      throw Exception('Falha ao carregar os produtos da API.');
    }
  }

  // Metodo para cadastrar um novo usuario
  Future<void> cadastrarUsuario({
    required String nome,
    required String email,
    required String senha,
    required String nomeEstabelecimento,
    required String cidade,
    required String estado,
    required String tipoUsuario,
    String? fotoUrl,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/usuarios'),
      headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(<String, String?>{
        'nome': nome,
        'email': email,
        'senha': senha,
        'nome_estabelecimento': nomeEstabelecimento,
        'cidade': cidade,
        'estado': estado,
        'tipo_usuario': tipoUsuario,
        'foto_url': fotoUrl,
      }),
    );
    if (response.statusCode != 201) {
      throw Exception('Falha ao cadastrar usuário: ${response.body}');
    }
  }
  
  // Metodo para login de usuario
  Future<Map<String, dynamic>> login({
    required String email,
    required String senha,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/login'),
      headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(<String, String>{'email': email, 'senha': senha}),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(response.body);
    }
  }
  
  // Metodo para listar produtos por ID do produtor
  Future<List<Produto>> listarProdutosPorProdutor(int produtorId) async {
    final response = await http.get(Uri.parse('$_baseUrl/produtores/$produtorId/produtos'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Produto.fromJson(json)).toList();
    } else {
      throw Exception('Falha ao carregar os produtos do produtor.');
    }
  }
  
  // Metodo para cadastrar um novo produto
  Future<void> cadastrarProduto({
    required String nome,
    required String descricao,
    required double preco,
    required String unidade,
    required int estoque,
    required String categoria,
    required String imagemUrl,
    required int produtorId,
    DateTime? dataColheita,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/produtos'),
      headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(<String, dynamic>{
        'nome': nome,
        'descricao': descricao,
        'preco': preco,
        'unidade': unidade,
        'quantidade_estoque': estoque,
        'categoria': categoria,
        'imagemUrl': imagemUrl,
        'produtorId': produtorId,
        'data_colheita': dataColheita?.toIso8601String(),
      }),
    );
    if (response.statusCode != 201) {
      throw Exception('Falha ao cadastrar produto: ${response.body}');
    }
  }

  // Metodo para atualizar um produto
  Future<void> atualizarProduto(int id, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/produtos/$id'),
      headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(data),
    );
    if (response.statusCode != 200) {
      throw Exception('Falha ao atualizar produto: ${response.body}');
    }
  }

  // Metodo para deletar um produto
  Future<void> deletarProduto(int id) async {
    final response = await http.delete(Uri.parse('$_baseUrl/produtos/$id'));
    if (response.statusCode != 200) {
      throw Exception('Falha ao deletar produto: ${response.body}');
    }
  }
  
  // Metodo para listar o historico de compras de um comprador
  Future<List<Map<String, dynamic>>> listarHistoricoCompras(int compradorId) async {
    final response = await http.get(Uri.parse('$_baseUrl/compradores/$compradorId/historico'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Falha ao carregar o histórico de compras.');
    }
  }

  // Metodo para listar todos os produtores
  Future<List<Usuario>> listarProdutores() async {
    final response = await http.get(Uri.parse('$_baseUrl/produtores'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Usuario.fromJson(json)).toList();
    } else {
      throw Exception('Falha ao carregar produtores da API.');
    }
  }

  /// Busca produtos na API com base em um termo de pesquisa
  Future<List<Produto>> buscarProdutos(String termo) async {
    // Codifica o termo de busca para ser seguro em uma URL (ex: "Tomate Orgânico" -> "Tomate%20Orgânico")
    final String termoCodificado = Uri.encodeComponent(termo);
    final response = await http.get(Uri.parse('$_baseUrl/produtos/buscar?q=$termoCodificado'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Produto.fromJson(json)).toList();
    } else {
      throw Exception('Falha ao buscar produtos.');
    }
  }

  // Metodo para finalizar uma compra
  Future<void> finalizarCompra(int pontoDeVendaId, List<Map<String, dynamic>> items) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/compras'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      // Monta o JSON do corpo da requisicao
      body: jsonEncode(<String, dynamic>{
        'ponto_de_venda_id': pontoDeVendaId,
        'items': items,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Falha ao finalizar a compra: ${response.body}');
    }
  }

}