
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

  // Este construtor especial sabe como converter o JSON da API em um objeto Usuario.
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