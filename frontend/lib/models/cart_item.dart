import 'produto.dart';

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