// Enum para as categorias de produtos, baseado no seu Figma.
enum CategoriaProduto {
  vegetais,
  frutas,
  ervas,
  cereais,
}

class Produto {
  final int? id;
  final String nome;
  final String descricao;
  final double preco;
  final String? unidade;
  final String imagemUrl; 
  final CategoriaProduto categoria;
  final int produtorId;
  final int? quantidadeEstoque;
  final double? avaliacaoMedia;
  final int? totalAvaliacoes;
  final DateTime? dataColheita;

  Produto({
    this.id,
    required this.nome,
    required this.descricao,
    required this.preco,
    this.unidade,
    required this.imagemUrl,
    required this.categoria,
    required this.produtorId,
    this.quantidadeEstoque,
    this.avaliacaoMedia,
    this.totalAvaliacoes,
    this.dataColheita,
  });
}