import 'package:flutter/material.dart';
import '../models/produto.dart';
import '../services/api_service.dart';
import '../widgets/product_card.dart';

// Pagina de busca de produtos
// Permite ao usuario buscar produtos por nome

class SearchPage extends StatefulWidget {
  // a pagina recebe o termo de busca inicial da HomePage
  final String termoBuscaInicial;

  const SearchPage({super.key, required this.termoBuscaInicial});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final ApiService _apiService = ApiService();
  final TextEditingController _searchController = TextEditingController();
  late Future<List<Produto>> _searchFuture;

  @override
  void initState() {
    super.initState();
    // Preenche o campo de busca com o termo inicial
    _searchController.text = widget.termoBuscaInicial;
    // Inicia a busca com o termo inicial
    _buscarProdutos();
  }

  // Metodo para buscar produtos
  void _buscarProdutos() {
    setState(() {
      _searchFuture = _apiService.buscarProdutos(_searchController.text);
    });
  }

  // Limpa o controlador ao descartar o widget
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Construindo o widget principal
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Barra de busca personalizada
        title: _buildSearchBar(),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
      ),
      backgroundColor: const Color(0xFFF0FFF0),
      body: _buildResultados(),
    );
  }

  // Constroi a barra de busca
  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            const Icon(Icons.search, color: Colors.grey),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Buscar produtos orgânicos...',
                  border: InputBorder.none,
                ),
                // Permite ao usuário buscar novamente pressionando "Enter"
                onSubmitted: (termo) => _buscarProdutos(),
              ),
            ),
            ElevatedButton(
              onPressed: _buscarProdutos, // Botao tambem inicia a busca
              child: const Text('Buscar'),
            ),
          ],
        ),
      ),
    );
  }

  // Constroi a grade de resultados
  Widget _buildResultados() {
    return FutureBuilder<List<Produto>>(
      future: _searchFuture,
      builder: (context, snapshot) {
        // Estado de Carregamento
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        // Estado de Erro
        if (snapshot.hasError) {
          return Center(child: Text('Erro ao buscar produtos: ${snapshot.error}'));
        }
        // Estado de Sucesso (sem dados)
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text(
              'Nenhum produto encontrado para "${_searchController.text}"',
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
          );
        }
        
        // Estado de Sucesso (com dados)
        final produtos = snapshot.data!;
        
        // Usamos a mesma grade da HomePage para os resultados
        return GridView.builder(
          padding: const EdgeInsets.all(24.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: 0.9,
          ),
          itemCount: produtos.length,
          itemBuilder: (context, index) {
            final produto = produtos[index];
            return ProductCard(produto: produto);
          },
        );
      },
    );
  }
}