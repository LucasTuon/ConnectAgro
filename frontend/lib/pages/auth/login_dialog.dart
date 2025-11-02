import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../services/auth_service.dart'; 
import '../profile_page.dart';

// Nesse codigo, criamos um dialogo de login e cadastro
// que permite ao usuario entrar na sua conta ou criar uma nova

class LoginDialog extends StatefulWidget {
  const LoginDialog({super.key});

  @override
  State<LoginDialog> createState() => _LoginDialogState();
}

class _LoginDialogState extends State<LoginDialog> {
  bool _isLoginView = true;
  bool _isLoading = false;

  final ApiService _apiService = ApiService();
  final AuthService _authService = AuthService();

  final _loginEmailController = TextEditingController();
  final _loginSenhaController = TextEditingController();
  final _cadastroNomeController = TextEditingController();
  final _cadastroEmailController = TextEditingController();
  final _cadastroSenhaController = TextEditingController();
  final _cadastroEstabelecimentoController = TextEditingController();
  final _cadastroCidadeController = TextEditingController();
  final _cadastroEstadoController = TextEditingController();
  String? _selectedUserType;

  @override
  void dispose() {
    _loginEmailController.dispose();
    _loginSenhaController.dispose();
    _cadastroNomeController.dispose();
    _cadastroEmailController.dispose();
    _cadastroSenhaController.dispose();
    _cadastroEstabelecimentoController.dispose();
    _cadastroCidadeController.dispose();
    _cadastroEstadoController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_loginEmailController.text.isEmpty || _loginSenhaController.text.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preencha e-mail e senha.'), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() { _isLoading = true; });

    try {
      final userData = await _apiService.login(
        email: _loginEmailController.text,
        senha: _loginSenhaController.text,
      );

      if (!mounted) return;

      _authService.login(userData);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bem-vindo, ${userData['nome']}!'), backgroundColor: Colors.green),
      );

      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => ProfilePage(userData: userData)),
      );

    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Falha no login: ${e.toString().replaceFirst("Exception: ", "")}'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) {
        setState(() { _isLoading = false; });
      }
    }
  }

  Future<void> _handleCadastro() async {
    if (_cadastroNomeController.text.isEmpty ||
        _cadastroEmailController.text.isEmpty ||
        _cadastroSenhaController.text.isEmpty ||
        _cadastroEstabelecimentoController.text.isEmpty ||
        _cadastroCidadeController.text.isEmpty ||
        _cadastroEstadoController.text.isEmpty ||
        _selectedUserType == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preencha todos os campos obrigatórios.'), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() { _isLoading = true; });

    try {
      await _apiService.cadastrarUsuario(
        nome: _cadastroNomeController.text,
        email: _cadastroEmailController.text,
        senha: _cadastroSenhaController.text,
        nomeEstabelecimento: _cadastroEstabelecimentoController.text,
        cidade: _cadastroCidadeController.text,
        estado: _cadastroEstadoController.text,
        tipoUsuario: _selectedUserType!,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cadastro realizado com sucesso!'), backgroundColor: Colors.green),
      );
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro no cadastro: ${e.toString().replaceFirst("Exception: ", "")}'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) {
        setState(() { _isLoading = false; });
      }
    }
  }

  // Construindo o widget
  @override
  Widget build(BuildContext context) {
    const Color primaryTextColor = Color.fromARGB(255, 40, 106, 41);

    return Dialog(
      backgroundColor: const Color(0xFFF5F5F5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 400,
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Acesse sua conta ConnectAgro',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: primaryTextColor),
                ),
                const SizedBox(height: 8),
                const Text('Entre na sua conta ou crie uma nova para começar a comprar produtos orgânicos', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 16)),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(child: _buildTabButton('Entrar', _isLoginView)),
                    Expanded(child: _buildTabButton('Cadastrar', !_isLoginView)),
                  ],
                ),
                const SizedBox(height: 32),
                SizedBox(
                  height: 450,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _isLoginView ? _buildLoginForm() : _buildRegisterForm(),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
              style: IconButton.styleFrom(backgroundColor: Colors.transparent, foregroundColor: Colors.grey[800]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String text, bool isSelected) {
    final Color primaryGreen = Colors.green.shade700;
    final Color faintGray = Colors.grey.shade300;
    return InkWell(
      onTap: () {
        setState(() { _isLoginView = (text == 'Entrar'); });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: isSelected ? primaryGreen : faintGray, width: isSelected ? 2 : 1),
        ),
        child: Center(
          child: Text(text, style: TextStyle(color: isSelected ? primaryGreen : Colors.grey.shade600, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, fontSize: 16)),
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    final inputDecoration = InputDecoration(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.green.shade700, width: 2)),
    );
    return Column(
      key: const ValueKey('loginForm'),
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        TextField(controller: _loginEmailController, decoration: inputDecoration.copyWith(labelText: 'Email *'), keyboardType: TextInputType.emailAddress),
        const SizedBox(height: 16),
        TextField(controller: _loginSenhaController, decoration: inputDecoration.copyWith(labelText: 'Senha *'), obscureText: true),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: _isLoading ? null : _handleLogin,
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade600, minimumSize: const Size(double.infinity, 55), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
          child: _isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text('Entrar', style: TextStyle(fontSize: 18, color: Colors.white)),
        ),
      ],
    );
  }

  Widget _buildRegisterForm() {
    final inputDecoration = InputDecoration(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.green.shade700, width: 2)),
    );
    return SingleChildScrollView(
      key: const ValueKey('registerForm'),
      child: Column(
        children: [
          TextField(controller: _cadastroNomeController, decoration: inputDecoration.copyWith(labelText: 'Nome Completo *')),
          const SizedBox(height: 16),
          TextField(controller: _cadastroEmailController, decoration: inputDecoration.copyWith(labelText: 'Email *'), keyboardType: TextInputType.emailAddress),
          const SizedBox(height: 16),
          TextField(controller: _cadastroSenhaController, decoration: inputDecoration.copyWith(labelText: 'Senha *'), obscureText: true),
          const SizedBox(height: 16),
          TextField(controller: _cadastroEstabelecimentoController, decoration: inputDecoration.copyWith(labelText: 'Nome do Estabelecimento/Horta *')),
          const SizedBox(height: 16),
          TextField(controller: _cadastroCidadeController, decoration: inputDecoration.copyWith(labelText: 'Cidade *')),
          const SizedBox(height: 16),
          TextField(controller: _cadastroEstadoController, decoration: inputDecoration.copyWith(labelText: 'Estado (UF) *')),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _selectedUserType,
            decoration: inputDecoration.copyWith(labelText: 'Tipo de Conta *'),
            hint: const Text('Selecione uma opção'),
            items: const [
              DropdownMenuItem(value: 'produtor', child: Text('Sou Produtor')),
              DropdownMenuItem(value: 'ponto_de_venda', child: Text('Sou Ponto de Venda')),
            ],
            onChanged: (String? newValue) { setState(() { _selectedUserType = newValue; }); },
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _isLoading ? null : _handleCadastro,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade600, minimumSize: const Size(double.infinity, 55), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
            child: _isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text('Cadastrar', style: TextStyle(fontSize: 18, color: Colors.white)),
          ),
        ],
      ),
    );
  }
}