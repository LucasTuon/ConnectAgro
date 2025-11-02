enum TipoUsuario {
  produtor,
  pontoDeVenda,
}

class Usuario {
  final int? id;
  final String nome;
  final String email;
  final String senha;
  final TipoUsuario tipoUsuario;
  final String? nomeEstabelecimento;
  final String? cidade;
  final String? estado;
  final String? fotoUrl;

  Usuario({
    this.id,
    required this.nome,
    required this.email,
    required this.senha,
    required this.tipoUsuario,
    this.nomeEstabelecimento,
    this.cidade,
    this.estado,
    this.fotoUrl,
  });
}