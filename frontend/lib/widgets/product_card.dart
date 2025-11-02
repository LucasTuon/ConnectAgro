import 'package:flutter/material.dart';
import '../models/produto.dart';
import '../services/cart_service.dart'; 

// Card de produto para exibir na grade de produtos
// Mostra imagem, nome, descricao, avaliacao, estoque, preco e botao de adicionar ao carrinho

class ProductCard extends StatelessWidget {
  final Produto produto;

  const ProductCard({super.key, required this.produto});

  @override
  Widget build(BuildContext context) {
    const Color primaryGreen = Color.fromARGB(255, 40, 106, 41);

    return Card(
      color: Colors.white,
      elevation: 2,
      clipBehavior: Clip.antiAlias, // Garante que a imagem respeite as bordas
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Image.network(
              produto.imagemUrl,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const Center(
                child: Icon(Icons.error, color: Colors.grey),
              ),
            ),
          ),

          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    produto.nome,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: primaryGreen),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    produto.descricao,
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(), // Empurra o conteudo abaixo para o fundo
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        produto.avaliacaoMedia.toStringAsFixed(1),
                        style: const TextStyle(fontSize: 12, color: Colors.black87, fontWeight: FontWeight.bold),
                      ),
                      Text(' (${produto.totalAvaliacoes} avaliações)', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    produto.quantidadeEstoque > 0 ? 'Em estoque' : 'Fora de estoque',
                    style: TextStyle(fontSize: 14, color: produto.quantidadeEstoque > 0 ? Colors.grey : Colors.red),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'R\$ ${produto.preco.toStringAsFixed(2)}/${produto.unidade ?? 'un'}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          // Pega a instância global do serviço
                          final cartService = CartService();
                          // Adiciona o produto deste card
                          cartService.addToCart(produto);
                          
                          // Mostra um feedback visual para o usuário
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${produto.nome} adicionado ao carrinho!'),
                              backgroundColor: Colors.green,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        icon: const Icon(Icons.add_shopping_cart, size: 16),
                        label: const Text('Adicionar'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}