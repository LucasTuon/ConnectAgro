
// Modelo que representa um produto
// Serve para mapear os dados recebidos da API
class Produto {
  final int id;
  final String nome;
  final String descricao;
  final double preco;
  final String? unidade; 
  final String imagemUrl;
  final String categoria;
  final int quantidadeEstoque;
  final double avaliacaoMedia;
  final int totalAvaliacoes;
  final int produtorId;

  Produto({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.preco,
    this.unidade,
    required this.imagemUrl,
    required this.categoria,
    required this.quantidadeEstoque,
    required this.avaliacaoMedia,
    required this.totalAvaliacoes,
    required this.produtorId,
  });

  // Metodo para criar um objeto Produto a partir de um JSON
  factory Produto.fromJson(Map<String, dynamic> json) {
    return Produto(
      id: json['id'],
      nome: json['nome'],
      descricao: json['descricao'],
      preco: (json['preco'] as num).toDouble(),
      unidade: json['unidade'],
      imagemUrl: json['imagemUrl'],
      categoria: json['categoria'],
      quantidadeEstoque: json['quantidade_estoque'] ?? 0,
      avaliacaoMedia: (json['avaliacao_media'] as num?)?.toDouble() ?? 0.0,
      totalAvaliacoes: json['total_avaliacoes'] ?? 0,
      produtorId: json['produtorId'],
    );
  }
}