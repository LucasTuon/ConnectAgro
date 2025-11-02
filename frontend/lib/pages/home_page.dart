import 'package:flutter/material.dart';
import '../models/produto.dart';
import '../models/usuario.dart';
import '../services/api_service.dart';
import '../widgets/app_footer.dart';
import '../widgets/category_card.dart';
import '../widgets/centered_constrained_view.dart';
import '../widgets/hero_banner.dart';
import '../widgets/product_card.dart';
import '../widgets/producer_card.dart';
import '../widgets/stats_banner.dart';
import 'auth/login_dialog.dart';
import 'cart_page.dart';
import 'search_page.dart'; 

// Pagina inicial do aplicativo
// Exibe banners, categorias, produtos em destaque e produtores verificados

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiService _apiService = ApiService();
  late Future<List<Produto>> _produtosFuture;
  late Future<List<Usuario>> _produtoresFuture;
  
  // Controller para a barra de busca
  final TextEditingController _searchController = TextEditingController();

  int _visibleProductCount = 4;

  @override
  void initState() {
    super.initState();
    _produtosFuture = _apiService.listarProdutos();
    _produtoresFuture = _apiService.listarProdutores();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Funcao que navega para a página de busca
  void _navigateToSearchPage() {
    if (_searchController.text.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchPage(termoBuscaInicial: _searchController.text),
        ),
      );
    }
  }

  // Construindo o widget principal
  @override
  Widget build(BuildContext context) {
    const Color lightGreenBackground = Color(0xFFF0FFF0);
    const Color whiteBackground = Colors.white;
    const double standardSectionHeight = 550.0;

    return Scaffold(
      backgroundColor: whiteBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          'ConnectAgro',
          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(onPressed: () {}, child: const Text('Produtos')),
          TextButton(onPressed: () {}, child: const Text('Vendedores')),
          TextButton(onPressed: () {}, child: const Text('Sobre')),
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.green),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.person, color: Colors.green),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const LoginDialog();
                },
              );
            },
          ),
          const SizedBox(width: 24),
        ],
      ),
      body: ListView(
        children: [
          // Passe o controller e a funcao para o HeroBanner
          HeroBanner(
            searchController: _searchController,
            onSearchPressed: _navigateToSearchPage,
          ),
          Container(
            height: standardSectionHeight,
            color: whiteBackground,
            child: _buildSection(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSectionTitle(
                    'Explore por Categoria',
                    'Encontre exatamente o que você precisa em nossas categorias cuidadosamente organizadas',
                    titleColor: const Color.fromARGB(255, 40, 106, 41),
                    subtitleColor: const Color.fromARGB(255, 53, 139, 54),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Expanded(child: CategoryCard(title: 'Vegetais', subtitle: 'Verduras e legumes frescos', imageUrl: 'https://images.unsplash.com/photo-1597362925123-77861d3fbac7?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=1170', productCount: '240+ produtos')),
                      Expanded(child: CategoryCard(title: 'Frutas', subtitle: 'Frutas da estação', imageUrl: 'https://images.unsplash.com/photo-1610832958506-aa56368176cf?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80', productCount: '180+ produtos')),
                      Expanded(child: CategoryCard(title: 'Ervas e Especiarias', subtitle: 'Temperos naturais', imageUrl: 'https://images.unsplash.com/photo-1532091710512-26fd3b2dcf16?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=687', productCount: '95+ produtos')),
                      Expanded(child: CategoryCard(title: 'Cereais e Grãos', subtitle: 'Grãos integrais', imageUrl: 'https://plus.unsplash.com/premium_photo-1664392163836-0129faa6d5f6?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=751', productCount: '65+ produtos')),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const StatsBanner(),
          Container(
            color: whiteBackground,
            child: _buildSection(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSectionTitle(
                    'Produtos em Destaque',
                    'Produtos frescos e orgânicos selecionados especialmente para você',
                    titleColor: const Color.fromARGB(255, 40, 106, 41),
                    subtitleColor: const Color.fromARGB(255, 53, 139, 54),
                  ),
                  const SizedBox(height: 20),
                  FutureBuilder<List<Produto>>(
                    future: _produtosFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text('Erro ao carregar produtos: ${snapshot.error}'));
                      }
                      if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                        final produtos = snapshot.data!;
                        final totalProducts = produtos.length;
                        return Column(
                          children: [
                            GridView.builder(
                              itemCount: _visibleProductCount > totalProducts ? totalProducts : _visibleProductCount,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                crossAxisSpacing: 20,
                                mainAxisSpacing: 20,
                                childAspectRatio: 0.9,
                              ),
                              itemBuilder: (context, index) {
                                final produto = produtos[index];
                                return ProductCard(produto: produto);
                              },
                            ),
                            const SizedBox(height: 30),
                            if (_visibleProductCount < totalProducts)
                              OutlinedButton(
                                onPressed: () {
                                  setState(() { _visibleProductCount += 4; });
                                },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.green.shade700,
                                  side: BorderSide(color: Colors.green.shade700, width: 2),
                                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                                ),
                                child: const Text('Ver Mais Produtos'),
                              ),
                          ],
                        );
                      }
                      return const Center(child: Text('Nenhum produto cadastrado ainda.'));
                    },
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: standardSectionHeight,
            color: lightGreenBackground,
            child: _buildSection(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSectionTitle('Nossos Produtores Verificados', 'Conheça os agricultores comprometidos'),
                  const SizedBox(height: 20),
                  FutureBuilder<List<Usuario>>(
                    future: _produtoresFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text('Erro ao carregar produtores: ${snapshot.error}'));
                      }
                      if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                        final produtores = snapshot.data!;
                        return SizedBox(
                          height: 350,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            clipBehavior: Clip.none,
                            padding: const EdgeInsets.symmetric(horizontal: 24.0),
                            itemCount: produtores.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 20),
                                child: ProducerCard(produtor: produtores[index]),
                              );
                            },
                          ),
                        );
                      }
                      return const Center(child: Text('Nenhum produtor encontrado.'));
                    },
                  ),
                ],
              ),
            ),
          ),
          const AppFooter(),
        ],
      ),
    );
  }

  Widget _buildSection({required Widget child}) {
    return CenteredConstrainedView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: child,
      ),
    );
  }

  Widget _buildSectionTitle(String title, String subtitle, {Color? titleColor, Color? subtitleColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: titleColor),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(fontSize: 16, color: subtitleColor ?? Colors.grey),
          ),
        ],
      ),
    );
  }
}