import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {
  // --- Padrão Singleton ---
  static final AuthService _instance = AuthService._internal();
  factory AuthService() {
    return _instance;
  }
  AuthService._internal();
  // -------------------------

  Map<String, dynamic>? _currentUser;

  Map<String, dynamic>? get currentUser => _currentUser;

  bool get isLoggedIn => _currentUser != null;

  // Chamado quando o login é bem-sucedido
  void login(Map<String, dynamic> userData) {
    _currentUser = userData;
    notifyListeners(); // Avisa aos widgets (ex: AppBar) que o usuário mudou
  }

  // Chamado quando o usuário clica em "Sair"
  void logout() {
    _currentUser = null;
    notifyListeners(); // Avisa que o usuário saiu
  }
}