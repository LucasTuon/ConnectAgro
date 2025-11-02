import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../models/produto.dart';

// Servico singleton para gerenciar o carrinho de compras

class CartService extends ChangeNotifier {
  
  static final CartService _instance = CartService._internal();
  factory CartService() {
    return _instance;
  }
  CartService._internal();

  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  // Metodo para adicionar um produto ao carrinho
  void addToCart(Produto produto) {
    // Verifica se o item ja existe no carrinho
    for (var item in _items) {
      if (item.produto.id == produto.id) {
        item.incrementar();
        notifyListeners(); 
        return;
      }
    }

    // Se nao existe, adiciona um novo item
    _items.add(CartItem(produto: produto));
    notifyListeners();
  }

  // Metodo para remover um item do carrinho
  void removeFromCart(CartItem item) {
    _items.remove(item);
    notifyListeners();
  }

  // Metodo para atualizar a quantidade
  void updateItemQuantity(CartItem item, int novaQuantidade) {
    if (novaQuantidade == 0) {
      removeFromCart(item);
    } else {
      item.quantidade = novaQuantidade;
      notifyListeners();
    }
  }

  // Metodo para limpar o carrinho
  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}