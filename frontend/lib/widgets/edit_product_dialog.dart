import 'package:flutter/material.dart';
import '../models/produto.dart';
import '../services/api_service.dart';

class EditProductDialog extends StatefulWidget {
  final Produto produto; // Recebe o produto a ser editado
  const EditProductDialog({super.key, required this.produto});

  @override
  State<EditProductDialog> createState() => _EditProductDialogState();
}

class _EditProductDialogState extends State<EditProductDialog> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();
  bool _isLoading = false;

  late TextEditingController _nomeController;
  late TextEditingController _descricaoController;
  late TextEditingController _precoController;
  late TextEditingController _unidadeController;
  late TextEditingController _estoqueController;
  late TextEditingController _imageUrlController;
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    // Pré-preenche os campos com os dados do produto existente
    _nomeController = TextEditingController(text: widget.produto.nome);
    _descricaoController = TextEditingController(text: widget.produto.descricao);
    _precoController = TextEditingController(text: widget.produto.preco.toString());
    _unidadeController = TextEditingController(text: widget.produto.unidade);
    _estoqueController = TextEditingController(text: widget.produto.quantidadeEstoque.toString());
    _imageUrlController = TextEditingController(text: widget.produto.imagemUrl);
    _selectedCategory = widget.produto.categoria;
  }

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

  Future<void> _handleSalvarAlteracoes() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() { _isLoading = true; });

    final data = {
      'nome': _nomeController.text,
      'descricao': _descricaoController.text,
      'preco': double.parse(_precoController.text.replaceAll(',', '.')),
      'unidade': _unidadeController.text,
      'quantidade_estoque': int.parse(_estoqueController.text),
      'categoria': _selectedCategory,
      'imagemUrl': _imageUrlController.text,
    };

    try {
      await _apiService.atualizarProduto(widget.produto.id, data);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Produto atualizado com sucesso!'), backgroundColor: Colors.green));
      Navigator.of(context).pop(true); // Retorna 'true' para indicar sucesso
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao atualizar: ${e.toString()}'), backgroundColor: Colors.red));
    } finally {
      if (mounted) {
        setState(() { _isLoading = false; });
      }
    }
  }

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
      backgroundColor: const Color(0xFFF0FFF0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Container(
        padding: const EdgeInsets.all(24.0),
        width: 500,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Editar Produto', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: primaryGreen)),
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
                    onPressed: _isLoading ? null : _handleSalvarAlteracoes,
                    style: ElevatedButton.styleFrom(backgroundColor: primaryGreen, foregroundColor: Colors.white),
                    child: _isLoading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Text('Salvar Alterações'),
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