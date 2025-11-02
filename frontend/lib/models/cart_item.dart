import 'produto.dart';

// Modelo que representa um item no carrinho de compras
// Serve para armazenar o produto e a quantidade selecionada
class CartItem {
  final Produto produto;
  int quantidade;

  CartItem({required this.produto, this.quantidade = 1});

  void incrementar() {
    quantidade++;
  }

  void decrementar() {
    if (quantidade > 1) {
      quantidade--;
    }
  }

  double get precoTotal => produto.preco * quantidade;
}