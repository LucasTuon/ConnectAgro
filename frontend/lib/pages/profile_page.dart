import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/produto.dart';
import '../services/api_service.dart';
import '../widgets/add_product_dialog.dart';
import '../widgets/edit_product_dialog.dart';
import 'home_page.dart';

// Pagina de perfil do usuario
// Exibe informacoes do usuario e seus produtos ou historico de compras

class ProfilePage extends StatefulWidget {
  final Map<String, dynamic> userData;
  const ProfilePage({super.key, required this.userData});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}


class _ProfilePageState extends State<ProfilePage> {
  final ApiService _apiService = ApiService();

  late Future<List<Produto>> _meusProdutosFuture;
  late Future<List<Map<String, dynamic>>> _historicoComprasFuture;

  // Inicializacao dos dados com base no tipo de usuario
  @override
  void initState() {
    super.initState();

    final String tipoUsuario = widget.userData['tipo_usuario'] ?? '';
    if (tipoUsuario == 'produtor') {
      final int produtorId = widget.userData['id'];
      _meusProdutosFuture = _apiService.listarProdutosPorProdutor(produtorId);
    } else {
      final int compradorId = widget.userData['id'];
      _historicoComprasFuture = _apiService.listarHistoricoCompras(compradorId);
    }
  }

  // Funcao para atualizar a lista de produtos
  void _fetchProdutos() {
    final int produtorId = widget.userData['id'];
    setState(() {
      _meusProdutosFuture = _apiService.listarProdutosPorProdutor(produtorId);
    });
  }

  // Mostra o dialogo para adicionar um novo produto
  void _showAddProductDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AddProductDialog(produtorId: widget.userData['id']);
      },
    );
    if (result == true) _fetchProdutos();
  }

  // Mostra o dialogo para editar um produto existente
  void _showEditProductDialog(Produto produto) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return EditProductDialog(produto: produto);
      },
    );
    if (result == true) _fetchProdutos();
  }

  // Mostra o dialogo de confirmacao para deletar um produto
  void _showDeleteConfirmationDialog(Produto produto) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Exclusão'),
          content: Text('Tem certeza de que deseja excluir o produto "${produto.nome}"?'),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancelar')),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );

    if (result == true) {
      try {
        await _apiService.deletarProduto(produto.id);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Produto excluído com sucesso!'), backgroundColor: Colors.green));
        _fetchProdutos();
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao excluir: ${e.toString()}'), backgroundColor: Colors.red));
      }
    }
  }

  // Construindo o widget principal
  @override
  Widget build(BuildContext context) {
    final String nome = widget.userData['nome'] ?? 'Usuário';
    final String tipoUsuario = widget.userData['tipo_usuario'] ?? '';
    final Color primaryGreen = Colors.green.shade700;

    return Scaffold(
      backgroundColor: const Color(0xFFF0FFF0),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
        title: Text('Perfil de $nome'),
        automaticallyImplyLeading: true,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            },
            style: TextButton.styleFrom(foregroundColor: primaryGreen),
            child: const Text('Sair'),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 40.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: tipoUsuario == 'produtor'
                ? _buildProdutorProfile(widget.userData, primaryGreen)
                : _buildPontoDeVendaProfile(widget.userData, primaryGreen),
          ),
        ),
      ),
    );
  }

  Widget _buildProdutorProfile(Map<String, dynamic> userData, Color primaryGreen) {
    final String? fotoUrl = userData['foto_url'];
    final String nome = userData['nome'] ?? 'Usuário';
    final String nomeEstabelecimento = userData['nome_estabelecimento'] ?? 'Não informado';
    final String cidade = userData['cidade'] ?? 'Não informada';
    final String estado = userData['estado'] ?? 'Não informado';

    return Column(
      children: [
        Card(
          color: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey.shade200,
                  backgroundImage: fotoUrl != null ? NetworkImage(fotoUrl) : null,
                  child: fotoUrl == null ? Icon(Icons.person, size: 50, color: Colors.grey.shade400) : null,
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(nome, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(nomeEstabelecimento, style: const TextStyle(fontSize: 16, color: Colors.grey)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.location_on, color: Colors.grey, size: 16),
                          const SizedBox(width: 4),
                          Text('$cidade, $estado', style: const TextStyle(fontSize: 14, color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.edit, size: 16),
                  label: const Text('Editar Perfil'),
                  style: OutlinedButton.styleFrom(foregroundColor: primaryGreen, side: BorderSide(color: primaryGreen)),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 40),
        Card(
          color: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Meus Produtos Cadastrados', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    ElevatedButton.icon(
                      onPressed: _showAddProductDialog,
                      icon: const Icon(Icons.add),
                      label: const Text('Adicionar Produto'),
                      style: ElevatedButton.styleFrom(backgroundColor: primaryGreen, foregroundColor: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                FutureBuilder<List<Produto>>(
                  future: _meusProdutosFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Erro ao carregar seus produtos: ${snapshot.error}'));
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text('Você ainda não cadastrou nenhum produto.'),
                      ));
                    }
                    final produtos = snapshot.data!;
                    return _buildProdutosDataTable(produtos);
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Construindo a DataTable dos produtos
  Widget _buildProdutosDataTable(List<Produto> produtos) {
    return DataTable(
      headingRowColor: MaterialStateProperty.all(const Color(0xFFF0FFF0)),
      columns: const [
        DataColumn(label: Text('Produto')),
        DataColumn(label: Text('Preço')),
        DataColumn(label: Text('Categoria')),
        DataColumn(label: Text('Estoque')),
        DataColumn(label: Text('Ações')),
      ],
      rows: produtos.map((produto) {
        return DataRow(cells: [
          DataCell(Text(produto.nome)),
          DataCell(Text('R\$ ${produto.preco.toStringAsFixed(2)} / ${produto.unidade ?? 'un'}')),
          DataCell(Text(produto.categoria)),
          DataCell(Text(produto.quantidadeEstoque.toString())),
          DataCell(Row(children: [
            IconButton(icon: Icon(Icons.edit, color: Colors.blue.shade700), onPressed: () => _showEditProductDialog(produto)),
            IconButton(icon: Icon(Icons.delete, color: Colors.red.shade700), onPressed: () => _showDeleteConfirmationDialog(produto)),
          ])),
        ]);
      }).toList(),
    );
  }

  // Construindo o perfil para ponto de venda
  Widget _buildPontoDeVendaProfile(Map<String, dynamic> userData, Color primaryGreen) {
    final String? fotoUrl = userData['foto_url'];
    final String nome = userData['nome'] ?? 'Usuário';
    final String nomeEstabelecimento = userData['nome_estabelecimento'] ?? 'Não informado';
    final String cidade = userData['cidade'] ?? 'Não informada';
    final String estado = userData['estado'] ?? 'Não informado';

    return Column(
      children: [
        Card(
          color: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey.shade200,
                  backgroundImage: fotoUrl != null ? NetworkImage(fotoUrl) : null,
                  child: fotoUrl == null ? Icon(Icons.shopping_bag, size: 50, color: Colors.grey.shade400) : null,
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(nome, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(nomeEstabelecimento, style: const TextStyle(fontSize: 16, color: Colors.grey)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.location_on, color: Colors.grey, size: 16),
                          const SizedBox(width: 4),
                          Text('$cidade, $estado', style: const TextStyle(fontSize: 14, color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.edit, size: 16),
                  label: const Text('Editar Perfil'),
                  style: OutlinedButton.styleFrom(foregroundColor: primaryGreen, side: BorderSide(color: primaryGreen)),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 40),
        Card(
          color: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Meu Histórico de Compras', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    ElevatedButton.icon(
                      onPressed: () { /* Navegar para a tela do carrinho */ },
                      icon: const Icon(Icons.shopping_cart),
                      label: const Text('Ver Carrinho'),
                      style: ElevatedButton.styleFrom(backgroundColor: primaryGreen, foregroundColor: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                FutureBuilder<List<Map<String, dynamic>>>(
                  future: _historicoComprasFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Erro ao carregar histórico: ${snapshot.error}'));
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text('Você ainda não realizou nenhuma compra.'),
                      ));
                    }
                    final compras = snapshot.data!;
                    return DataTable(
                      headingRowColor: MaterialStateProperty.all(const Color(0xFFF0FFF0)),
                      columns: const [
                        DataColumn(label: Text('Produto')),
                        DataColumn(label: Text('Vendedor')),
                        DataColumn(label: Text('Data da Compra')),
                        DataColumn(label: Text('Status')),
                        DataColumn(label: Text('Preço')),
                      ],
                      rows: compras.map((compra) {
                        final dataFormatada = DateFormat('dd/MM/yyyy').format(DateTime.parse(compra['dataCompra']));
                        return DataRow(cells: [
                          DataCell(Text(compra['nomeProduto'].toString())),
                          DataCell(Text(compra['nomeVendedor'].toString())),
                          DataCell(Text(dataFormatada)),
                          DataCell(_buildStatusChip(compra['statusEntrega'].toString())),
                          DataCell(Text('R\$ ${compra['precoTotal']}')),
                        ]);
                      }).toList(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Widget de apoio para exibir o status da compra
  Widget _buildStatusChip(String status) {
    Color color;
    String label;
    switch (status) {
      case 'ENTREGUE':
        color = Colors.green;
        label = 'Entregue';
        break;
      case 'A_CAMINHO':
        color = Colors.orange;
        label = 'A Caminho';
        break;
      default:
        color = Colors.blue;
        label = 'Em Preparação';
    }
    return Chip(
      label: Text(label),
      backgroundColor: color.withOpacity(0.2),
      labelStyle: TextStyle(color: color, fontWeight: FontWeight.bold),
      side: BorderSide.none,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
    );
  }
}