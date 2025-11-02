import 'package:flutter/material.dart';
import '../services/api_service.dart';

// Dialogo para adicionar um novo produto

class AddProductDialog extends StatefulWidget {

  final int produtorId;
  const AddProductDialog({super.key, required this.produtorId});

  @override
  State<AddProductDialog> createState() => _AddProductDialogState();
}

class _AddProductDialogState extends State<AddProductDialog> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();
  bool _isLoading = false;

  final _nomeController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _precoController = TextEditingController();
  final _unidadeController = TextEditingController();
  final _estoqueController = TextEditingController();
  final _imageUrlController = TextEditingController();
  String? _selectedCategory;

  @override
  void dispose() {
    _nomeController.dispose();
    _descricaoController.dispose();
    _precoController.dispose();
    _unidadeController.dispose();
    _estoqueController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  // Logica para salvar o produto
  Future<void> _handleSalvarProduto() async {
    // Valida se todos os campos do formulario foram preenchidos corretamente
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() { _isLoading = true; });

    try {
      await _apiService.cadastrarProduto(
        nome: _nomeController.text,
        descricao: _descricaoController.text,
        preco: double.parse(_precoController.text.replaceAll(',', '.')), // Substitui vírgula por ponto
        unidade: _unidadeController.text,
        estoque: int.parse(_estoqueController.text),
        categoria: _selectedCategory!,
        imagemUrl: _imageUrlController.text,
        produtorId: widget.produtorId,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Produto cadastrado com sucesso!'), backgroundColor: Colors.green));
      Navigator.of(context).pop(true); // Retorna 'true' para indicar sucesso

    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao cadastrar: ${e.toString()}'), backgroundColor: Colors.red));
    } finally {
      if (mounted) {
        setState(() { _isLoading = false; });
      }
    }
  }

  // Build do dialogo
  @override
  Widget build(BuildContext context) {
    final primaryGreen = Colors.green.shade700;
    final inputDecoration = InputDecoration(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
    );

    return Dialog(
      backgroundColor: const Color(0xFFF0FFF0), // Fundo verde claro
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Container(
        padding: const EdgeInsets.all(24.0),
        width: 500, // Um pouco mais largo para o formulario
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Adicionar Novo Produto', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: primaryGreen)),
              const SizedBox(height: 24),
              TextFormField(controller: _nomeController, decoration: inputDecoration.copyWith(labelText: 'Nome do Produto *'), validator: (v) => v!.isEmpty ? 'Campo obrigatório' : null),
              const SizedBox(height: 16),
              TextFormField(controller: _descricaoController, decoration: inputDecoration.copyWith(labelText: 'Descrição *'), maxLines: 3, validator: (v) => v!.isEmpty ? 'Campo obrigatório' : null),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: TextFormField(controller: _precoController, decoration: inputDecoration.copyWith(labelText: 'Preço *'), keyboardType: TextInputType.number, validator: (v) => v!.isEmpty ? 'Obrigatório' : null)),
                  const SizedBox(width: 16),
                  Expanded(child: TextFormField(controller: _unidadeController, decoration: inputDecoration.copyWith(labelText: 'Unidade (kg, maço)*'), validator: (v) => v!.isEmpty ? 'Obrigatório' : null)),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(controller: _estoqueController, decoration: inputDecoration.copyWith(labelText: 'Estoque *'), keyboardType: TextInputType.number, validator: (v) => v!.isEmpty ? 'Obrigatório' : null),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: inputDecoration.copyWith(labelText: 'Categoria *'),
                hint: const Text('Selecione uma Categoria'),
                items: const [
                  DropdownMenuItem(value: 'frutas', child: Text('Frutas')),
                  DropdownMenuItem(value: 'vegetais', child: Text('Vegetais')),
                  DropdownMenuItem(value: 'ervas', child: Text('Ervas e Especiarias')),
                  DropdownMenuItem(value: 'cereais', child: Text('Cereais e Grãos')),
                ],
                onChanged: (String? newValue) {
                  setState(() { _selectedCategory = newValue; });
                },
                validator: (v) => v == null ? 'Selecione uma categoria' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(controller: _imageUrlController, decoration: inputDecoration.copyWith(labelText: 'URL da Imagem *'), validator: (v) => v!.isEmpty ? 'Campo obrigatório' : null),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(onPressed: _isLoading ? null : () => Navigator.of(context).pop(), child: Text('Cancelar', style: TextStyle(color: primaryGreen))),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _handleSalvarProduto,
                    style: ElevatedButton.styleFrom(backgroundColor: primaryGreen, foregroundColor: Colors.white),
                    child: _isLoading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Text('Salvar Produto'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}