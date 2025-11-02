import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart'; // 1. Importe o AuthService
import '../services/cart_service.dart';
import 'profile_page.dart'; // 2. Importe a ProfilePage para o redirecionamento

// MUDANÇA 3: Convertemos para StatefulWidget para gerenciar o _isLoading
class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final ApiService _apiService = ApiService();
  final CartService _cartService = CartService();
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  // MUDANÇA 4: Lógica para finalizar a compra
  Future<void> _handleFinalizarCompra() async {
    // 1. Verifica se o usuário está logado
    if (!_authService.isLoggedIn) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Você precisa estar logado para finalizar a compra.'), backgroundColor: Colors.red),
      );
      return;
    }

    // 2. Pega os dados necessários
    final int compradorId = _authService.currentUser!['id'];
    final List<Map<String, dynamic>> itemsParaApi = _cartService.items.map((item) {
      return {
        'produto_id': item.produto.id,
        'produtor_id': item.produto.produtorId,
        'quantidade': item.quantidade,
        'preco_total': item.precoTotal,
      };
    }).toList();

    setState(() { _isLoading = true; });

    try {
      // 3. Chama a API
      await _apiService.finalizarCompra(compradorId, itemsParaApi);

      if (!mounted) return;

      // 4. Limpa o carrinho no front-end
      _cartService.clearCart();

      // 5. Redireciona para o Perfil
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Compra finalizada com sucesso!'), backgroundColor: Colors.green));
      
      // Usamos pushReplacement para que o usuário não possa "voltar" para o carrinho vazio
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => ProfilePage(userData: _authService.currentUser!)),
      );

    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao finalizar compra: ${e.toString()}'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) {
        setState(() { _isLoading = false; });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryGreen = Colors.green.shade700;
    
    // MUDANÇA 5: O AnimatedBuilder agora está dentro do build de um StatefulWidget
    return AnimatedBuilder(
      animation: _cartService,
      builder: (context, child) {
        final List<CartItem> items = _cartService.items;
        double total = items.fold(0, (sum, item) => sum + item.precoTotal);

        return Scaffold(
          appBar: AppBar(
            title: const Text('Meu Carrinho'),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black87,
            elevation: 1,
          ),
          backgroundColor: const Color(0xFFF0FFF0),
          body: Column(
            children: [
              Expanded(
                child: items.isEmpty
                    ? const Center(
                        child: Text(
                          'Seu carrinho está vazio.',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16.0),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return _buildCartItem(item, primaryGreen);
                        },
                      ),
              ),
              if (items.isNotEmpty)
                _buildSummary(total, primaryGreen),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCartItem(CartItem item, Color primaryGreen) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.produto.nome, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(
                    'R\$ ${item.produto.preco.toStringAsFixed(2)} / ${item.produto.unidade ?? 'un'}',
                    style: TextStyle(fontSize: 16, color: primaryGreen, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(icon: const Icon(Icons.remove_circle_outline), onPressed: () {
                  _cartService.updateItemQuantity(item, item.quantidade - 1);
                }),
                Text(item.quantidade.toString(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(icon: Icon(Icons.add_circle_outline, color: primaryGreen), onPressed: () {
                  _cartService.updateItemQuantity(item, item.quantidade + 1);
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummary(double total, Color primaryGreen) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -2))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Total:', style: TextStyle(fontSize: 18, color: Colors.grey)),
              Text('R\$ ${total.toStringAsFixed(2)}', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: primaryGreen)),
            ],
          ),
          ElevatedButton(
            // MUDANÇA 6: Conectamos a lógica ao botão
            onPressed: _isLoading ? null : _handleFinalizarCompra,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryGreen,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            // MUDANÇA 7: Mostra um loading ou o texto
            child: _isLoading 
                ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3)) 
                : const Text('Finalizar Compra'),
          ),
        ],
      ),
    );
  }
}