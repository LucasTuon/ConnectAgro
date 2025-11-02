import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../models/produto.dart';

// MUDANÇA 1: Trocamos o notificador para ChangeNotifier
class CartService extends ChangeNotifier {
  // --- Padrão Singleton: Garante que só exista UM cérebro do carrinho ---
  static final CartService _instance = CartService._internal();
  factory CartService() {
    return _instance;
  }
  CartService._internal();
  // ------------------------------------------------------------------

  // MUDANÇA 2: A lista de itens agora é privada.
  final List<CartItem> _items = [];

  // MUDANÇA 3: Criamos um "getter" público para que os widgets possam ler a lista.
  List<CartItem> get items => _items;

  // Método para adicionar um produto ao carrinho
  void addToCart(Produto produto) {
    // Verifica se o item já existe no carrinho
    for (var item in _items) {
      if (item.produto.id == produto.id) {
        item.incrementar();
        // MUDANÇA 4: Agora sim, chamamos notifyListeners() para avisar a UI.
        notifyListeners(); 
        return;
      }
    }

    // Se não encontrou, adiciona um novo item
    _items.add(CartItem(produto: produto));
    notifyListeners();
  }

  // Método para remover um item do carrinho
  void removeFromCart(CartItem item) {
    _items.remove(item);
    notifyListeners();
  }

  // Método para atualizar a quantidade
  void updateItemQuantity(CartItem item, int novaQuantidade) {
    if (novaQuantidade == 0) {
      removeFromCart(item);
    } else {
      item.quantidade = novaQuantidade;
      notifyListeners();
    }
  }

  // Método para limpar o carrinho
  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}