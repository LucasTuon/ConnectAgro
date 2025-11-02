// Modelo que representa um usuario (produtor)
// Serve para mapear os dados recebidos da API
class Usuario {
  final int id;
  final String nome;
  final String? nomeEstabelecimento;
  final String? cidade;
  final String? estado;
  final String? fotoUrl;

  Usuario({
    required this.id,
    required this.nome,
    this.nomeEstabelecimento,
    this.cidade,
    this.estado,
    this.fotoUrl,
  });

  // Metodo para criar um objeto Usuario a partir de um JSON
  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'],
      nome: json['nome'],
      nomeEstabelecimento: json['nome_estabelecimento'],
      cidade: json['cidade'],
      estado: json['estado'],
      fotoUrl: json['foto_url'],
    );
  }
}